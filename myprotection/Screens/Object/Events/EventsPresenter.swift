//
//  EventsPresenter.swift
//  myprotection
//
//  Created by Rubeg NPO on 05.04.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RubegProtocol_v2_0
import RxSwift

fileprivate typealias Range = (
    start: Int,
    end: Int
)

fileprivate enum DbError: Error {
    case unavailable
}

extension EventsPresenter: EventsContract.Presenter {

    func attach(view: EventsContract.View) {
        self.view = view
    }

    func viewDidLoad() {
        view?.showPlaceholder()
        fetchNewEvents()
    }

    func viewWillAppear() {
        startPolling()
    }

    func viewWillDisappear() {
        stopPolling()
    }

    func viewWentBackground() {
        stopPolling()
    }

    func viewWentForeground() {
        startPolling()
    }

    func refresh() {
        fetchNewEvents(userInitiated: true)
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .seconds(1)) {
            self.view?.hideRefresher()
        }
    }

    func endOfTableReached() {
        let range = getRange()
        if range.end - range.start <= 0 {
            return
        }

        let result = loadCachedEvents(range: range)
        if case .success(let cachedEvents) = result {
            if cachedEvents.count >= range.end - range.start {
                updateEvents(with: cachedEvents)
                updateView()
                return
            }
        }

        fetchNewEvents(position: range.start)
    }

}

// MARK: -

class EventsPresenter {

    private var view: EventsContract.View?
    private let objectsGateway: ObjectsGateway
    private let unitOfWork: UnitOfWork?

    private let communicationData: CommunicationData

    private let objectId: String
    private var events = [Event]()

    private let disposeBag = DisposeBag()

    private var timer: Timer?

    init(
        objectId: String,
        communicationData: CommunicationData,
        objectsGateway: ObjectsGateway,
        unitOfWork: UnitOfWork? = nil
    ) {
        self.objectId = objectId
        self.communicationData = communicationData
        self.objectsGateway = objectsGateway
        self.unitOfWork = unitOfWork
    }

    private func startPolling() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopPolling() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func tick() {
        fetchNewEvents()
    }

    private func fetchNewEvents(position: Int? = nil, userInitiated: Bool = false) {
        guard let token = communicationData.token else {
            return
        }

        makeEventsRequest(
            address: communicationData.address,
            token: token,
            position: position,
            userInitiated: userInitiated
        )
    }

    private func makeEventsRequest(
        address: InetAddress,
        token: String,
        position: Int? = nil,
        userInitiated: Bool = false
    ) {
        let result: Observable<[Event]>
        if let position = position {
            result = objectsGateway.getEvents(
                address: address,
                token: token,
                objectId: objectId,
                position: position
            )
        } else {
            result = objectsGateway.getEvents(
                address: address,
                token: token,
                objectId: objectId
            )
        }

        result
            .subscribe(
                onNext: { [weak self] newEvents in
                    self?.handleNewEvents(newEvents)
                    self?.view?.hidePlaceholder()
                    self?.view?.hideRefresher()
                    self?.objectsGateway.close()
                },
                onError: { [weak self] error in
                    defer { self?.objectsGateway.close() }

                    if !userInitiated {
                        return
                    }

                    guard let errorMessage = self?.getErrorMessage(by: error) else {
                        return
                    }

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage
                    )
                }
            )
            .disposed(by: disposeBag)
    }

    private func handleNewEvents(_ newEvents: [Event]) {
        if isSubset(of: events, content: newEvents) {
            return
        }

        _ = save(events: newEvents)
        updateEvents(with: newEvents)
        updateView()
    }

    private func isSubset(of arr: [Event], content: [Event]) -> Bool {
        let containingSet = Set(arr.map { $0.number })
        let contentSet = Set(content.map { $0.number })
        return contentSet.isSubset(of: containingSet)
    }

    private func save(events: [Event]) -> Bool {
        guard let unitOfWork = unitOfWork else {
            return false
        }

        events.forEach { event in
            _ = unitOfWork.eventRepository.create(event: event)
        }

        let saved = unitOfWork.saveChanges()
        if case .failure(_) = saved {
            return false
        }

        return true
    }

    private func updateEvents(with newEvents: [Event]) {
        let merged = merge(events, newEvents)
        let sorted = merged.sorted(by: areInDecreasedOrderByTimestamp(_:_:))
        events = sorted
    }

    private func merge(_ lhs: [Event], _ rhs: [Event]) -> [Event] {
        var result = lhs
        rhs.forEach { rightItem in
            let isNewItem = !lhs.contains { leftItem in leftItem == rightItem }
            if isNewItem {
                result.append(rightItem)
            }
        }
        return result
    }

    private func areInDecreasedOrderByTimestamp(_ lhs: Event, _ rhs: Event) -> Bool {
        guard let lhsTimestamp = lhs.timestamp else { return false }
        guard let rhsTimestamp = rhs.timestamp else { return true }
        return lhsTimestamp > rhsTimestamp
    }

    private func updateView() {
        view?.setEvents(events)
        view?.hidePlaceholder()
    }

    private func getErrorMessage(by error: Error) -> String {
        guard let error = error as? CommunicationError else {
            return "Unknown error".localized
        }

        switch error.type {
        case .socketError:
            return "Unknown error".localized // TODO: Make specific error message
        case .serverError:
            return "Server not responding".localized
        case .internalServerError:
            return "The operation could not be performed".localized
        case .parseError:
            return "Unable to read server response".localized
        case .authError:
            return "Wrong password".localized
        }
    }

    private func getRange() -> Range {
        guard
            let upperBound = (events.min { lhs, rhs in lhs.number < rhs.number })?.number
        else {
            return Range(1, 1)
        }

        var lowerBound = upperBound - 20
        if lowerBound < 1 {
            lowerBound = 1
        }

        return Range(lowerBound, upperBound)
    }

    private func loadCachedEvents(range: Range? = nil) -> Result<[Event], Error> {
        guard let unitOfWork = unitOfWork else {
            return .failure(DbError.unavailable)
        }

        if let range = range {
            return unitOfWork.eventRepository.getEvents(
                objectId: objectId,
                lowerBound: range.start,
                upperBound: range.end
            )
        } else {
            return unitOfWork.eventRepository.getEvents(objectId: objectId)
        }
    }

}
