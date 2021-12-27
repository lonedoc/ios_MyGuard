//
//  EventsView.swift
//  myprotection
//
//  Created by Rubeg NPO on 22.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol EventsView: UIViewController, AlertDialog {
    func showPlaceholder()
    func hidePlaceholder()
    func hideRefresher()
    func setEvents(_ events: [Event])
}
