//
//  EventsInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 20.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

class EventsInteractor {

    private let repository: EventsRepository

    init(repository: EventsRepository) {
        self.repository = repository
    }

    func getEvents(facilityId: String, userInitiated: Bool) -> Observable<[Event]> {
        return repository.getEvents(facilityId: facilityId, userInitiated: userInitiated)
    }

    func getEvents(facilityId: String, range: EventNumberRange, userInitiated: Bool) -> Observable<[Event]> {
        return repository.getEvents(
            facilityId: facilityId,
            range: range,
            userInitiated: userInitiated
        )
    }

}
