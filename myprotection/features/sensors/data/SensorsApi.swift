//
//  SensorsApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 27.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

protocol SensorsApi {
    func getSensors(facilityId: String) -> Observable<[Sensor]>
}
