//
//  FacilityInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 17.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

private let cancellationTimeKeyPrefix = "cancellation_time_"

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

    func cancelAlarm(facilityId: String, passcode: String) -> Observable<Bool> {
        return facilitiesApi.cancelAlarm(facilityId: facilityId, passcode: passcode)
    }

    func setLastCancellationTime(facilityId: String, time: Int?) {
        let key = "\(cancellationTimeKeyPrefix)\(facilityId)"

        if time == nil {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(time!, forKey: key)
        }
    }

    func getLastCancellationTime(facilityId: String) -> Int? {
        return UserDefaults.standard.integer(forKey: "\(cancellationTimeKeyPrefix)\(facilityId)")
    }

}
