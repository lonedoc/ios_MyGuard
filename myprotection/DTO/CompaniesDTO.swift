//
//  CompaniesDTO.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 17/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
struct CompanyDTO: Decodable {
    let name: String
    let ip: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case ip
    }
}

struct CityDTO: Decodable {
    let name: String
    let companies: [CompanyDTO]

    enum CodingKeys: String, CodingKey {
        case name      = "name"
        case companies = "pr"
    }
}

struct CompaniesDTO: Decodable {
    let data: [CityDTO]

    enum CodingKeys: String, CodingKey {
        case data = "city"
    }

    static func parse(json: String) throws -> CompaniesDTO {
        return try JSONDecoder().decode(CompaniesDTO.self, from: json.data(using: .utf8)!)
    }
}
