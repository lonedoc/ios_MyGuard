//
//  DeviceDTO.swift
//  myprotection
//
//  Created by Rubeg NPO on 21.06.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation

struct DeviceDTO: Decodable {
    let deviceType: String
    let number: Int
    let description: String
    let temperature: Double?
    let isOnline: Int?

    enum CodingKeys: String, CodingKey {
        case deviceType  = "type"
        case number      = "number"
        case description = "desc"
        case temperature = "value"
        case isOnline    = "online"
    }
}
