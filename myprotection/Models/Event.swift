//
//  Event.swift
//  myprotection
//
//  Created by Rubeg NPO on 29.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

class Event {
    var objectId: String
    var number: Int
    var timestamp: Date?
    var type: Int // TODO: Use enumeration or constants
    var description: String
    var zone: String

    init(objectId: String, number: Int, timestamp: Date?, type: Int, description: String, zone: String) {
        self.objectId = objectId
        self.number = number
        self.timestamp = timestamp
        self.type = type
        self.description = description
        self.zone = zone
    }

    init(_ dto: EventDTO, objectId: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"

        self.objectId = objectId
        number = dto.number
        timestamp = formatter.date(from: dto.time)
        type = dto.type
        description = dto.description
        zone = dto.zone
    }
}

func ==(_ lhs: Event, _ rhs: Event) -> Bool {
    return lhs.objectId == rhs.objectId && lhs.number == rhs.number
}
