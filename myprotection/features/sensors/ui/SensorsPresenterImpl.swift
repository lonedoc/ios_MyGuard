//
//  SensorsPresenterImpl.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

extension SensorsPresenterImpl: SensorsPresenter {

    func attach(view: SensorsView) {
        self.view = view
    }

    func viewDidLoad() {
        updateView()
    }

    func setDevices(_ devices: [Device]) {
        self.devices = devices
        updateView()
    }

}

// MARK: -

private let pollingInterval: TimeInterval = 15

class SensorsPresenterImpl {

    private var view: SensorsView?

    private let facilityId: String
    private var devices = [Device]()

    private var timer: Timer?

    init(facilityid: String) {
        self.facilityId = facilityid
    }

    private func updateView() {
        view?.updateDevices(devices)

        if devices.isEmpty {
            view?.showEmptyListMessage()
        } else {
            view?.hideEmptyListMessage()
        }
    }

}
