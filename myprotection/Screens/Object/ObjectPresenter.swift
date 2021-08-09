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

// swiftlint:disable file_length type_body_length

extension ObjectPresenter: ObjectContract.Presenter {

    func attach(view: ObjectContract.View) {
        self.view = view
    }

    func viewDidLoad() {
        updateView()
        view?.showEventsView(objectId: facility.id, communicationData: communicationData)
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
        guard facility.online && facility.onlineEnabled else { return }

        if !facility.statusCode.isGuarded {
            view?.showConfirmDialog(message: "Are you sure you want to arm the object?".localized) {
                self.view?.setArmButtonEnabled(false)
                self.changeStatus(1)
            }
            return
        }

        view?.showConfirmDialog(message: "Are you sure you want to disarm the object?".localized) {
            self.view?.setArmButtonEnabled(false)
            self.changeStatus(0)
        }
    }

    func armButtonLongPressed() {
        guard facility.online && facility.onlineEnabled else { return }

        if facility.statusCode.isGuarded {
            return
        }

        view?.showConfirmDialog(message: "Are you sure you want to arm the object's perimeter?".localized) {
            self.view?.setArmButtonEnabled(false)
            self.changeStatus(2)
        }
    }

    func alarmButtonTapped() {
        view?.showConfirmDialog(message: "Are you sure you want to start alarm?".localized) {
            if self.facility.statusCode != .alarm {
                self.startAlarm()
            }
        }
    }

    func testAlarmButtonTapped() {
        view?.showConfirmDialog(message: "Are you sure you want to start testing mode?".localized) {
            self.view?.showTestAlarmView(objectId: self.facility.id, communicationData: self.communicationData)
        }
    }

}

// MARK: -

private let shortPollingInterval: TimeInterval = 1
private let longPollingInterval: TimeInterval = 10
private let attemptsCount = 2

class ObjectPresenter {

    private var view: ObjectContract.View?
    private var objectsGateway: ObjectsGateway
    private var unitOfWork: UnitOfWork?

    private var facility: Facility

    private let communicationData: CommunicationData
    private var timer: Timer?
    private var progressBarIsShown = false
    private var disposeBag = DisposeBag()

    init(
        facility: Facility,
        communicationData: CommunicationData,
        objectsGateway: ObjectsGateway
    ) {
        self.facility = facility
        self.communicationData = communicationData
        self.objectsGateway = objectsGateway
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
        guard let token = communicationData.token else {
            return
        }

        makeFacilityDataRequest(
            address: communicationData.address,
            token: token
        )
    }

    private func makeFacilityDataRequest(address: InetAddress, token: String) {
        objectsGateway.getObjectData(address: address, token: token, objectId: facility.id)
            .subscribe(
                onNext: { [weak self, objectsGateway] facility in
                    self?.completeStatusChange(updated: facility)
                    self?.facility = facility
                    self?.updateView()

                    objectsGateway.close()
                },
                onError: { [weak self] _ in
                    self?.communicationData.invalidateAddress()
                    self?.objectsGateway.close()
                }
            )
            .disposed(by: disposeBag)
    }

    private func completeStatusChange(updated: Facility) {
        if !progressBarIsShown {
            return
        }

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

    private func restartPolling(interval: TimeInterval = longPollingInterval) {
        DispatchQueue.main.async {
            self.stopPolling()
            self.startPolling(interval: interval)
        }
    }

    private func updateView() {
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
        guard let token = communicationData.token else {
            return
        }

        makeUpdateNameRequest(
            address: communicationData.address,
            token: token,
            name: name,
            attempts: attemptsCount
        )
    }

    private func makeUpdateNameRequest(
        address: InetAddress,
        token: String,
        name: String,
        attempts: Int
    ) {
        objectsGateway.setName(address: address, token: token, objectId: facility.id, name: name)
            .subscribe(
                onNext: { [weak self] success in
                    defer { self?.objectsGateway.close() }

                    if !success {
                        self?.view?.showAlertDialog(
                            title: "Error".localized,
                            message: "The operation could not be performed".localized
                        )
                    }
                },
                onError: { [weak self] error in
                    self?.communicationData.invalidateAddress()

                    if attempts - 1 > 0 {
                        self?.makeUpdateNameRequest(
                            address: address,
                            token: token,
                            name: name,
                            attempts: attempts - 1
                        )
                        return
                    }

                    defer { self?.objectsGateway.close() }

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
        guard let token = communicationData.token else {
            return
        }

        makeChangeStatusRequest(
            address: communicationData.address,
            token: token,
            status: status,
            attempts: attemptsCount
        )
    }

    private func makeChangeStatusRequest(
        address: InetAddress,
        token: String,
        status: Int,
        attempts: Int
    ) {
        objectsGateway.setStatus(
            address: address,
            token: token,
            objectId: facility.id,
            status: status
        )
        .subscribe(
            onNext: { [weak self] success in
                defer { self?.objectsGateway.close() }

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
                self?.communicationData.invalidateAddress()

                if attempts - 1 > 0 {
                    self?.makeChangeStatusRequest(
                        address: address,
                        token: token,
                        status: status,
                        attempts: attempts - 1
                    )
                    return
                }

                defer { self?.objectsGateway.close() }

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
        guard let token = communicationData.token else {
            return
        }

        makeAlarmRequest(
            address: communicationData.address,
            token: token,
            attempts: attemptsCount
        )
    }

    private func makeAlarmRequest(
        address: InetAddress,
        token: String,
        attempts: Int
    ) {
        objectsGateway.startAlarm(address: address, token: token, objectId: facility.id)
            .subscribe(
                onNext: { [weak self] success in
                    defer { self?.objectsGateway.close() }

                    if !success {
                        self?.view?.showAlertDialog(
                            title: "Error".localized,
                            message: "The operation could not be performed".localized
                        )
                    }
                },
                onError: { [weak self] error in
                    self?.communicationData.invalidateAddress()

                    if attempts - 1 > 0 {
                        self?.makeAlarmRequest(
                            address: address,
                            token: token,
                            attempts: attempts - 1
                        )
                        return
                    }

                    defer { self?.objectsGateway.close() }

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
