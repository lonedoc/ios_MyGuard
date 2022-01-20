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
        view?.showPlaceholder()
        loadSensorsData()
    }

    func viewWillAppear() {
        startPolling()
    }

    func viewWillDisappear() {
        stopPolling()
    }

    func viewWentBackground() {
        stopPolling()
    }

    func viewWentForeground() {
        startPolling()
    }

    func refresh() {
        loadSensorsData()
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .seconds(1)) {
            self.view?.hideRefresher()
        }
    }

}

// MARK: -

private let pollingInterval: TimeInterval = 15

class SensorsPresenterImpl {

    private var view: SensorsView?
    private let interactor: SensorsInteractor

    private let facilityId: String
    private var sensors = [Sensor]()

    private var timer: Timer?

    init(facilityid: String, interactor: SensorsInteractor) {
        self.facilityId = facilityid
        self.interactor = interactor
    }

    private func startPolling() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: pollingInterval,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopPolling() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func tick() {
        loadSensorsData()
    }

    private func loadSensorsData() {
        // TODO: load sensors data
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.view?.setSensors([
                Sensor(type: .temperature, name: "Temperature 1", data: 24.5),
                Sensor(type: .temperature, name: "Temperature 2", data: -31.2),
                Sensor(type: .temperature, name: "Temperature 3", data: 8.7),
                Sensor(type: .temperature, name: "Temperature 4", data: 26.4),
                Sensor(type: .humidity, name: "Humidity 1", data: 44),
                Sensor(type: .humidity, name: "Humidity 2", data: 70)
            ])
            self.view?.hidePlaceholder()
        }
    }

}
