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

extension PasswordPresenter: PasswordContract.Presenter {

    func attach(view: PasswordContract.View) {
        self.view = view
    }

    func viewDidLoad() {
        communicationData = getCommunicationData()
        requestPassword()
    }

    func didHitRetryButton() {
        view?.hideRetryButton()
        communicationData?.invalidateAddress()
        requestPassword()
    }

    func didHitCancelButton() {
        view?.openLoginScreen()
    }

    func didHitProceedButton() {
        register()
    }

    func didChangePassword(value: String) {
        let isValid = validate(password: value)
        view?.setProceedButtonEnabled(isValid)

        if isValid {
            password = value
        }
    }

}

// MARK: -

private let driverPort: Int32 = 8301
private let timeToRetry = 40

class PasswordPresenter {

    private weak var view: PasswordContract.View?
    
    private let appDataRepository: AppDataRepository
    private let passwordGateway: PasswordGateway
    private let loginGateway: LoginGateway

    private var communicationData: CommunicationData?
    
    private let disposeBag = DisposeBag()

    private var timer: Timer?
    private var timeLeft = 0

    private var password = ""
    
    init(
        appDataRepository: AppDataRepository,
        passwordGateway: PasswordGateway,
        loginGateway: LoginGateway
    ) {
        self.appDataRepository = appDataRepository
        self.passwordGateway = passwordGateway
        self.loginGateway = loginGateway
    }

    private func getCommunicationData() -> CommunicationData? {
        guard let company = appDataRepository.getCompany() else {
            return nil
        }

        let addresses =
            company.ip.compactMap { try? InetAddress.create(ip: $0, port: driverPort) }

        if addresses.count == 0 {
            return nil
        }

        return try? CommunicationData(addresses: addresses, token: nil)
    }

    private func requestPassword() {
        guard let cd = communicationData else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Server address unknown".localized
            )
            return
        }

        guard let phone = appDataRepository.getPhone() else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Phone number not specified".localized
            )
            return
        }

        let formattedPhone = formatPhoneNumber(phone)

        makePasswordRequest(address: cd.address, phone: formattedPhone)
    }

    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        return String(phoneNumber.filter { "0123456789".contains($0) }.suffix(10))
    }

    private func makePasswordRequest(address: InetAddress, phone: String) {
        passwordGateway.requestPassword(address: address, phone: phone)
            .subscribe(
                onNext: { [weak self] passwordSent in
                    if passwordSent {
                        DispatchQueue.main.async {
                            self?.startCountDown()
                        }
                    }

                    self?.passwordGateway.close()
                },
                onError: { [weak self] error in
                    defer { self?.passwordGateway.close() }

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

    private func startCountDown() {
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

    private func register() {
        guard let cd = communicationData else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Server address unknown".localized
            )
            return
        }

        guard let phone = appDataRepository.getPhone() else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Phone number not specified".localized
            )
            return
        }

        let formattedPhone = formatPhoneNumber(phone)

        guard let fcmToken = appDataRepository.getFcmToken() else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Push-notifications is not available".localized
            )
            return
        }

        let deviceModel = UIDevice.modelName

        makeRegistrationRequest(
            address: cd.address,
            phone: formattedPhone,
            password: password,
            fcmToken: fcmToken,
            deviceModel: deviceModel
        )
    }

    private func makeRegistrationRequest(
        address: InetAddress,
        phone: String,
        password: String,
        fcmToken: String,
        deviceModel: String
    ) {
        loginGateway.register(
            address: address,
            phone: phone,
            password: password,
            fcmToken: fcmToken,
            device: deviceModel
        )
            .subscribe(
                onNext: { [weak self] result in
                    self?.appDataRepository.set(user: result.user)
                    self?.appDataRepository.set(factory: result.factory)
                    self?.appDataRepository.set(token: result.token)

                    self?.view?.openPasscodeScreen()

                    self?.loginGateway.close()
                },
                onError: { [weak self] error in
                    defer { self?.passwordGateway.close() }

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

    private func validate(password: String) -> Bool {
        return password.count > 0 && password.allSatisfy { "0123456789".contains($0) }
    }

}
