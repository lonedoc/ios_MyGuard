//
//  AccountViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 11.01.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit
import Swinject

extension AccountViewController: AccountView {

    func setAccount(_ account: Account) {
        DispatchQueue.main.async {
            self.rootView.accountTextField.text = self.formatAccount(account)
        }
    }

    func setSum(_ sum: String) {
        DispatchQueue.main.async {
            self.rootView.sumTextField.text = sum
        }
    }

    func setSubmitButtonEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.rootView.submitButton.isEnabled = enabled
        }
    }

    func showPaymentPage(accountId: String, sum: Double, paymentSystemUrl: String) {
        let viewController = BrowserViewController(
            accountId: accountId,
            sum: sum,
            paymentSystemUrl: paymentSystemUrl
        )

        parent?.navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }

}

class AccountViewController: UIViewController {

    private var presenter: AccountPresenter

    // swiftlint:disable:next force_cast
    private var rootView: AccountScreenLayout { return view as! AccountScreenLayout }

    private var accounts = [Account]()

    init() {
        presenter = Assembler.shared.resolver.resolve(AccountPresenter.self)!

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateAccounts(_ accounts: [Account]) {
        DispatchQueue.main.async {
            self.accounts = accounts
            self.rootView.accountPicker.reloadAllComponents()
        }
    }

    override func loadView() {
        view = AccountScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.attach(view: self)
    }

    private func setup() {
        rootView.accountPicker.dataSource = self
        rootView.accountPicker.delegate = self

        rootView.accountTextField.inputAccessoryView = rootView.toolbar
        rootView.sumTextField.inputAccessoryView = rootView.toolbar

        rootView.prevButtonItem.target = self
        rootView.prevButtonItem.action = #selector(focusPrevControl)

        rootView.nextButtonItem.target = self
        rootView.nextButtonItem.action = #selector(focusNextControl)

        rootView.doneButtonItem.target = self
        rootView.doneButtonItem.action = #selector(endInput)

        rootView.accountTextField.delegate = self
        rootView.sumTextField.delegate = self

        rootView.submitButton.addTarget(
            self,
            action: #selector(didHitSubmitButton),
            for: .touchUpInside
        )
    }

    @objc func focusPrevControl() {
        moveFocus(next: false)
    }

    @objc func focusNextControl() {
        moveFocus(next: true)
    }

    private func moveFocus(next: Bool) {
        let controls = [rootView.accountTextField, rootView.sumTextField]

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
        rootView.accountTextField.resignFirstResponder()
        rootView.sumTextField.resignFirstResponder()
    }

    @objc func didHitSubmitButton() {
        presenter.didPushSubmitButton()
    }
}

// MARK: UITextFieldDelegate

extension AccountViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        rootView.prevButtonItem.isEnabled = !rootView.accountTextField.isFirstResponder
        rootView.nextButtonItem.isEnabled = !rootView.sumTextField.isFirstResponder
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

        if textField == rootView.sumTextField {
            presenter.didChangeSum(sum: text)
            return true
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

    private func formatAccount(_ account: Account) -> String {
        let divider = account.guardServiceName == nil ? "" : " - "
        return "\(account.id)\(divider)\(account.guardServiceName ?? "")"
    }

}

// MARK: UIPickerViewDataSource

extension AccountViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accounts.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        let account = accounts[row]
        return formatAccount(account)
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        if accounts.count > row {
            presenter.didSelectAccount(account: accounts[row])
        }
    }

}
