//
//  EventDTO.swift
//  myprotection
//
//  Created by Rubeg NPO on 29.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

struct EventDTO: Decodable {
    let number: Int
    let time: String
    let type: Int
    let description: String
    let zone: String

    enum CodingKeys: String, CodingKey {
        case number      = "ab"
        case time        = "ti"
        case type        = "cs"
        case description = "nc"
        case zone        = "de"
    }

    static func deserialize(from json: String) throws -> EventDTO {
        return try JSONDecoder().decode(
            EventDTO.self,
            from: json.data(using: .utf8)!
        )
    }

    static func deserializeList(from json: String) throws -> [EventDTO] {
        return try JSONDecoder().decode(
            [EventDTO].self,
            from: json.data(using: .utf8)!
        )
    }
}
