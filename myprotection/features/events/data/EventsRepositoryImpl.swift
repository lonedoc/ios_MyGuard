//
//  EventsRepositoryImpl.swift
//  myprotection
//
//  Created by Rubeg NPO on 20.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

class EventsRepositoryImpl: EventsRepository {

    private let eventsApi: EventsApi
    private let unitOfWork: UnitOfWork?

    private let disposeBag = DisposeBag()

    init(eventsApi: EventsApi, unitOfWork: UnitOfWork?) {
        self.eventsApi = eventsApi
        self.unitOfWork = unitOfWork
    }

    func getEvents(facilityId: String, userInitiated: Bool) -> Observable<[Event]> {
        let eventsObservable = eventsApi.getEvents(
            facilityId: facilityId,
            position: nil,
            attempts: userInitiated ? 3 : 1
        )

        if unitOfWork == nil {
            return eventsObservable
        }

        let result = PublishSubject<[Event]>()

        eventsObservable
            .subscribe(
                onNext: { [weak self] events in
                    self?.updateLocalEvents(events)
                    result.onNext(events)
                },
                onError: { error in
                    result.onError(error)
                }
            )
            .disposed(by: disposeBag)

        return result
    }

    func getEvents(facilityId: String, range: EventNumberRange, userInitiated: Bool) -> Observable<[Event]> {
        if unitOfWork == nil {
            return eventsApi.getEvents(
                facilityId: facilityId,
                position: range.start,
                attempts: userInitiated ? 3 : 1
            )
        }

        guard let localEvents = loadCachedEvents(facilityId: facilityId, range: range) else {
            return eventsApi.getEvents(
                facilityId: facilityId,
                position: range.start,
                attempts: userInitiated ? 3 : 1
            )
        }

        let expectedEventsCount = range.end - range.start

        if localEvents.count == expectedEventsCount {
            return Observable.just(localEvents)
        }

        let result = PublishSubject<[Event]>()

        eventsApi.getEvents(
            facilityId: facilityId,
            position: range.start,
            attempts: userInitiated ? 3 : 1
        )
            .subscribe(
                onNext: { [weak self] events in
                    self?.updateLocalEvents(events)
                    result.onNext(events)
                },
                onError: { error in
                    result.onError(error)
                }
            )
            .disposed(by: disposeBag)

        return result
    }

    private func updateLocalEvents(_ events: [Event]) {
        if events.isEmpty {
            return
        }

        let facilityId = events[0].facilityId
        let localEvents = loadCachedEvents(facilityId: facilityId, range: nil)

        let localEventNumbers: Set<Int>
        if let localEvents = localEvents {
            localEventNumbers = Set(localEvents.map { $0.number })
        } else {
            localEventNumbers = Set()
        }

        events.forEach { event in
            if !localEventNumbers.contains(event.number) {
                _ = unitOfWork?.eventRepository.create(event: event)
            }
        }

        _ = unitOfWork?.saveChanges()
    }

    private func loadCachedEvents(facilityId: String, range: EventNumberRange?) -> [Event]? {
        guard let unitOfWork = unitOfWork else {
            return nil
        }

        let result: Result<[Event], Error>

        if let range = range {
            result = unitOfWork.eventRepository.getEvents(
                facilityId: facilityId,
                lowerBound: range.start,
                upperBound: range.end
            )
        } else {
            result = unitOfWork.eventRepository.getEvents(facilityId: facilityId)
        }

        if case .success(let events) = result {
            return events
        } else {
            return nil
        }
    }

}
