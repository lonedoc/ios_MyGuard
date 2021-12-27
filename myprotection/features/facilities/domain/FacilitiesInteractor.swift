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

    private let facilitiesApi: FacilitiesApi

    init(facilitiesApi: FacilitiesApi) {
        self.facilitiesApi = facilitiesApi
    }

    func getFacilities(userInitiated: Bool) -> Observable<[Facility]> {
        let attempts = userInitiated ? 3 : 1
        return facilitiesApi.getFacilities(attempts: attempts)
    }

}
