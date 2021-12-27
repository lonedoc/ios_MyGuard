//
//  FacilityInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 17.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

class FacilityInteractor {

    private let facilitiesApi: FacilitiesApi

    init(facilitiesApi: FacilitiesApi) {
        self.facilitiesApi = facilitiesApi
    }

    func getFacility(facilityId: String) -> Observable<Facility> {
        return facilitiesApi.getFacility(facilityId: facilityId)
    }

    func setName(facilityId: String, name: String) -> Observable<Bool> {
        return facilitiesApi.setName(facilityId: facilityId, name: name)
    }

    func setStatus(facilityId: String, statusCode: Int) -> Observable<Bool> {
        return facilitiesApi.setStatus(facilityId: facilityId, statusCode: statusCode)
    }

    func sendAlarm(facilityId: String) -> Observable<Bool> {
        return facilitiesApi.sendAlarm(facilityId: facilityId)
    }

}
