//
//  PasswordPresenter.swift
//  myprotection
//
//  Created by Rubeg NPO on 27.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation
import RubegProtocol_v2_0
import RxSwift

private let driverPort: Int32 = 8301

extension PasscodePresenter: PasscodeContract.Presenter {

    func attach(view: PasscodeContract.View) {
        self.view = view
    }

    func viewDidLoad() {
        prepareView()
    }

    func viewDidAppear() {
        if biometry.biometryType() == .faceID {
            biometricButtonTapped()
        }
    }

    func phoneButtonTapped() {
        callGuardService()
    }

    func exitButtonTapped() {
        guard
            let communicationData = getCommunicationData(),
            let token = communicationData.token
        else {
            resetAndExitToLoginScreen()
            return
        }

        makeLogoutRequest(address: communicationData.address, token: token)
    }

    func biometricButtonTapped() {
        biometry.authenticate { success, errorMessage in
            if success {
                if let communicationData = self.getCommunicationData() {
                    self.view?.openMainScreen(communicationData: communicationData)
                }
                return
            }

            if let errorMessage = errorMessage {
                self.view?.showAlertDialog(
                    title: "Error".localized,
                    message: errorMessage
                )
            }
        }
    }

    func digitButtonTapped(digit: Int) {
        append(symbol: String(digit))
    }

    func backspaceButtonTapped() {
        handleBackspace()
    }

    func forgotPasscodeButtonTapped() {
        appDataRepository.reset(key: .passcode)
        view?.openPasswordScreen()
    }

}

// MARK: -

private enum Stage {
    case creation, confirmation, entrance
}

class PasscodePresenter {

    private var view: PasscodeContract.View?
    private var appDataRepository: AppDataRepository
    private var biometry: Biometry
    private var loginGateway: LoginGateway

    private var stage: Stage = .creation
    private var passcode1 = ""
    private var passcode2 = ""

    private var disposeBag = DisposeBag()
    private var ipIndex = 0

    init(appDataRepository: AppDataRepository, biometry: Biometry, loginGateway: LoginGateway) {
        self.appDataRepository = appDataRepository
        self.biometry = biometry
        self.loginGateway = loginGateway
    }

    private func prepareView() {
        guard let passcode = appDataRepository.getPasscode() else {
            view?.setHint(text: "Enter new passcode".localized)
            view?.setBiometryType(.none)
            view?.setForgotPasscodeButtonIsHidden(true)
            return
        }

        self.stage = .entrance
        self.passcode1 = passcode

        view?.setHint(text: "Enter the passcode".localized)
        view?.setBiometryType(biometry.biometryType())
        view?.setForgotPasscodeButtonIsHidden(false)
    }

    private func getCommunicationData() -> CommunicationData? {
        guard
            let company = appDataRepository.getCompany(),
            let token = appDataRepository.getToken()
        else {
            return nil
        }

        let addresses = company.ip.compactMap { try? InetAddress.create(ip: $0, port: driverPort) }
        return try? CommunicationData(addresses: addresses, token: token)
    }

    private func callGuardService() {
        guard let phone = getPhone() else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Phone not found".localized
            )
            return
        }

        guard let url = URL(string: "tel://+7\(phone)") else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "The phone number cannot be called".localized
            )
            return
        }

        view?.call(to: url)
    }

    private func getPhone() -> String? {
        guard
            let factory = appDataRepository.getFactory(),
            !factory.phone.isEmpty
        else {
            return nil
        }

        return factory.phone
    }

    private func makeLogoutRequest(address: InetAddress, token: String) {
        loginGateway.unregister(address: address, token: token)
            .subscribe(
                onNext: { [weak self, loginGateway] _ in
                    self?.resetAndExitToLoginScreen()
                    loginGateway.close()
                },
                onError: { [weak self, view, loginGateway] error in
                    defer { loginGateway.close() }

                    guard let errorMessage = self?.getErrorMessage(by: error) else {
                        return
                    }

                    view?.showAlertDialog(
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

    private func resetAndExitToLoginScreen() {
        appDataRepository.reset()
        view?.openLoginScreen()
    }

    private func handleBackspace() {
        if stage == .creation {
            if passcode1.count > 0 {
                passcode1.removeLast()
                view?.setIndicator(value: passcode1.count)
            }

            return
        }

        if passcode2.count > 0 {
            passcode2.removeLast()
            view?.setIndicator(value: passcode2.count)
        }
    }

    private func append(symbol: String) {
        switch stage {
        case .creation:
            appendToPasscodeBeingCreated(symbol)
        case .confirmation:
            appendToPasscodeConfirmation(symbol)
        case .entrance:
            appendToPasscode(symbol)
        }
    }

    private func appendToPasscodeBeingCreated(_ symbol: String) {
        passcode1 += symbol
        view?.setIndicator(value: passcode1.count)

        if passcode1.count == 4 {
            stage = .confirmation
            view?.setHint(text: "Repeat the passcode".localized)
            view?.setIndicator(value: 0)
        }
    }

    private func appendToPasscodeConfirmation(_ symbol: String) {
        passcode2 += symbol
        view?.setIndicator(value: passcode2.count)

        if passcode2.count == 4 {
            checkConfirmation()
        }
    }

    private func checkConfirmation() {
        if passcode1 == passcode2 {
            appDataRepository.set(passcode: passcode1)
            if let communicationData = getCommunicationData() {
                view?.openMainScreen(communicationData: communicationData)
            }
        } else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Wrong passcode confirmation".localized
            )

            stage = .creation
            passcode1 = ""
            passcode2 = ""
            view?.setIndicator(value: 0)
            view?.setHint(text: "Enter new passcode".localized)
        }
    }

    private func appendToPasscode(_ symbol: String) {
        passcode2 += symbol
        view?.setIndicator(value: passcode2.count)

        if passcode2.count == 4 {
            checkPasscode()
        }
    }

    private func checkPasscode() {
        if passcode1 == passcode2 {
            if let communicationData = getCommunicationData() {
                view?.openMainScreen(communicationData: communicationData)
            }
        } else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Wrong passcode".localized
            )

            passcode2 = ""
            view?.setIndicator(value: 0)
        }
    }

}
