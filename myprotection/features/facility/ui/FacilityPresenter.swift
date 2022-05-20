//
//  ObjectContract.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol FacilityPresenter {
    func attach(view: FacilityView)
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func viewWentBackground()
    func viewWentForeground()
    func armButtonTapped()
    func armButtonLongPressed()
    func editButtonTapped()
    func applyButtonTapped()
    func alarmButtonTapped()
    func testAlarmButtonTapped()
    func newNameProvided(name: String)
    func cancelAlarmPasscodeProvided(passcode: String)
    func eventsButtonTapped()
    func sensorsButtonTapped()
    func accountButtonTapped()
}
