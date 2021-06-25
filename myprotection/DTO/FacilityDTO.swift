//
//  FacilityDTO.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
struct FacilityDTO: Decodable {
    let id: String
    let name: String
    let address: String
    let statusCode: String
    let status: String
    let selfService: Int
    let online: Int
    let onlineEnabled: Int

    enum CodingKeys: String, CodingKey {
        case id            = "n_abs"
        case name          = "name"
        case address       = "address"
        case statusCode    = "status"
        case status        = "statuss"
        case selfService   = "sam"
        case online        = "online"
        case onlineEnabled = "onlineon"
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
