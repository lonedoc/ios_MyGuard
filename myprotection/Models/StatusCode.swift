//
//  StatusCode.swift
//  myprotection
//
//  Created by Rubeg NPO on 08.06.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation

enum StatusCode: Comparable {
    case alarm
    case alarmNotGuarded
    case alarmGuarded
    case alarmNotGuardedWithHandling
    case alarmGuardedWithHandling
    case malfunction
    case malfunctionNotGuarded
    case malfunctionGuarded
    case notGuarded
    case guarded
    case unknown
    case guardedPerimeterOnly
    case alarmGuardedWithHandlingPerimeterOnly
    case alarmGuardedPerimeterOnly
    case malfunctionGuardedPerimeterOnly

    init(text code: String, perimeterOnly: Bool) {
        self = getStatusCode(text: code, perimeterOnly: perimeterOnly)
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        return getImportance(lhs) < getImportance(rhs)
    }

    var isGuarded: Bool {
        return guardedStatuses.contains(self)
    }

    var isFullGuarded: Bool {
        return fullGuardedStatuses.contains(self)
    }

    var isPerimeterOnlyGuarded: Bool {
        return perimeterOnlyStatuses.contains(self)
    }

    var isNotGuarded: Bool {
        return notGuardedStatuses.contains(self)
    }

    var isAlarm: Bool {
        return alarmStatuses.contains(self)
    }

    var isMalfunction: Bool {
        return malfunctionStatuses.contains(self)
    }
}

// swiftlint:disable:next cyclomatic_complexity
private func getStatusCode(text code: String, perimeterOnly: Bool) -> StatusCode {
    switch code {
    case "1": return .alarmNotGuarded
    case "2": return .malfunction
    case "3": return perimeterOnly ? .guardedPerimeterOnly : .guarded
    case "4": return .notGuarded
    case "5": return .alarmNotGuardedWithHandling
    case "6": return .alarm
    case "7": return perimeterOnly ? .alarmGuardedWithHandlingPerimeterOnly : .alarmGuardedWithHandling
    case "8": return perimeterOnly ? .alarmGuardedPerimeterOnly : .alarmGuarded
    case "9": return .malfunctionNotGuarded
    case "10": return perimeterOnly ? .malfunctionGuardedPerimeterOnly : .malfunctionGuarded
    default: return .unknown
    }
}

private func getImportance(_ statusCode: StatusCode) -> Int {
    switch statusCode {
    case let status where status.isAlarm && !status.isGuarded:
        return 6
    case let status where status.isAlarm:
        return 5
    case let status where status.isMalfunction && !status.isGuarded:
        return 4
    case let status where status.isMalfunction:
        return 3
    case let status where status.isNotGuarded:
        return 2
    case let status where status.isGuarded:
        return 1
    default:
        return 0
    }
}

private let guardedStatuses: [StatusCode] = [
    .guarded,
    .alarmGuarded,
    .alarmGuardedWithHandling,
    .malfunctionGuarded,
    .guardedPerimeterOnly,
    .alarmGuardedPerimeterOnly,
    .alarmGuardedWithHandlingPerimeterOnly,
    .malfunctionGuardedPerimeterOnly
]

private let fullGuardedStatuses: [StatusCode] = [
    .guarded,
    .alarmGuarded,
    .alarmGuardedWithHandling,
    .malfunctionGuarded
]

private let perimeterOnlyStatuses: [StatusCode] = [
    .alarmGuardedPerimeterOnly,
    .alarmGuardedWithHandlingPerimeterOnly,
    .malfunctionGuardedPerimeterOnly,
    .guardedPerimeterOnly
]

private let notGuardedStatuses: [StatusCode] = [
    .notGuarded,
    .alarmNotGuarded,
    .alarmNotGuardedWithHandling,
    .malfunctionNotGuarded
]

private let alarmStatuses: [StatusCode] = [
    .alarm,
    .alarmNotGuarded,
    .alarmNotGuardedWithHandling,
    .alarmGuarded,
    .alarmGuardedWithHandling,
    .alarmGuardedPerimeterOnly,
    .alarmGuardedWithHandlingPerimeterOnly
]

private let malfunctionStatuses: [StatusCode] = [
    .malfunction,
    .malfunctionNotGuarded,
    .malfunctionGuarded,
    .malfunctionGuardedPerimeterOnly
]
