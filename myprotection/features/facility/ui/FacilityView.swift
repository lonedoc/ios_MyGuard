//
//  ObjectView.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol FacilityView: AlertDialog {
    func setTitle(_ title: String)
    func setStatusDescription(_ description: String)
    func setStatusIcon(_ status: StatusCode)
    func setAlarmButtonHidden(_ hidden: Bool)
    func setCancelAlarmButtonHidden(_ hidden: Bool)
    func setArmButtonHidden(_ hidden: Bool)
    func setDisarmButtonHidden(_ hidden: Bool)
    func setOnlineChannelIconHidden(_ hidden: Bool)
    func setElectricityIconHidden(_ hidden: Bool)
    func setBatteryIconHidden(_ hidden: Bool)
    func setDevices(_ devices: [Device])
    func showEditNameDialog(currentName: String)
    func showConfirmDialog(message: String, proceedText: String, proceed: @escaping () -> Void)
    func showCancelAlarmDialog(passcodes: [String])
    func showTestAlarmView(facilityId: String)
    func showEventsView(facilityId: String)
    func showSensorsView(facility: Facility)
    func showAccountView(accounts: [Account])
    func showApplicationView(facilityId: String)
}
