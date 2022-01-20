//
//  ObjectPresenter.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RubegProtocol_v2_0
import RxSwift

extension FacilityPresenterImpl: FacilityPresenter {

    func attach(view: FacilityView) {
        self.view = view
    }

    func viewDidLoad() {
        updateView()
        view?.showEventsView(facilityId: facility.id)
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

    func editButtonTapped() {
        view?.showEditNameDialog(currentName: facility.name)
    }

    func newNameProvided(name: String) {
        if name == facility.name {
            return
        }

        updateFacilityName(name)
    }

    func armButtonTapped() {
        guard facility.armingEnabled else {
            view?.showAlertDialog(
                title: "Feature is not available".localized,
                message: "The arming/disarming feature is not available. In order to use this feature, contact your security company".localized // swiftlint:disable:this line_length
            )
            return
        }

        guard facility.online && facility.onlineEnabled else { return }

        if !facility.statusCode.isGuarded {
            view?.showConfirmDialog(
                message: "Are you sure you want to arm the object?".localized,
                proceedText: "Arm the object".localized
            ) {
                self.view?.setArmButtonEnabled(false)
                self.changeStatus(1)
            }
            return
        }

        view?.showConfirmDialog(
            message: "Are you sure you want to disarm the object?".localized,
            proceedText: "Disarm the object".localized
        ) {
            self.view?.setArmButtonEnabled(false)
            self.changeStatus(0)
        }
    }

    func armButtonLongPressed() {
        guard facility.armingEnabled else {
            view?.showAlertDialog(
                title: "Feature is not available".localized,
                message: "The arming/disarming feature is not available. In order to use this feature, contact your security company".localized // swiftlint:disable:this line_length
            )
            return
        }

        guard facility.armingEnabled && facility.online && facility.onlineEnabled else { return }

        if facility.statusCode.isGuarded {
            return
        }

        view?.showConfirmDialog(
            message: "Are you sure you want to arm the object's perimeter?".localized,
            proceedText: "Arm the object's perimeter".localized
        ) {
            self.view?.setArmButtonEnabled(false)
            self.changeStatus(2)
        }
    }

    func alarmButtonTapped() {
        guard facility.alarmButtonEnabled else {
            view?.showAlertDialog(
                title: "Feature is not available".localized,
                message: "The alarm feature is not available. In order to use this feature, contact your security company".localized // swiftlint:disable:this line_length
            )
            return
        }

        view?.showConfirmDialog(
            message: "Are you sure you want to start alarm?".localized,
            proceedText: "Start alarm".localized
        ) {
            if self.facility.statusCode != .alarm {
                self.startAlarm()
            }
        }
    }

    func testAlarmButtonTapped() {
        view?.showConfirmDialog(
            message: "Are you sure you want to start testing mode?".localized,
            proceedText: "Start testing mode".localized
        ) {
            self.view?.showTestAlarmView(facilityId: self.facility.id)
        }
    }

    func eventsButtonTapped() {
        view?.showEventsView(facilityId: facility.id)
    }

    func sensorsButtonTapped() {
        view?.showSensorsView(facilityId: facility.id)
    }

    func accountButtonTapped() {
        view?.showAccountView()
    }

}

// MARK: -

private let shortPollingInterval: TimeInterval = 1
private let longPollingInterval: TimeInterval = 15

class FacilityPresenterImpl {

    private var view: FacilityView?
    private let interactor: FacilityInteractor
    private var disposeBag = DisposeBag()

    private var facility: Facility

    private var timer: Timer?
    @Atomic private var progressBarIsShown = false
    @Atomic private var alarmIsStarting = false

    init(facility: Facility, interactor: FacilityInteractor) {
        self.facility = facility
        self.interactor = interactor
    }

    private func startPolling(interval: TimeInterval = longPollingInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: interval,
            target: self,
            selector: #selector(fetchFacilityData),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopPolling() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func fetchFacilityData() {
        interactor.getFacility(facilityId: facility.id)
            .subscribe(
                onNext: { [weak self] facility in
                    self?.completeStatusChange(updated: facility)
                    self?.facility = facility
                    self?.updateView()
                },
                onError: { _ in }
            )
            .disposed(by: disposeBag)
    }

    private func completeStatusChange(updated: Facility) {
        if progressBarIsShown {
            let oldStatus = facility.statusCode
            let newStatus = updated.statusCode

            let gotGuarded = !oldStatus.isGuarded && newStatus.isGuarded
            let gotNotGuarded = !oldStatus.isNotGuarded && newStatus.isNotGuarded

            if gotGuarded || gotNotGuarded {
                view?.hideProgressBar()
                view?.setArmButtonEnabled(true)
                restartPolling()
            }
        }

        if alarmIsStarting {
            if updated.statusCode.isAlarm {
                alarmIsStarting = false
                restartPolling()
            }
        }
    }

    private func restartPolling(interval: TimeInterval = longPollingInterval) {
        DispatchQueue.main.async {
            self.stopPolling()
            self.startPolling(interval: interval)
        }
    }

    private func updateView() {
        view?.setName(facility.name)
        view?.setStatusDescription(facility.status)
        view?.setAddress(facility.address)
        view?.setStatusIcon(facility.statusCode)
        view?.setLinkIconHidden(!facility.online)
        view?.setElectricityIconHidden(!facility.powerSupplyMalfunction)
        view?.setBatteryIconHidden(!facility.batteryMalfunction)
        view?.setLinkIcon(linked: facility.onlineEnabled)
        view?.setAlarmButtonEnabled(![.alarm].contains(facility.statusCode))
    }

    private func updateFacilityName(_ name: String) {
        interactor.setName(facilityId: facility.id, name: name)
            .subscribe(
                onNext: { [weak self] success in
                    if success {
                        self?.view?.setName(name)
                    } else {
                        self?.view?.showAlertDialog(
                            title: "Error".localized,
                            message: "The operation could not be performed".localized
                        )
                    }
                },
                onError: { [weak self] error in
                    let errorMessage = getErrorMessage(by: error)

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage
                    )
                }
            )
            .disposed(by: disposeBag)
    }

    private func changeStatus(_ status: Int) {
        interactor.setStatus(facilityId: facility.id, statusCode: status)
            .subscribe(
                onNext: { [weak self] success in
                    if !success {
                        self?.view?.showAlertDialog(
                            title: "Error".localized,
                            message: "Service is not available now".localized
                        )
                        return
                    }

                    self?.showProgressBar(status: status)
                    self?.restartPolling(interval: shortPollingInterval)
                },
                onError: { [weak self] error in
                    self?.view?.setArmButtonEnabled(true)

                    let errorMessage = getErrorMessage(by: error)

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage
                    )
                }
            )
            .disposed(by: disposeBag)
    }

    private func showProgressBar(status: Int) {
        guard
            let message = getProgressBarMessage(by: status),
            let type = getCommandType(by: status)
        else {
            return
        }

        view?.showProgressBar(message: message, type: type)
        progressBarIsShown = true
    }

    private func getProgressBarMessage(by status: Int) -> String? {
        switch status {
        case 0:
            return "Disarming...".localized
        case 1:
            return "Arming...".localized
        case 2:
            return "Arming perimeter...".localized
        default:
            return nil
        }
    }

    private func getCommandType(by status: Int) -> ExecutingCommandType? {
        switch status {
        case 0:
            return .disarming
        case 1, 2:
            return .arming
        default:
            return nil
        }
    }

    private func startAlarm() {
        interactor.sendAlarm(facilityId: facility.id)
            .subscribe(
                onNext: { [weak self] success in
                    if !success {
                        self?.view?.showAlertDialog(
                            title: "Error".localized,
                            message: "The operation could not be performed".localized
                        )
                    } else {
                        self?.alarmIsStarting = true
                        self?.restartPolling(interval: shortPollingInterval)
                    }
                },
                onError: { [weak self] error in
                    let errorMessage = getErrorMessage(by: error)

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage
                    )
                }
            )
            .disposed(by: disposeBag)
    }

}
