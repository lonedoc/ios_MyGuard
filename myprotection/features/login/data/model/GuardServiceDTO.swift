//
//  CompanyDTO.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
struct GuardServiceDTO: Decodable {
    let name: String
    let hosts: [String]

    enum CodingKeys: String, CodingKey {
        case name  = "name"
        case hosts = "ip"
    }
}
