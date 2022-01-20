//
//  Company.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 17/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
class GuardService {
    let city: String
    let name: String
    let displayedName: String?
    let ip: [String]
    let phoneNumber: String?

    init(city: String, name: String, ip: [String], displayedName: String? = nil, phoneNumber: String? = nil) {
        self.city = city
        self.name = name
        self.displayedName = displayedName
        self.ip = ip
        self.phoneNumber = phoneNumber
    }
}
