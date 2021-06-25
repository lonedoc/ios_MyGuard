//
//  TestPresenter.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.05.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RubegProtocol_v2_0
import RxSwift

extension TestPresenter: TestContract.Presenter {

    func attach(view: TestContract.View) {
        self.view = view
    }

    func viewDidLoad() {
        startTestMode()
    }

    func applicationWillResignActive() {
        completeButtonPressed()
    }

    func resetButtonPressed() {
        requestReset()
    }

    func completeButtonPressed() {
        endTestMode()
    }

}

// MARK: -

class TestPresenter {

    private var view: TestContract.View?
    private let testAlarmGateway: TestAlarmGateway

    private let communicationData: CommunicationData

    private let disposeBag = DisposeBag()

    private let objectId: String
    private var counter: Int = 0
    private var timer: Timer?

    init(
        objectId: String,
        communicationData: CommunicationData,
        testAlarmGateway: TestAlarmGateway
    ) {
        self.objectId = objectId
        self.communicationData = communicationData
        self.testAlarmGateway = testAlarmGateway
    }

    private func startTestMode() {
        guard let token = communicationData.token else {
            return
        }

        makeTestModeRequest(address: communicationData.address, token: token)
    }

    private func makeTestModeRequest(address: InetAddress, token: String) {
        testAlarmGateway.enterTestMode(address: address, token: token, objectId: objectId)
            .subscribe(
                onNext: { [weak self] duration in
                    self?.view?.setTip(text: "Press the alarm button".localized)
                    self?.startCountDownTimer(duration: duration)
                    self?.testAlarmGateway.close()
                },
                onError: { [weak self] error in
                    defer { self?.testAlarmGateway.close() }

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

    private func startCountDownTimer(duration: Int) {
        counter = duration

        DispatchQueue.main.sync {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(tick),
                userInfo: nil,
                repeats: true
            )
        }
    }

    private func stopCountDownTimer() {
        timer?.invalidate()
        timer = nil

        counter = 0
    }

    @objc func tick() {
        if counter <= 0 {
            startTestMode()
            stopCountDownTimer()
            return
        }

        updateCountDown()

        if counter % 2 != 0 {
            requestStatus()
        }
    }

    private func updateCountDown() {
        counter -= 1
        view?.setCountdown(text: timeToString(time: counter))
    }

    private func timeToString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }

    private func requestStatus() {
        guard let token = communicationData.token else {
            return
        }

        makeStatusRequest(address: communicationData.address, token: token)
    }

    private func makeStatusRequest(address: InetAddress, token: String) {
        testAlarmGateway.getStatus(address: address, token: token, objectId: objectId)
            .subscribe(
                onNext: { [weak self] status in
                    self?.updateStatus(status)
                    self?.testAlarmGateway.close()
                },
                onError: { [weak self] _ in
                    self?.testAlarmGateway.close()
                }
            )
            .disposed(by: disposeBag)
    }

    private func updateStatus(_ status: TestStatus) {
        view?.setTip(text: getTipText(status: status))
        view?.setResetButtonEnabled(status.alarmButtonPressed && !status.reinstalled)
    }

    private func getTipText(status: TestStatus) -> String {
        if status.reinstalled {
            return "The alarm button has been tested. Press the next alarm button".localized
        }

        if status.alarmButtonPressed {
            return "The alarm button has been pressed".localized
        }

        return "Press the alarm button".localized
    }

    private func requestReset() {
        guard let token = communicationData.token else {
            return
        }

        makeResetRequest(address: communicationData.address, token: token)
    }

    private func makeResetRequest(address: InetAddress, token: String) {
        testAlarmGateway.resetAlarmButtons(address: address, token: token, objectId: objectId)
            .subscribe(
                onNext: { _ in

                },
                onError: { [weak self] error in
                    defer { self?.testAlarmGateway.close() }

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

    private func endTestMode() {
        guard let token = communicationData.token else {
            return
        }

        makeEndTestModeRequest(address: communicationData.address, token: token)
    }

    private func makeEndTestModeRequest(address: InetAddress, token: String) {
        testAlarmGateway.exitTestMode(address: address, token: token, objectId: objectId)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.testAlarmGateway.close()
                    self?.stopCountDownTimer()
                    self?.view?.close()
                },
                onError: { [weak self] error in
                    defer { self?.testAlarmGateway.close() }

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
