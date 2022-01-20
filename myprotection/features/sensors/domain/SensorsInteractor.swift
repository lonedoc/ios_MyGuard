//
//  SensorsInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 27.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

class SensorsInteractor {

    private let sensorsApi: SensorsApi

    init(sensorsApi: SensorsApi) {
        self.sensorsApi = sensorsApi
    }

    func getSensors(facilityId: String) -> Observable<[Sensor]> {
        return sensorsApi.getSensors(facilityId: facilityId)
    }

}
