//
//  ApplicationsScreenLayout.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.05.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

class ApplicationsScreenLayout: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(applicationsLabel)
        addSubview(applicationsTextField)
        addSubview(applicationTextLabel)
        addSubview(applicationTextField)
        addSubview(dateLabel)
        addSubview(dateTextField)
        addSubview(submitButton)

        toolbar.setItems(
            [prevButtonItem, gap, nextButtonItem, spacer, doneButtonItem],
            animated: false
        )

        applicationsTextField.inputView = applicationPicker
        dateTextField.inputView = datePicker

        applicationsTextField.inputAccessoryView = toolbar
        applicationTextField.inputAccessoryView = toolbar
        dateTextField.inputAccessoryView = toolbar
    }

    // swiftlint:disable line_length
    private func setupConstraints() {
        applicationsLabel.translatesAutoresizingMaskIntoConstraints = false
        applicationsLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        applicationsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        applicationsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true

        applicationsTextField.translatesAutoresizingMaskIntoConstraints = false
        applicationsTextField.topAnchor.constraint(equalTo: applicationsLabel.bottomAnchor, constant: 8).isActive = true
        applicationsTextField.leadingAnchor.constraint(equalTo: applicationsLabel.leadingAnchor).isActive = true
        applicationsTextField.trailingAnchor.constraint(equalTo: applicationsLabel.trailingAnchor).isActive = true

        applicationTextLabel.translatesAutoresizingMaskIntoConstraints = false
        applicationTextLabel.topAnchor.constraint(equalTo: applicationsTextField.bottomAnchor, constant: 16).isActive = true
        applicationTextLabel.leadingAnchor.constraint(equalTo: applicationsLabel.leadingAnchor).isActive = true
        applicationTextLabel.trailingAnchor.constraint(equalTo: applicationsLabel.trailingAnchor).isActive = true

        applicationTextField.translatesAutoresizingMaskIntoConstraints = false
        applicationTextField.topAnchor.constraint(equalTo: applicationTextLabel.bottomAnchor, constant: 8).isActive = true
        applicationTextField.leadingAnchor.constraint(equalTo: applicationsLabel.leadingAnchor).isActive = true
        applicationTextField.trailingAnchor.constraint(equalTo: applicationsLabel.trailingAnchor).isActive = true
        applicationTextField.heightAnchor.constraint(equalToConstant: 96).isActive = true

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: applicationTextField.bottomAnchor, constant: 16).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: applicationsLabel.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: applicationsLabel.trailingAnchor).isActive = true

        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8).isActive = true
        dateTextField.leadingAnchor.constraint(equalTo: applicationsLabel.leadingAnchor).isActive = true
        dateTextField.trailingAnchor.constraint(equalTo: applicationsLabel.trailingAnchor).isActive = true

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 24).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    // swiftlint:enable line_length

    // MARK: - Views

    let applicationsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.text = "Application:".localized
        return label
    }()

    let applicationsTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .line
        return textField
    }()

    let applicationTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.text = "Application text:".localized
        return label
    }()

    let applicationTextField: UITextView = {
        let textField = UITextView(frame: .zero)
        textField.layer.borderWidth = 1
        textField.font = { UITextField().font }()
        return textField
    }()

    let dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(16)
        label.textColor = .black
        label.text = "Date and time:".localized
        return label
    }()

    let dateTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .line
        return textField
    }()

    let submitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        button.layer.cornerRadius = 5
        button.setTitle("Apply".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.setBackgroundColor(.primaryColor, for: .normal)
        button.setBackgroundColor(.primaryColorPale, for: .disabled)
        button.isEnabled = false
        return button
    }()

    let prevButtonItem: UIBarButtonItem = {
        let image = UIImage.assets(.leftArrow)
        let item = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        return item
    }()

    let nextButtonItem: UIBarButtonItem = {
        let image = UIImage.assets(.rightArrow)
        let item = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        return item
    }()

    let doneButtonItem: UIBarButtonItem = {
        let titleText = "Done".localized
        let item = UIBarButtonItem(title: titleText, style: .done, target: nil, action: nil)
        return item
    }()

    let spacer: UIBarButtonItem = {
        let item = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        return item
    }()

    let gap: UIBarButtonItem = {
        let item = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: nil,
            action: nil
        )
        item.width = 16
        return item
    }()

    let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.tintColor = .primaryColor
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        return toolbar
    }()

    let applicationPicker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        return picker
    }()

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.datePickerMode = .dateAndTime

        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }

        picker.minimumDate = Date()

        return picker
    }()

}
