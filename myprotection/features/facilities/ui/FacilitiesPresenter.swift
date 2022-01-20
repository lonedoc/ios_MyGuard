//
//  MainContract.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol FacilitiesPresenter {
    func attach(view: FacilitiesView)
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func refresh()
    func sortButtonTapped()
    func sortingChanged(_ sortingValue: Int)
    func objectSelected(_ facility: Facility)
}
