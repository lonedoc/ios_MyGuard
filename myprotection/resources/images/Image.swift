//
//  Image.swift
//  myprotection
//
//  Created by Rubeg NPO on 08.11.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation

enum Image: String, CaseIterable {
    // Common
    case dropdownIcon = "Dropdown Icon"
    case previousButtonIcon = "Previous Button Icon"
    case nextButtonIcon = "Next Button Icon"

    // Icons
    case touchIdIcon = "Touch-ID Icon"
    case faceIdIcon = "Face-ID Icon"
    case backspaceIcon = "Backspace Icon"
    case chevronRightIcon = "Chevron Right Icon"
    case guardedStatusIcon = "Guarded Status Icon"
    case notGuardedStatusIcon = "Not Guarded Status Icon"
    case perimeterGuardedStatusIcon = "Perimeter Guarded Status Icon"
    case guardedIconLight = "Guarded Icon Light"
    case guardedIconDark = "Guarded Icon Dark"
    case perimeterGuardedIconLight = "Perimeter Guarded Icon Light"
    case perimeterGuardedIconDark = "Perimeter Guarded Icon Dark"
    case notGuardedIconLight = "Not Guarded Icon Light"
    case notGuardedIconDark = "Not Guarded Icon Dark"
    case eventAlarmIcon = "Event Alarm Icon"
    case eventMalfunctionIcon = "Event Malfunction Icon"
    case eventOtherIcon = "Event Other Icon"
    case thermostatIcon = "Thermostat Icon"
    case humiditySensorIcon = "Humidity Sensor Icon"
    case onlineChannelIcon = "Online Channel Icon"
    case batteryMalfunctionIcon = "Battery Malfunction Icon"
    case powerSupplyMalfunctionIcon = "Power Supply Malfunction Icon"
    case renameButtonIcon = "Rename Button Icon"
    case testModeButtonIcon = "Test Mode Button Icon"
}
