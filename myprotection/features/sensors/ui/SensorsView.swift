//
//  SensorsView.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol SensorsView: UIViewController, AlertDialog {
    func showPlaceholder()
    func hidePlaceholder()
    func hideRefresher()
    func setSensors(_ sensors: [Sensor])
}
