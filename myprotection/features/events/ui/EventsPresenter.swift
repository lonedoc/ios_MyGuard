//
//  EventsContract.swift
//  myprotection
//
//  Created by Rubeg NPO on 05.04.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol EventsPresenter {
    func attach(view: EventsView)
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func viewWentBackground()
    func viewWentForeground()
    func refresh()
    func endOfTableReached()
}
