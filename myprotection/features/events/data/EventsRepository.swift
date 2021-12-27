//
//  EventsRepository.swift
//  myprotection
//
//  Created by Rubeg NPO on 20.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

typealias EventNumberRange = (
    start: Int,
    end: Int
)

protocol EventsRepository {
    func getEvents(facilityId: String, userInitiated: Bool) -> Observable<[Event]>
    func getEvents(facilityId: String, range: EventNumberRange, userInitiated: Bool) -> Observable<[Event]>
}
