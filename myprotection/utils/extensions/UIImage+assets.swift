//
//  UIImageExtensions.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.02.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

enum AssetsImage: String {
    case background              = "background"
    case logo                    = "rubeg_npo_logo"
    case leftArrow               = "left_arrow"
    case rightArrow              = "right_arrow"
    case touchId                 = "touch_id"
    case faceId                  = "face_id"
    case backspace               = "backspace"
    case dotOutlined             = "symbol_indicator_outlined"
    case dotSolid                = "symbol_indicator_solid"
    case phone                   = "phone"
    case exit                    = "exit"
    case sort                    = "sort"
    case close                   = "close"
    case upwardArrow             = "upward_arrow"
    case downwardArrow           = "downward_arrow"
    case done                    = "done"
    case link                    = "link"
    case linkOff                 = "link_off"
    case edit                    = "edit"
    case apply                   = "apply"
    case alarm                   = "alarm"
    case checkAlarm              = "check_alarm"
    case alarmStatusIcon         = "alarm_status"
    case guardedStatusIcon       = "guarded_status"
    case notGuardedStatusIcon    = "not_guarded_status"
    case malfunctionStatusIcon   = "malfunction_status"
    case perimeterOnlyStatusIcon = "guarded_perimeter_only_status"
    case fireAlarm               = "fire_alarm"
    case battery                 = "battery"
    case settings                = "settings"
    case guardedStatus           = "facility_status_guarded"
    case notGuardedStatus        = "facility_status_not_guarded"
    case alarmGuardedStatus      = "facility_status_alarm_guarded"
    case alarmNotGuardedStatus   = "facility_status_alarm_not_guarded"
    case batteryMalfunction      = "battery_malfunction"
    case electricityMalfunction  = "electricity_malfunction"
    case temperatureIcon         = "temperature_icon"
    case humidityIcon            = "humidity_icon"
    case eventsIcon              = "events_icon"
    case sensorsIcon             = "sensors_icon"
    case accountIcon             = "account_icon"
    case radioButtonUnchecked    = "radio_button_unchecked"
    case radioButtonChecked      = "radio_button_checked"
    case cancelAlarm             = "cancel_alarm"
}

extension UIImage {

    static func assets(_ name: AssetsImage) -> UIImage? {
        return UIImage(named: name.rawValue)
    }

}
