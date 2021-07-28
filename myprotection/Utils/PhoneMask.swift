//
//  PhoneMask.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 21/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation

private typealias Rule = (Character) -> Bool

class PhoneMask {

    // swiftlint:disable opening_brace
    private var rules: [Rule] {
        return [
            { $0 == "+" },
            { $0 == "7" },
            { $0 == " " },
            { $0 == "(" },
            isDigit(char:),
            isDigit(char:),
            isDigit(char:),
            { $0 == ")" },
            { $0 == " " },
            isDigit(char:),
            isDigit(char:),
            isDigit(char:),
            { $0 == "-" },
            isDigit(char:),
            isDigit(char:),
            { $0 == "-" },
            isDigit(char:),
            isDigit(char:)
        ]
    }
    // swiftlint:enable opening_brace

    func validate(_ value: String) -> Bool {
        if value.count != rules.count {
            return false
        }

        let characters = Array(value)

        for index in 0 ..< rules.count {
            let rule = rules[index]
            let char = characters[index]

            if !rule(char) {
                return false
            }
        }

        return true
    }

    func validatePart(_ value: String) -> Bool {
        if value.count > rules.count {
            return false
        }

        let characters = Array(value)

        var index = 0
        while index < characters.count && index < rules.count {
            let rule = rules[index]
            let char = characters[index]

            if !rule(char) {
                return false
            }

            index += 1
        }

        return true
    }

    func apply(to value: String) -> String {
        var valueWithoutPrefix = value

        if value.hasPrefix("+7") {
            valueWithoutPrefix = value.count > 2 ? String(Array(value)[2...]) : ""
        }

        if value.hasPrefix("8") {
            valueWithoutPrefix = value.count > 1 ? String(Array(value)[1...]) : ""
        }

        var result = "+7 ("

        let digits = extractDigits(from: valueWithoutPrefix)
        var index = 0

        guard insert(count: 3, into: &result, from: digits, start: &index) else {
            return result
        }

        result.append(") ")

        guard insert(count: 3, into: &result, from: digits, start: &index) else {
            return result
        }

        result.append("-")

        guard insert(count: 2, into: &result, from: digits, start: &index) else {
            return result
        }

        result.append("-")

        guard insert(count: 2, into: &result, from: digits, start: &index) else {
            return result
        }

        return result
    }

    private func insert(
        count: Int,
        into string: inout String,
        from characters: [Character],
        start index: inout Int
    ) -> Bool {
        for _ in 0 ..< count {
            guard index < characters.count else {
                return false
            }

            string.append(characters[index])
            index += 1
        }

        return true
    }

    private func extractDigits(from string: String) -> [Character] {
        return string.filter { isDigit(char: $0) }
    }

    private func isDigit(char: Character) -> Bool {
        return "0123456789".contains(char)
    }

}
