//
//  Facility.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

class Facility {
    var id: String
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
    var passcode: String?
    var isApplicationsAvailable: Bool
    var devices: [Device]
    var accounts: [Account]

    init(_ dto: FacilityDTO) { // swiftlint:disable:this function_body_length
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
        passcode = dto.passcode
        isApplicationsAvailable = dto.isApplicationsAvailable == 1

        statusCode = StatusCode(
            text: dto.statusCode,
            perimeterOnly: dto.perimeterOnly == 1
        )

        devices = dto.devices?.compactMap { deviceDto in
            return try? Device.create(from: deviceDto)
        } ?? []

        accounts = []

        if
            let accountId = dto.account1,
            let paymentSystemUrl = dto.paymentSystemUrl1
        {
            let account = Account(
                id: accountId,
                monthlyPayment: dto.monthlyPayment1,
                guardServiceName: dto.guardServiceName1,
                paymentSystemUrl: paymentSystemUrl
            )

            accounts.append(account)
        }

        if
            let accountId = dto.account2,
            let paymentSystemUrl = dto.paymentSystemUrl2
        {
            let account = Account(
                id: accountId,
                monthlyPayment: dto.monthlyPayment2,
                guardServiceName: dto.guardServiceName2,
                paymentSystemUrl: paymentSystemUrl
            )

            accounts.append(account)
        }

        if
            let accountId = dto.account3,
            let paymentSystemUrl = dto.paymentSystemUrl3
        {
            let account = Account(
                id: accountId,
                monthlyPayment: dto.monthlyPayment3,
                guardServiceName: dto.guardServiceName3,
                paymentSystemUrl: paymentSystemUrl
            )

            accounts.append(account)
        }
    }
}
