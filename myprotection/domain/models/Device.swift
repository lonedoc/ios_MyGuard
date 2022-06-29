//
//  Device.swift
//  myprotection
//
//  Created by Rubeg NPO on 21.06.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation

class Device {
    let deviceType: DeviceType
    let number: Int
    let description: String

    init(deviceType: DeviceType, number: Int, description: String) {
        self.deviceType = deviceType
        self.number = number
        self.description = description
    }

    static func create(from dto: DeviceDTO) throws -> Device {
        let deviceType: DeviceType = DeviceType.init(rawValue: dto.deviceType) ?? .unknownDevice

        switch deviceType {
        case .cerberThermostat:
            return CerberThermostat(
                deviceType: deviceType,
                number: dto.number,
                description: dto.description,
                temperature: dto.temperature ?? 0.0,
                isOnline: dto.isOnline == 1
            )
        case .unknownDevice:
            return UnknownDevice(description: dto.description)
        }
    }
}

class CerberThermostat: Device {
    let temperature: Double
    let isOnline: Bool

    init(deviceType: DeviceType, number: Int, description: String, temperature: Double, isOnline: Bool) {
        self.temperature = temperature
        self.isOnline = isOnline

        super.init(deviceType: deviceType, number: number, description: description)
    }

}

class UnknownDevice: Device {
    init(description: String) {
        super.init(
            deviceType: .unknownDevice,
            number: 0,
            description: description
        )
    }
}
