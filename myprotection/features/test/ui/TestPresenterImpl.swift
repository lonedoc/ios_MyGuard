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

extension TestPresenterImpl: TestPresenter {

    func attach(view: TestView) {
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

class TestPresenterImpl {

    private var view: TestView?
    private let interactor: TestInteractor

    private let disposeBag = DisposeBag()

    private let facilityId: String

    private var counter: Int = 0
    private var timer: Timer?

    init(facilityId: String, interactor: TestInteractor) {
        self.facilityId = facilityId
        self.interactor = interactor
    }

    private func startTestMode() {
        interactor.startTest(facilityId: facilityId)
            .subscribe(
                onNext: { [weak self] duration in
                    self?.view?.setTip(text: "Press the alarm button".localized)
                    self?.startCountDownTimer(duration: duration)
                },
                onError: { [weak self] error in
                    let errorMessage = getErrorMessage(by: error)

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage,
                        completion: { _ in self?.view?.close() }
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
            endTestMode()
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
        interactor.getStatus(facilityId: facilityId)
            .subscribe(
                onNext: { [weak self] status in
                    self?.updateStatus(status)
                },
                onError: { _ in }
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
        interactor.resetAlarmButtons(facilityId: facilityId)
            .subscribe(
                onNext: { _ in },
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

    private func endTestMode() {
        interactor.stopTest(facilityId: facilityId)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.stopCountDownTimer()
                    self?.view?.close()
                },
                onError: { [weak self] error in
                    let errorMessage = getErrorMessage(by: error)

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage,
                        completion: { _ in self?.view?.close() }
                    )
                }
            )
            .disposed(by: disposeBag)
    }

}
