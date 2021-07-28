//
//  StatusCode.swift
//  myprotection
//
//  Created by Rubeg NPO on 08.06.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation

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

enum StatusCode {
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
}

extension StatusCode {

    static var guardedStatuses: [StatusCode] = [
        .guarded,
        .alarmGuarded,
        .alarmGuardedWithHandling,
        .malfunctionGuarded,
        .guardedPerimeterOnly,
        .alarmGuardedPerimeterOnly,
        .alarmGuardedWithHandlingPerimeterOnly,
        .malfunctionGuardedPerimeterOnly
    ]

    static var notGuardedStatuses: [StatusCode] = [
        .notGuarded,
        .alarmNotGuarded,
        .alarmNotGuardedWithHandling,
        .malfunctionNotGuarded
    ]

    func isGuarded() -> Bool {
        return StatusCode.guardedStatuses.contains(self)
    }

    func isNotGuarded() -> Bool {
        return StatusCode.notGuardedStatuses.contains(self)
    }

    var importance: Int {
        switch self {
        case .alarm, .alarmNotGuarded, .alarmNotGuardedWithHandling:
            return 6
        case let status where isAlarmGuardedStatus(status):
            return 5
        case .malfunction, .malfunctionNotGuarded:
            return 4
        case .malfunctionGuarded, .malfunctionGuardedPerimeterOnly:
            return 3
        case .notGuarded:
            return 2
        case .guarded, .guardedPerimeterOnly:
            return 1
        default:
            return 0
        }
    }

    var color: UIColor {
        switch self {
        case let status where isAlarmStatus(status):
            return .alarmStatusColor
        case let status where isMalfunctionStatus(status):
            return .malfunctionStatusColor
        case .notGuarded:
            return .notGuardedStatusColor
        case .guarded, .guardedPerimeterOnly:
            return .guardedStatusColor
        default:
            return .malfunctionStatusColor
        }
    }

    var image: UIImage? {
        switch self {
        case let status where isNotGuardedStatus(status):
            return UIImage.assets(.notGuardedStatus)
        case let status where isFullGuardedStatus(status):
            return UIImage.assets(.guardedStatus)
        case let status where isPerimeterOnlyStatus(status):
            return UIImage.assets(.perimeterOnlyStatus)
        case .alarm:
            return UIImage.assets(.alarmStatus)
        case .malfunction:
            return UIImage.assets(.malfunctionStatus)
        default:
            return nil
        }
    }

    private func isAlarmGuardedStatus(_ status: StatusCode) -> Bool {
        return isAlarmStatus(status) && (isFullGuardedStatus(status) || isPerimeterOnlyStatus(status))
    }

    private func isAlarmStatus(_ status: StatusCode) -> Bool {
        let alarmStatuses: [StatusCode] = [
            .alarm,
            .alarmNotGuarded,
            .alarmNotGuardedWithHandling,
            .alarmGuarded,
            .alarmGuardedWithHandling,
            .alarmGuardedPerimeterOnly,
            .alarmGuardedWithHandlingPerimeterOnly
        ]

        return alarmStatuses.contains(status)
    }

    private func isMalfunctionStatus(_ status: StatusCode) -> Bool {
        let malfunctionStatuses: [StatusCode] = [
            .malfunction,
            .malfunctionNotGuarded,
            .malfunctionGuarded,
            .malfunctionGuardedPerimeterOnly
        ]

        return malfunctionStatuses.contains(status)
    }

    private func isNotGuardedStatus(_ status: StatusCode) -> Bool {
        return StatusCode.notGuardedStatuses.contains(status)
    }

    private func isFullGuardedStatus(_ status: StatusCode) -> Bool {
        let fullGuardedStatuses: [StatusCode] = [
            .alarmGuarded,
            .alarmGuardedWithHandling,
            .malfunctionGuarded,
            .guarded
        ]

        return fullGuardedStatuses.contains(status)
    }

    private func isPerimeterOnlyStatus(_ status: StatusCode) -> Bool {
        let perimeterOnlyStatuses: [StatusCode] = [
            .alarmGuardedPerimeterOnly,
            .alarmGuardedWithHandlingPerimeterOnly,
            .malfunctionGuardedPerimeterOnly,
            .guardedPerimeterOnly
        ]

        return perimeterOnlyStatuses.contains(status)
    }

}
