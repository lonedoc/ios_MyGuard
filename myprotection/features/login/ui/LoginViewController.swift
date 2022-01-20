//
//  LoginViewController.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 01/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit
import Swinject

extension LoginViewController: LoginView {

    func setCities(_ cities: [String]) {
        DispatchQueue.main.async {
            self.cities = cities
            self.rootView.cityPicker.reloadAllComponents()
        }
    }

    func setGuardServices(_ guardServices: [String]) {
        DispatchQueue.main.async {
            self.guardServices = guardServices
            self.rootView.guardServicePicker.reloadAllComponents()
        }
    }

    func selectCityPickerRow(_ row: Int) {
        DispatchQueue.main.async {
            self.rootView.cityPicker.selectRow(row, inComponent: 0, animated: false)
        }
    }

    func selectGuardServicePickerRow(_ row: Int) {
        DispatchQueue.main.async {
            self.rootView.guardServicePicker.selectRow(row, inComponent: 0, animated: false)
        }
    }

    func setCity(_ value: String) {
        DispatchQueue.main.async {
            self.rootView.cityTextField.text = value
        }
    }

    func setGuardService(_ value: String) {
        DispatchQueue.main.async {
            self.rootView.guardServiceTextField.text = value
        }
    }

    func setPhoneNumber(_ value: String) {
        DispatchQueue.main.async {
            self.rootView.phoneTextField.text = value
        }
    }

    func setSubmitButtonEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.rootView.submitButton.isEnabled = enabled
        }
    }

    func openPasswordScreen() {
        DispatchQueue.main.async {
            let passwordViewController = PasswordViewController()
            self.present(passwordViewController, animated: true, completion: nil)
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

class LoginViewController: UIViewController {

    private let presenter: LoginPresenter

    // swiftlint:disable:next force_cast
    private var rootView: LoginScreenLayout { return self.view as! LoginScreenLayout }

    private var cities = [""]
    private var guardServices = [""]

    init() {
        self.presenter = Assembler.shared.resolver.resolve(LoginPresenter.self)!

        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = LoginScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscibe()
    }

    private func setup() {
        rootView.cityTextField.inputAccessoryView = rootView.toolbar
        rootView.guardServiceTextField.inputAccessoryView = rootView.toolbar
        rootView.phoneTextField.inputAccessoryView = rootView.toolbar

        rootView.cityPicker.dataSource = self
        rootView.cityPicker.delegate = self

        rootView.guardServicePicker.dataSource = self
        rootView.guardServicePicker.delegate = self

        rootView.prevButtonItem.target = self
        rootView.prevButtonItem.action = #selector(focusPrevControl)

        rootView.nextButtonItem.target = self
        rootView.nextButtonItem.action = #selector(focusNextControl)

        rootView.doneButtonItem.target = self
        rootView.doneButtonItem.action = #selector(endInput)

        rootView.cityTextField.delegate = self
        rootView.guardServiceTextField.delegate = self
        rootView.phoneTextField.delegate = self

        rootView.submitButton.addTarget(
            self,
            action: #selector(didHitSubmitButton),
            for: .touchUpInside
        )
    }

    @objc func didHitSubmitButton() {
        presenter.didHitSubmitButton()
    }

    @objc func focusPrevControl() {
        moveFocus(next: false)
    }

    @objc func focusNextControl() {
        moveFocus(next: true)
    }

    private func moveFocus(next: Bool) {
        let controls = [rootView.cityTextField, rootView.guardServiceTextField, rootView.phoneTextField]

        guard let index = (controls.firstIndex { $0.isFirstResponder }) else {
            return
        }

        let edge = next ? controls.count - 1 : 0

        if index == edge {
            return
        }

        let nextIndex = next ? index + 1 : index - 1

        if controls[nextIndex].canBecomeFirstResponder {
            controls[nextIndex].becomeFirstResponder()
        }
    }

    @objc func endInput() {
        rootView.cityTextField.resignFirstResponder()
        rootView.guardServiceTextField.resignFirstResponder()
        rootView.phoneTextField.resignFirstResponder()
    }

    private func subscribe() {
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

    private func unsubscibe() {
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

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        rootView.prevButtonItem.isEnabled = !rootView.cityTextField.isFirstResponder
        rootView.nextButtonItem.isEnabled = !rootView.phoneTextField.isFirstResponder
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = getUpdatedText(
            text: textField.text,
            range: range,
            replacementString: string
        ) else {
            return false
        }

        if textField == rootView.phoneTextField {
            presenter.didChangePhone(value: text)
            return false
        }

        if textField == rootView.cityTextField {
            guard cities.contains(text) else {
                return false
            }

            presenter.didSelect(city: text)
        }

        if textField == rootView.guardServiceTextField {
            guard guardServices.contains(text) else {
                return false
            }

            presenter.didSelect(guardService: text)
        }

        return true
    }

    private func getUpdatedText(text: String?, range: NSRange, replacementString: String) -> String? {
        guard
            let text = text,
            let textRange = Range(range, in: text)
        else {
            return nil
        }

        return text.replacingCharacters(in: textRange, with: replacementString)
    }

}

// MARK: UIPickerViewDataSource

extension LoginViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case rootView.cityPicker:
            return cities.count
        case rootView.guardServicePicker:
            return guardServices.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case rootView.cityPicker:
            return cities[row]
        case rootView.guardServicePicker:
            return guardServices[row]
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case rootView.cityPicker:
            presenter.didSelect(city: cities[row])
        case rootView.guardServicePicker:
            presenter.didSelect(guardService: guardServices[row])
        default:
            return
        }
    }

}
