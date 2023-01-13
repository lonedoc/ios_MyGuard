//
//  PasswordPresenter.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 22/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

private let timeToRetry = 15

class PasswordPresenterImpl : PasswordPresenter {

    private weak var view: PasswordView?

    private let interactor: PasswordInteractor
    private let disposeBag = DisposeBag()

    private var timer: Timer?
    private var timeLeft = 0

    private var password = ""

    init(interactor: PasswordInteractor) {
        self.interactor = interactor
    }

    func attach(view: PasswordView) {
        self.view = view
    }

    func viewDidLoad() {
        requestPassword()
        startCountDown()
    }

    func retryButtonTapped() {
        view?.hideRetryButton()
        requestPassword()
        startCountDown()
    }

    func cancelButtonTapped() {
        view?.openLoginScreen()
    }

    func proceedButtonTapped() {
        logIn()
    }

    func passwordChanged(_ value: String) {
        let isValid = validate(password: value)
        view?.setProceedButtonEnabled(isValid)

        if isValid {
            password = value
        }
    }

    private func requestPassword() {
        guard let phone = interactor.getUserPhone() else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Phone number not specified".localized
            )
            return
        }

        let formattedPhone = formatPhoneNumber(phone)

        interactor.resetPassword(phone: formattedPhone)
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

    private func startCountDown() {
        DispatchQueue.main.async {
            self.startCountDownTimer()
        }
    }

    private func startCountDownTimer() {
        timeLeft = timeToRetry
        updateTimer()
        view?.showCountDown()

        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 1

            let text = getTimeLeftString(timeLeft)
            view?.updateTimer(text: text)
        } else {
            timer?.invalidate()
            view?.showRetryButton()
        }
    }

    private func getTimeLeftString(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        let padding = seconds < 10 ? "0" : ""
        let timeStr = "\(minutes):\(padding)\(seconds)"

        let timeLeftFormat = "You can request new password again after: %@".localized
        return String.localizedStringWithFormat(timeLeftFormat, timeStr)
    }

    private func logIn() {
        guard let phone = interactor.getUserPhone() else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Phone number not specified".localized
            )
            return
        }

        let formattedPhone = formatPhoneNumber(phone)

        guard let fcmToken = interactor.getFcmToken() else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Push-notifications is not available".localized
            )
            return
        }

        let deviceModel = UIDevice.modelName

        let credentials = (
            phone: formattedPhone,
            password: password
        )

        interactor.logIn(credentials: credentials, fcmToken: fcmToken, device: deviceModel)
            .subscribe(
                onNext: { [weak self] response in
                    self?.saveData(response)
                    self?.view?.openPasscodeScreen()
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

    private func saveData(_ loginResponse: LoginResponse) {
        interactor.saveUser(loginResponse.user)
        interactor.saveGuardServiceContact(guardServiceContact: loginResponse.guardServiceContact)
        interactor.saveToken(loginResponse.token)
    }

    private func validate(password: String) -> Bool {
        return password.count > 0 && password.allSatisfy { "0123456789".contains($0) }
    }

    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        return String(phoneNumber.filter { "0123456789".contains($0) }.suffix(10))
    }

}
