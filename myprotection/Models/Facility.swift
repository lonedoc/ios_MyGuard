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
    
    init(_ dto: FacilityDTO) {
        id = dto.id
        name = dto.name
        address = dto.address
        selfService = dto.selfService == 1
        online = dto.online == 1
        onlineEnabled = dto.onlineEnabled == 1
        statusCode = StatusCode(text: dto.statusCode)
        status = dto.status
    }
}