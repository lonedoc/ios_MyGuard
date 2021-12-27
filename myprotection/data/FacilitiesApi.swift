//
//  ObjectsApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

protocol FacilitiesApi {
    func getFacilities(attempts: Int) -> Observable<[Facility]>
    func getFacility(facilityId: String) -> Observable<Facility>
    func setName(facilityId: String, name: String) -> Observable<Bool>
    func setStatus(facilityId: String, statusCode: Int) -> Observable<Bool>
    func sendAlarm(facilityId: String) -> Observable<Bool>
}
