//
//  CityDTO.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

struct CityDTO: Decodable {
    let name: String
    let guardServices: [GuardServiceDTO]

    enum CodingKeys: String, CodingKey {
        case name          = "name"
        case guardServices = "pr"
    }
}
