//
//  FacilityDTO.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

struct FacilityDTO: Decodable {
    let id: String
    let name: String
    let address: String
    let statusCode: String
    let status: String
    let selfService: Int
    let online: Int
    let onlineEnabled: Int
    let perimeterOnly: Int?
    let batteryMalfunction: Int?
    let powerSupplyMalfunction: Int?
    let armingEnabled: Int?
    let alarmButtonEnabled: Int?
    let passcode: String?
    let account1: String?
    let monthlyPayment1: Double?
    let guardServiceName1: String?
    let paymentSystemUrl1: String?
    let account2: String?
    let monthlyPayment2: Double?
    let guardServiceName2: String?
    let paymentSystemUrl2: String?
    let account3: String?
    let monthlyPayment3: Double?
    let guardServiceName3: String?
    let paymentSystemUrl3: String?

    enum CodingKeys: String, CodingKey {
        case id                     = "n_abs"
        case name                   = "name"
        case address                = "address"
        case statusCode             = "status"
        case status                 = "statuss"
        case selfService            = "sam"
        case online                 = "online"
        case onlineEnabled          = "onlineon"
        case perimeterOnly          = "p"
        case batteryMalfunction     = "akb"
        case powerSupplyMalfunction = "220"
        case armingEnabled          = "bohr"
        case alarmButtonEnabled     = "tk"
        case passcode               = "password"
        case account1               = "i1clic"
        case monthlyPayment1        = "i1csum"
        case guardServiceName1      = "company1"
        case paymentSystemUrl1      = "company1_url"
        case account2               = "i1clic2"
        case monthlyPayment2        = "i1csum2"
        case guardServiceName2      = "company2"
        case paymentSystemUrl2      = "company2_url"
        case account3               = "i1clic3"
        case monthlyPayment3        = "i1csum3"
        case guardServiceName3      = "company3"
        case paymentSystemUrl3      = "company3_url"
    }

    static func deserialize(from json: String) throws -> FacilityDTO {
        return try JSONDecoder().decode(
            FacilityDTO.self,
            from: json.data(using: .utf8)!
        )
    }

    static func deserializeList(from json: String) throws -> [FacilityDTO] {
        return try JSONDecoder().decode(
            [FacilityDTO].self,
            from: json.data(using: .utf8)!
        )
    }
}
