//
//  ObjectsView.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol FacilitiesView: AlertDialog {
    func showPlaceholder()
    func hidePlaceholder()
    func hideRefresher()
    func updateData(facilities: [Facility])
    func call(_ url: URL)
    func showSortingDialog(options: [SortingOption], defaultValue: Int)
    func openObjectScreen(facility: Facility)
}
