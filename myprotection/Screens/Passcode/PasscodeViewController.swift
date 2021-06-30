//
//  PasswordViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 23.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import Swinject

extension PasscodeViewController: PasscodeContract.View {

    func call(to url: URL) {
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
    
    func setHint(text: String) {
        DispatchQueue.main.async {
            self.rootView.tipLabel.text = text
        }
    }
    
    func setIndicator(value: Int) {
        DispatchQueue.main.async {
            var index = 0
            while index < 4 {
                let highlighted = index < value
                
                let indicator = self.rootView.indicators[index]
                self.rootView.changeIndicatorState(indicator: indicator, highlighted: highlighted)
                
                index += 1
            }
        }
    }
    
    func openLoginScreen() {
        DispatchQueue.main.async {
            let viewController = Container.shared.resolve(LoginContract.View.self)!
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func openPasswordScreen() {
        DispatchQueue.main.async {
            let viewController = Container.shared.resolve(PasswordContract.View.self)!
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func openMainScreen(communicationData: CommunicationData) {
        DispatchQueue.main.async {
            let viewController = Container.shared.resolve(ObjectsContract.View.self, argument: communicationData)!
            let navigationController = NavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func showAlertDialog(title: String, message: String, completion: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.view.tintColor = .primaryColor

            let action = UIAlertAction(title: "OK", style: .default, handler: completion)
            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
    }

}

// MARK: -

class PasscodeViewController: UIViewController {

    private let presenter: PasscodeContract.Presenter
    private var rootView: PasscodeView { return self.view as! PasscodeView }

    init(with presenter: PasscodeContract.Presenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = PasscodeView(frame: UIScreen.main.bounds)
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
        rootView.phoneButton.target = self
        rootView.phoneButton.action = #selector(phoneButtonTapped)
        
        rootView.exitButton.target = self
        rootView.exitButton.action = #selector(exitButtonTapped)

        navigationItem.leftBarButtonItem = rootView.phoneButton
        navigationItem.rightBarButtonItem = rootView.exitButton
        navigationItem.titleView = rootView.titleView
        
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