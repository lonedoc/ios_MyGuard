//
//  EventsContract.swift
//  myprotection
//
//  Created by Rubeg NPO on 05.04.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

protocol IEventsView: UIViewController, AlertDialog {
    func showPlaceholder()
    func hidePlaceholder()
    func hideRefresher()
    func setEvents(_ events: [Event])
}

protocol IEventsPresenter {
    func attach(view: EventsContract.View)
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func viewWentBackground()
    func viewWentForeground()
    func refresh()
    func endOfTableReached()
}

enum EventsContract {
    typealias View = IEventsView
    typealias Presenter = IEventsPresenter
}
