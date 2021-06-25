//
//  ParseResponse.swift
//  myprotection
//
//  Created by Rubeg NPO on 11.12.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation

typealias Response = (
    command: String,
    data: String
)

func parseResponse(source: String) -> Response? {
    guard
        let sourceData = source.data(using: .utf8),
        let jsonObject = try? JSONSerialization.jsonObject(with: sourceData, options: []),
        let jsonMap = jsonObject as? [String: Any]
    else {
        return nil
    }

    guard let command = jsonMap["$c$"] as? String else {
        return nil
    }

    guard
        let jsonData = jsonMap["data"],
        let data = try? JSONSerialization.data(withJSONObject: jsonData, options: []),
        let dataStr = String(data: data, encoding: .utf8)
    else {
        return nil
    }

    return (command, dataStr)
}
