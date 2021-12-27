//
//  EventsApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 20.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

protocol EventsApi {
    func getEvents(facilityId: String, position: Int?, attempts: Int) -> Observable<[Event]>
}

extension EventsApi {
    func getEvents(facilityId: String, attempts: Int) -> Observable<[Event]> {
        return getEvents(facilityId: facilityId, position: nil, attempts: attempts)
    }
}
