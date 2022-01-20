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

//private let driverPort: Int32 = 8301

extension PasscodePresenterImpl: PasscodePresenter {

    func attach(view: PasscodeView) {
        self.view = view
    }

    func viewDidLoad() {
        prepareCommunicationData()

        if let passcode = interactor.getPasscode() {
            stage = .entrance
            passcode1 = passcode
        }

        prepareView()
    }

    func viewDidAppear() {
        let hasFaceId = biometryHelper.biometryType() == .faceID
        let faceIdAvailable = biometryHelper.isAvailable() && hasFaceId

        if stage == .entrance && faceIdAvailable {
            biometricButtonTapped()
        }
    }

    func phoneButtonTapped() {
        callGuardService()
    }

    func exitButtonTapped() {
        guard interactor.isUserLoggedIn() else {
            interactor.resetUserData()
            view?.openLoginScreen()
            return
        }

        interactor.logOut()
            .subscribe(
                onNext: { [weak self] _ in
                    self?.interactor.resetUserData()
                    self?.view?.openLoginScreen()
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

    func biometricButtonTapped() {
        biometryHelper.authenticate { success, errorMessage in
            if success {
                self.view?.openMainScreen()
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
        interactor.resetPasscode()
        view?.openPasswordScreen()
    }

}

// MARK: -

private enum Stage {
    case creation, confirmation, entrance
}

class PasscodePresenterImpl {

    private var view: PasscodeView?

    private let interactor: PasscodeInteractor
    private let biometryHelper: BiometryHelper
    private let communicationData: CommunicationData

    private var disposeBag = DisposeBag()

    private var stage: Stage = .creation
    private var passcode1 = ""
    private var passcode2 = ""

    private var ipIndex = 0

    init(
        interactor: PasscodeInteractor,
        biometryHelper: BiometryHelper,
        communicationData: CommunicationData
    ) {
        self.interactor = interactor
        self.biometryHelper = biometryHelper
        self.communicationData = communicationData
    }

    private func prepareCommunicationData() {
        let ipAddresses = interactor.getIpAddresses()
        let token = interactor.getToken()

        communicationData.setAddresses(ipAddresses)
        communicationData.token = token
    }

    private func prepareView() {
        switch stage {
        case .creation:
            view?.setHint(text: "Enter new passcode".localized)
            view?.setBiometryType(.none)
            view?.setForgotPasscodeButtonIsHidden(true)
        case .entrance:
            view?.setHint(text: "Enter the passcode".localized)
            view?.setBiometryType(biometryHelper.biometryType())
            view?.setForgotPasscodeButtonIsHidden(false)
        default:
            break
        }
    }

    private func callGuardService() {
        guard let phoneNumber = interactor.getGuardService()?.phoneNumber else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Phone not found".localized
            )
            return
        }

        guard let url = URL(string: "tel://+7\(phoneNumber)") else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "The phone number cannot be called".localized
            )
            return
        }

        view?.call(url)
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
            interactor.setPasscode(passcode1)
            view?.openMainScreen()
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
            view?.openMainScreen()
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
