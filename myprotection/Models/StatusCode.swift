//
//  StatusCode.swift
//  myprotection
//
//  Created by Rubeg NPO on 08.06.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation

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

    init(text code: String) {
        switch code {
        case "1":
            self = .alarmNotGuarded
        case "2":
            self = .malfunction
        case "3":
            self = .guarded
        case "4":
            self = .notGuarded
        case "5":
            self = .alarmNotGuardedWithHandling
        case "6":
            self = .alarm
        case "7":
            self = .alarmGuardedWithHandling
        case "8":
            self = .alarmGuarded
        case "9":
            self = .malfunctionNotGuarded
        case "10":
            self = .malfunctionGuarded
        default:
            self = .unknown
        }
    }
}

extension StatusCode {

    var importance: Int {
        switch self {
        case .alarm, .alarmNotGuarded, .alarmNotGuardedWithHandling:
            return 6
        case .alarmGuarded, .alarmGuardedWithHandling:
            return 5
        case .malfunction, .malfunctionNotGuarded:
            return 4
        case .malfunctionGuarded:
            return 3
        case .notGuarded:
            return 2
        case .guarded:
            return 1
        default:
            return 0
        }
    }

    var color: UIColor {
        switch self {
        case .alarm, .alarmNotGuarded, .alarmNotGuardedWithHandling, .alarmGuarded, .alarmGuardedWithHandling:
            return .alarmStatusColor
        case .malfunction, .malfunctionNotGuarded, .malfunctionGuarded:
            return .malfunctionStatusColor
        case .notGuarded:
            return .notGuardedStatusColor
        case .guarded:
            return .guardedStatusColor
        default:
            return .malfunctionStatusColor
        }
    }

    var image: UIImage? {
        switch self {
        case .alarmNotGuarded, .alarmNotGuardedWithHandling, .malfunctionNotGuarded, .notGuarded:
            return UIImage.assets(.notGuardedStatus)
        case .alarmGuarded, .alarmGuardedWithHandling, .malfunctionGuarded, .guarded:
            return UIImage.assets(.guardedStatus)
        case .alarm:
            return UIImage.assets(.alarmStatus)
        case .malfunction:
            return UIImage.assets(.malfunctionStatus)
        default:
            return nil
        }
    }

}
