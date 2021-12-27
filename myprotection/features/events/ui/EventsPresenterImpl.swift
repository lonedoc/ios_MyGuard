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

private enum DbError: Error {
    case unavailable
}

extension EventsPresenterImpl: EventsPresenter {

    func attach(view: EventsView) {
        self.view = view
    }

    func viewDidLoad() {
        view?.showPlaceholder()
        loadEvents(range: nil, userInitiated: false)
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
        loadEvents(range: nil, userInitiated: true)
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .seconds(1)) {
            self.view?.hideRefresher()
        }
    }

    func endOfTableReached() {
        let range = getRange()
        if range.end - range.start <= 0 {
            return
        }

        loadEvents(range: range, userInitiated: false)
    }

}

// MARK: -

private let pollingInterval: TimeInterval = 15

class EventsPresenterImpl {

    private var view: EventsView?
    private let interactor: EventsInteractor

    private let disposeBag = DisposeBag()

    private let facilityId: String
    private var events = [Event]()

    private var timer: Timer?

    init(facilityId: String, interactor: EventsInteractor) {
        self.facilityId = facilityId
        self.interactor = interactor
    }

    private func startPolling() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: pollingInterval,
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
        loadEvents(range: nil, userInitiated: false)
    }

    private func loadEvents(range: EventNumberRange?, userInitiated: Bool) {
        let eventsObservable: Observable<[Event]>
        if let range = range {
            eventsObservable = interactor.getEvents(
                facilityId: facilityId,
                range: range,
                userInitiated: userInitiated
            )
        } else {
            eventsObservable = interactor.getEvents(
                facilityId: facilityId,
                userInitiated: userInitiated
            )
        }

        eventsObservable
            .subscribe(
                onNext: { [weak self] events in
                    self?.updateEvents(with: events)
                    self?.updateView()
                },
                onError: { [weak self] error in
                    if !userInitiated {
                        return
                    }

                    let errorMessage = getErrorMessage(by: error)

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage
                    )
                }
            )
            .disposed(by: disposeBag)
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
        view?.hideRefresher()
    }

    private func getRange() -> EventNumberRange {
        guard
            let upperBound = (events.min { lhs, rhs in lhs.number < rhs.number })?.number
        else {
            return EventNumberRange(1, 1)
        }

        var lowerBound = upperBound - 20
        if lowerBound < 1 {
            lowerBound = 1
        }

        return EventNumberRange(lowerBound, upperBound)
    }

}
