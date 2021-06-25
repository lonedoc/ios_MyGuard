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

        switch facility.statusCode {
        case .guarded, .malfunctionGuarded:
            view?.showConfirmDialog(message: "Are you sure you want to disarm the object?".localized) {
                self.changeStatus(0)
            }
        case .notGuarded, .malfunctionNotGuarded:
            view?.showConfirmDialog(message: "Are you sure you want to arm the object?".localized) {
                self.changeStatus(1)
            }
        default:
            return
        }
    }

    func armButtonLongPressed() {
        guard facility.online && facility.onlineEnabled else { return }

        switch facility.statusCode {
        case .notGuarded, .malfunctionNotGuarded:
            view?.showConfirmDialog(message: "Are you sure you want to arm the object's perimeter?".localized) {
                self.changeStatus(2)
            }
        default:
            return
        }
    }

    func alarmButtonTapped() {
        if facility.statusCode != .alarm {
            startAlarm()
        }
    }

    func testAlarmButtonTapped() {
        view?.showTestAlarmView(objectId: facility.id, communicationData: communicationData)
    }

}

// MARK: -

fileprivate let guardedStatuses: [StatusCode] = [.guarded, .alarmGuarded, .alarmGuardedWithHandling, .malfunctionGuarded]
fileprivate let notGuardedStatuses: [StatusCode] = [.notGuarded, .alarmNotGuarded, .alarmNotGuardedWithHandling, .malfunctionNotGuarded]

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

    private func startPolling() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 10,
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
                    self?.manageProgressBar(updated: facility)
                    self?.facility = facility
                    self?.updateView()

                    objectsGateway.close()
                },
                onError: { [objectsGateway] _ in objectsGateway.close() }
            )
            .disposed(by: disposeBag)
    }

    private func manageProgressBar(updated: Facility) {
        if !progressBarIsShown {
            return
        }

        let oldStatus = facility.statusCode
        let newStatus = updated.statusCode

        let gotGuarded = !guardedStatuses.contains(oldStatus) && guardedStatuses.contains(newStatus)
        let gotNotGuarded = !notGuardedStatuses.contains(oldStatus) && notGuardedStatuses.contains(newStatus)

        if gotGuarded || gotNotGuarded {
            view?.hideProgressBar()
        }
    }

    private func updateView() {
        view?.setStatusDescription(facility.status)
        view?.setAddress(facility.address)
        view?.setStatusIcon(facility.statusCode)
        view?.setLinkIconHidden(!facility.online)
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
            objectId: facility.id,
            name: name
        )
    }

    private func makeUpdateNameRequest(
        address: InetAddress,
        token: String,
        objectId: String,
        name: String
    ) {
        objectsGateway.setName(address: address, token: token, objectId: objectId, name: name)
            .subscribe(
                onNext: { [objectsGateway] success in
                    objectsGateway.close()
                },
                onError: { [weak self] error in
                    defer { self?.objectsGateway.close() }

                    guard let errorMessage = self?.getErrorMessage(by: error) else {
                        return
                    }

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
            objectId: facility.id,
            status: status
        )
    }

    private func makeChangeStatusRequest(
        address: InetAddress,
        token: String,
        objectId: String,
        status: Int
    ) {
        objectsGateway.setStatus(
            address: address,
            token: token,
            objectId: objectId,
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
            },
            onError: { [weak self] error in
                defer { self?.objectsGateway.close() }

                guard let errorMessage = self?.getErrorMessage(by: error) else {
                    return
                }

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
            objectId: facility.id
        )
    }

    private func makeAlarmRequest(address: InetAddress, token: String, objectId: String) {
        objectsGateway.startAlarm(address: address, token: token, objectId: objectId)
            .subscribe(
                onNext: { [objectsGateway] success in
                    objectsGateway.close()
                },
                onError: { [weak self] error in
                    defer { self?.objectsGateway.close() }

                    guard let errorMessage = self?.getErrorMessage(by: error) else {
                        return
                    }

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage
                    )
                }
            )
            .disposed(by: disposeBag)
    }

    private func getErrorMessage(by error: Error) -> String {
        guard let error = error as? CommunicationError else {
            return "Unknown error".localized
        }

        switch error.type {
        case .socketError:
            return "Unknown error".localized // TODO: Make specific error message
        case .serverError:
            return "Server not responding".localized
        case .internalServerError:
            return "The operation could not be performed".localized
        case .parseError:
            return "Unable to read server response".localized
        case .authError:
            return "Wrong password".localized
        }
    }

}
