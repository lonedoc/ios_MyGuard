//
//  Sensor.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

enum SensorType {
    case temperature, humidity
}

struct Sensor {
    let type: SensorType
    let name: String
    let data: Any
}
