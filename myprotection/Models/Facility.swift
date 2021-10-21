//
//  Facility.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

class Facility {
    var id: String // swiftlint:disable:this identifier_name
    var name: String
    var address: String
    var selfService: Bool
    var online: Bool
    var onlineEnabled: Bool
    var statusCode: StatusCode
    var status: String
    var batteryMalfunction: Bool
    var powerSupplyMalfunction: Bool
    var armingEnabled: Bool
    var alarmButtonEnabled: Bool

    init(_ dto: FacilityDTO) {
        id = dto.id
        name = dto.name
        address = dto.address
        selfService = dto.selfService == 1
        online = dto.online == 1
        onlineEnabled = dto.onlineEnabled == 1
        status = dto.status
        batteryMalfunction = dto.batteryMalfunction == 1
        powerSupplyMalfunction = dto.powerSupplyMalfunction == 1
        armingEnabled = dto.armingEnabled != 1
        alarmButtonEnabled = dto.alarmButtonEnabled == 1

        statusCode = StatusCode(
            text: dto.statusCode,
            perimeterOnly: dto.perimeterOnly == 1
        )
    }
}
