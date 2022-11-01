//
//  ObjectsInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

class FacilitiesInteractor {

    private let userDefaultsHelper: UserDefaultsHelper
    private let guardServicesApi: GuardServicesApi
    private let facilitiesApi: FacilitiesApi

    init(userDefaultsHelper: UserDefaultsHelper, guardServicesApi: GuardServicesApi, facilitiesApi: FacilitiesApi) {
        self.userDefaultsHelper = userDefaultsHelper
        self.guardServicesApi = guardServicesApi
        self.facilitiesApi = facilitiesApi
    }

    func getGuardService() -> GuardService? {
        return userDefaultsHelper.getGuardService()
    }

    func saveGuardService(_ guardService: GuardService) {
        userDefaultsHelper.set(guardService: guardService)
    }

    func getAddresses(cityName: String, guardServiceName: String) -> Observable<[String]> {
        return guardServicesApi.getAddresses(cityName: cityName, guardServiceName: guardServiceName)
    }

    func getFacilities(userInitiated: Bool) -> Observable<FacilitiesResponse> {
        let attempts = userInitiated ? 3 : 1
        return facilitiesApi.getFacilities(attempts: attempts)
    }

}
