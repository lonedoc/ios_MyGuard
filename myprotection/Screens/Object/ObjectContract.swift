//
//  ObjectContract.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

enum ExecutingCommandType {
    case arming, disarming
}

protocol IObjectView: UIViewController, AlertDialog {
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
    func showConfirmDialog(message: String, proceed: @escaping () -> Void)
    func showEditNameDialog(currentName: String)
    func showTestAlarmView(objectId: String, communicationData: CommunicationData)
    func showEventsView(objectId: String, communicationData: CommunicationData)
}

protocol IObjectPresenter {
    func attach(view: ObjectContract.View)
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func viewWentBackground()
    func viewWentForeground()
    func armButtonTapped()
    func armButtonLongPressed()
    func editButtonTapped()
    func alarmButtonTapped()
    func testAlarmButtonTapped()
    func newNameProvided(name: String)
}

enum ObjectContract {
    typealias View = IObjectView
    typealias Presenter = IObjectPresenter
}
