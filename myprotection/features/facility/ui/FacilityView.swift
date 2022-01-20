//
//  ObjectView.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol FacilityView: UIViewController, AlertDialog {
    func setName(_ name: String)
    func setStatusDescription(_ description: String)
    func setAddress(_ address: String)
    func setStatusIcon(_ status: StatusCode)
    func setLinkIconHidden(_ hidden: Bool)
    func setLinkIcon(linked: Bool)
    func setElectricityIconHidden(_ hidden: Bool)
    func setBatteryIconHidden(_ hidden: Bool)
    func setAlarmButtonEnabled(_ enabled: Bool)
    func showProgressBar(message: String, type: ExecutingCommandType)
    func hideProgressBar()
    func setArmButtonEnabled(_ enabled: Bool)
    func showConfirmDialog(message: String, proceedText: String, proceed: @escaping () -> Void)
    func showEditNameDialog(currentName: String)
    func showTestAlarmView(facilityId: String)
    func showEventsView(facilityId: String)
    func showSensorsView(facilityId: String)
    func showAccountView()
}
