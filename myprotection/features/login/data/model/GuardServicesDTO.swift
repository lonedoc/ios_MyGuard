//
//  CompaniesDTO.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 17/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation

struct GuardServicesDTO: Decodable {
    let data: [CityDTO]

    enum CodingKeys: String, CodingKey {
        case data = "city"
    }

    static func parse(json: String) throws -> GuardServicesDTO {
        return try JSONDecoder().decode(GuardServicesDTO.self, from: json.data(using: .utf8)!)
    }
}
