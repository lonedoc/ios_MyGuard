//
//  MainContract.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation

protocol IObjectsView: UIViewController, AlertDialog {
    func showPlaceholder()
    func hidePlaceholder()
    func hideRefresher()
    func updateData(facilities: [Facility])
    func showSortingDialog(options: [SortingOption], defaultValue: Int)
    func openObjectScreen(facility: Facility, communicationData: CommunicationData)
}

protocol IObjectsPresenter {
    func attach(view: ObjectsContract.View)
    func viewWillAppear()
    func viewWillDisappear()
    func refresh()
    func sortButtonTapped()
    func sortingChanged(_ sortingValue: Int)
    func objectSelected(_ facility: Facility)
}

enum ObjectsContract {
    typealias View = IObjectsView
    typealias Presenter = IObjectsPresenter
}
