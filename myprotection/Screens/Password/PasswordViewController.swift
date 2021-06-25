//
//  PasswordViewController.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 22/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import Swinject

extension PasswordViewController: PasswordContract.View {

    func updateTimer(text: String) {
        DispatchQueue.main.async {
            self.rootView.timeLeftLabel.text = text
        }
    }

    func showRetryButton() {
        DispatchQueue.main.async {
            self.rootView.timeLeftLabel.isHidden = true
            self.rootView.retryButton.isHidden = false
        }
    }

    func hideRetryButton() {
        DispatchQueue.main.async {
            self.rootView.retryButton.isHidden = true
        }
    }

    func showCountDown() {
        DispatchQueue.main.async {
            self.rootView.timeLeftLabel.isHidden = false
            self.rootView.retryButton.isHidden = true
        }
    }

    func setProceedButtonEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.rootView.proceedButton.isEnabled = enabled
        }
    }

    func openLoginScreen() {
        DispatchQueue.main.async {
            let viewController = Container.shared.resolve(LoginContract.View.self)!
            self.present(viewController, animated: true, completion: nil)
        }
    }

    func openPasscodeScreen() {
        DispatchQueue.main.async {
            let viewController = Container.shared.resolve(PasscodeContract.View.self)!
            self.present(viewController, animated: true, completion: nil)
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

class PasswordViewController: UIViewController {

    private let presenter: PasswordContract.Presenter
    private var rootView: PasswordView { return self.view as! PasswordView } // swiftlint:disable:this force_cast

    init(with presenter: PasswordContract.Presenter) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
        self.title = ""
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = PasswordView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        setup()
        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }

    private func setup() {
        rootView.doneButtonItem.target = self
        rootView.doneButtonItem.action = #selector(endInput)

        rootView.retryButton.addTarget(
            self,
            action: #selector(didHitRetryButton),
            for: .touchUpInside
        )

        rootView.cancelButton.addTarget(
            self,
            action: #selector(didHitCancelButton),
            for: .touchUpInside
        )

        rootView.proceedButton.addTarget(
            self,
            action: #selector(didHitProceedButton),
            for: .touchUpInside
        )

        rootView.passwordTextField.delegate = self
    }

    @objc func endInput() {
        rootView.passwordTextField.resignFirstResponder()
    }

    @objc func didHitRetryButton() {
        presenter.didHitRetryButton()
    }

    @objc func didHitCancelButton() {
        presenter.didHitCancelButton()
    }

    @objc func didHitProceedButton() {
        presenter.didHitProceedButton()
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }

        rootView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        rootView.scrollView.scrollIndicatorInsets = rootView.scrollView.contentInset
    }

    @objc func keyboardWillHide(_: Notification) {
        rootView.scrollView.contentInset = .zero
        rootView.scrollView.scrollIndicatorInsets = rootView.scrollView.contentInset
    }

}

// MARK: UITextFieldDelegate

extension PasswordViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String
    ) -> Bool {
        guard textField == rootView.passwordTextField else {
            return true
        }

        if
            let text = textField.text,
            let textRange = Range(range, in: text)
        {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            presenter.didChangePassword(value: updatedText)
        }

        return true
    }

}
