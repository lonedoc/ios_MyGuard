//
//  PasswordViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 23.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import Swinject

class PasscodeViewController: UIViewController, PasscodeView {

    private let presenter: PasscodePresenter

    // swiftlint:disable:next force_cast
    private var rootView: PasscodeScreenLayout { return self.view as! PasscodeScreenLayout }

    init() {
        presenter = Assembler.shared.resolver.resolve(PasscodePresenter.self)!

        super.init(nibName: nil, bundle: nil)

        title = ""
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func call(_ url: URL) {
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                self.showAlertDialog(
                    title: "Error".localized,
                    message: "The number cannot be dialed".localized
                )
            }
        }
    }

    func setBiometryType(_ type: BiometryType) {
        DispatchQueue.main.async {
            self.rootView.changeBiometricButtonType(type)
        }
    }

    func setForgotPasscodeButtonIsHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.forgotPasscodeButton.isHidden = hidden
        }
    }

    func setAppBarIsHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(hidden, animated: false)
        }
    }

    func setHint(text: String) {
        DispatchQueue.main.async {
            self.rootView.hintLabel.text = text
        }
    }

    func setIndicator(value: Int) {
        DispatchQueue.main.async {
            self.rootView.setIndicator(value: value)
        }
    }

    func openLoginScreen() {
        DispatchQueue.main.async {
            let viewController = LoginViewController()
            self.present(viewController, animated: true, completion: nil)
        }
    }

    func openPasswordScreen() {
        DispatchQueue.main.async {
            let viewController = PasswordViewController()
            self.present(viewController, animated: true, completion: nil)
        }
    }

    func openMainScreen() {
        DispatchQueue.main.async {
            let viewController = FacilitiesViewController()
            let navigationController = NavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true, completion: nil)
        }
    }

    override func loadView() {
        self.view = PasscodeScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }

    override func viewDidLoad() {
        presenter.attach(view: self)
        presenter.viewDidLoad()
        setup()
    }

    private func setup() {
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(color: .cardBackground)

        rootView.phoneButton.target = self
        rootView.phoneButton.action = #selector(phoneButtonTapped)

        rootView.exitButton.target = self
        rootView.exitButton.action = #selector(exitButtonTapped)

        navigationItem.leftBarButtonItem = rootView.phoneButton
        navigationItem.rightBarButtonItem = rootView.exitButton

        rootView.biometricButton.addTarget(
            self,
            action: #selector(biometricButtonTapped),
            for: .touchUpInside
        )

        rootView.backspaceButton.addTarget(
            self,
            action: #selector(backspaceButtonTapped),
            for: .touchUpInside
        )

        for button in rootView.digitButtons {
            button.addTarget(
                self,
                action: #selector(digitButtonTapped(button:)),
                for: .touchUpInside
            )
        }

        rootView.forgotPasscodeButton.addTarget(
            self,
            action: #selector(forgotPasscodeButtonTapped),
            for: .touchUpInside
        )
    }

    @objc private func phoneButtonTapped() {
        presenter.phoneButtonTapped()
    }

    @objc private func exitButtonTapped() {
        presenter.exitButtonTapped()
    }

    @objc private func biometricButtonTapped() {
        presenter.biometricButtonTapped()
    }

    @objc private func backspaceButtonTapped() {
        presenter.backspaceButtonTapped()
    }

    @objc private func digitButtonTapped(button: UIButton) {
        presenter.digitButtonTapped(digit: button.tag)
    }

    @objc private func forgotPasscodeButtonTapped() {
        presenter.forgotPasscodeButtonTapped()
    }

}
