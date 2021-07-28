//
//  UIImageExtensions.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.02.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

enum AssetsImage: String {
    case background        = "background"
    case logo              = "rubeg_npo_logo"
    case leftArrow         = "left_arrow"
    case rightArrow        = "right_arrow"
    case touchId           = "touch_id"
    case faceId            = "face_id"
    case backspace         = "backspace"
    case dotOutlined       = "symbol_indicator_outlined"
    case dotSolid          = "symbol_indicator_solid"
    case phone             = "phone"
    case exit              = "exit"
    case sort              = "sort"
    case close             = "close"
    case upwardArrow       = "upward_arrow"
    case downwardArrow     = "downward_arrow"
    case done              = "done"
    case link              = "link"
    case linkOff           = "link_off"
    case edit              = "edit"
    case alarm             = "alarm"
    case checkAlarm        = "check_alarm"
    case alarmStatus       = "alarm_status"
    case guardedStatus     = "guarded_status"
    case notGuardedStatus  = "not_guarded_status"
    case malfunctionStatus = "malfunction_status"
    case fireAlarm         = "fire_alarm"
    case battery           = "battery"
    case settings          = "settings"
}

extension UIImage {

    static func assets(_ name: AssetsImage) -> UIImage? {
        return UIImage(named: name.rawValue)
    }

}
