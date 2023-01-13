//
//  PasswordViewController.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 22/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import Swinject

class PasswordViewController: UIViewController, PasswordView {

    private let presenter: PasswordPresenter

    // swiftlint:disable:next force_cast
    private var rootView: PasswordScreenLayout { return self.view as! PasswordScreenLayout }

    init() {
        presenter = Assembler.shared.resolver.resolve(PasswordPresenter.self)!

        super.init(nibName: nil, bundle: nil)

        title = ""
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
            let viewController = LoginViewController()
            self.present(viewController, animated: true, completion: nil)
        }
    }

    func openPasscodeScreen() {
        DispatchQueue.main.async {
            let viewController = PasscodeViewController()
            self.present(viewController, animated: true, completion: nil)
        }
    }

    // MARK: - Setup

    override func loadView() {
        self.view = PasswordScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeForKeyboardEvents()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscibeFromKeyboardEvents()
    }

    private func setup() {
        rootView.doneButtonItem.target = self
        rootView.doneButtonItem.action = #selector(endInput)

        rootView.retryButton.addTarget(
            self,
            action: #selector(retryButtonTapped),
            for: .touchUpInside
        )

        rootView.cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )

        rootView.proceedButton.addTarget(
            self,
            action: #selector(proceedButtonTapped),
            for: .touchUpInside
        )

        rootView.passwordTextField.delegate = self
    }

    @objc func endInput() {
        rootView.passwordTextField.resignFirstResponder()
    }

    @objc func retryButtonTapped() {
        presenter.retryButtonTapped()
    }

    @objc func cancelButtonTapped() {
        presenter.cancelButtonTapped()
    }

    @objc func proceedButtonTapped() {
        presenter.proceedButtonTapped()
    }

    private func subscribeForKeyboardEvents() {
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

    private func unsubscibeFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardSize = keyboardFrame.cgRectValue

        rootView.scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardSize.height,
            right: 0
        )

        rootView.scrollView.scrollIndicatorInsets = rootView.scrollView.contentInset
    }

    @objc func keyboardWillHide(_: Notification) {
        rootView.scrollView.contentInset = .zero
        rootView.scrollView.scrollIndicatorInsets = rootView.scrollView.contentInset
    }

}

// MARK: - UITextFieldDelegate

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
            presenter.passwordChanged(updatedText)
        }

        return true
    }

}
