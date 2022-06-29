//
//  SensorsView.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol SensorsView: AlertDialog {
    func showEmptyListMessage()
    func hideEmptyListMessage()
    func setDevices(_ devices: [Device])
    func updateDevices(_ devices: [Device])
}
