//
//  ApplicationsViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.05.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit
import Swinject

extension ApplicationsViewController: ApplicationsView {

    func setApplications(_ applications: [String]) {
        DispatchQueue.main.async {
            self.applications = applications
            self.rootView.applicationPicker.reloadAllComponents()
        }
    }

    func setSelectedApplication(_ application: String) {
        DispatchQueue.main.async {
            self.rootView.applicationsTextField.text = application
        }
    }

    func setApplicationText(_ applicationText: String) {
        DispatchQueue.main.async {
            self.rootView.applicationTextField.text = applicationText
        }
    }

    func setIsApplicationTextFieldEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.rootView.applicationTextField.isEditable = enabled
        }
    }

    func setDateTimeText(_ text: String) {
        DispatchQueue.main.async {
            self.rootView.dateTimeTextField.text = text
        }
    }

    func setIsSubmitButtonEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.rootView.submitButton.isEnabled = enabled
        }
    }

    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

}

// MARK: -

class ApplicationsViewController: UIViewController {

    private let presenter: ApplicationsPresenter

    // swiftlint:disable:next force_cast
    private var rootView: ApplicationsScreenLayout { return self.view as! ApplicationsScreenLayout }

    private var applications = [""]

    init(facilityId: String) {
        self.presenter = Assembler.shared.resolver.resolve(
            ApplicationsPresenter.self,
            argument: facilityId
        )!

        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = ApplicationsScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

    private func setup() {
        rootView.prevButtonItem.target = self
        rootView.prevButtonItem.action = #selector(didPushPrevButton)

        rootView.nextButtonItem.target = self
        rootView.nextButtonItem.action = #selector(didPushNextButton)

        rootView.doneButtonItem.target = self
        rootView.doneButtonItem.action = #selector(didPushDoneButton)

        rootView.applicationsTextField.delegate = self
        rootView.dateTimeTextField.delegate = self

        rootView.applicationPicker.dataSource = self
        rootView.applicationPicker.delegate = self

        rootView.applicationTextField.delegate = self

        rootView.datePicker.addTarget(self, action: #selector(didSelectDate(sender:)), for: .valueChanged)

        rootView.submitButton.addTarget(self, action: #selector(didPushSubmitButton), for: .touchUpInside)
    }

    @objc private func didPushPrevButton() {
        moveFocus(next: false)
    }

    @objc private func didPushNextButton() {
        moveFocus(next: true)
    }

    private func moveFocus(next: Bool) {
        let controls = [
            rootView.applicationsTextField,
            rootView.applicationTextField,
            rootView.dateTimeTextField
        ]

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

    @objc private func didPushDoneButton() {
        rootView.applicationsTextField.resignFirstResponder()
        rootView.applicationTextField.resignFirstResponder()
        rootView.dateTimeTextField.resignFirstResponder()
    }

    @objc private func didSelectDate(sender: UIDatePicker) {
        presenter.didSelect(dateTime: sender.date)
    }

    @objc private func didPushSubmitButton() {
        presenter.didPushSubmitButton()
    }

}

// MARK: - UIPickerViewDataSource UIPickerViewDelegate

extension ApplicationsViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return applications.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return applications[row]
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        presenter.didSelect(application: applications[row])
    }

}

// MARK: - UITextViewDelegate

extension ApplicationsViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        rootView.prevButtonItem.isEnabled = true
        rootView.nextButtonItem.isEnabled = true
    }

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        guard let text = getUpdatedText(
            text: textView.text,
            range: range,
            replacementString: text
        ) else {
            return true
        }

        presenter.didChangeApplicationText(applicationText: text)
        return true
    }

    private func getUpdatedText(
        text: String?,
        range: NSRange,
        replacementString: String
    ) -> String? {
        guard
            let text = text,
            let textRange = Range(range, in: text)
        else {
            return nil
        }

        return text.replacingCharacters(in: textRange, with: replacementString)
    }

}

// MARK: - UITextFieldDelegate

extension ApplicationsViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        rootView.prevButtonItem.isEnabled = !rootView.applicationsTextField.isFirstResponder
        rootView.nextButtonItem.isEnabled = !rootView.dateTimeTextField.isFirstResponder
    }

}
