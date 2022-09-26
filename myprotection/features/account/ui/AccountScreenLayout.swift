//
//  AccountScreenLayout.swift
//  myprotection
//
//  Created by Rubeg NPO on 11.01.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

class AccountScreenLayout: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .screenBackgroundColor

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(accountLabel)
        addSubview(accountTextField)
        addSubview(sumLabel)
        addSubview(sumTextField)
        addSubview(submitButton)

        toolbar.setItems(
            [prevButtonItem, gap, nextButtonItem, spacer, doneButtonItem],
            animated: false
        )

        accountTextField.inputView = accountPicker
    }

    private func setupConstraints() {
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        accountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        accountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true

        accountTextField.translatesAutoresizingMaskIntoConstraints = false
        accountTextField.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8).isActive = true
        accountTextField.leadingAnchor.constraint(equalTo: accountLabel.leadingAnchor).isActive = true
        accountTextField.trailingAnchor.constraint(equalTo: accountLabel.trailingAnchor).isActive = true

        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        sumLabel.topAnchor.constraint(equalTo: accountTextField.bottomAnchor, constant: 16).isActive = true
        sumLabel.leadingAnchor.constraint(equalTo: accountLabel.leadingAnchor).isActive = true
        sumLabel.trailingAnchor.constraint(equalTo: accountLabel.trailingAnchor).isActive = true

        sumTextField.translatesAutoresizingMaskIntoConstraints = false
        sumTextField.topAnchor.constraint(equalTo: sumLabel.bottomAnchor, constant: 8).isActive = true
        sumTextField.leadingAnchor.constraint(equalTo: accountLabel.leadingAnchor).isActive = true
        sumTextField.trailingAnchor.constraint(equalTo: accountLabel.trailingAnchor).isActive = true

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: sumTextField.bottomAnchor, constant: 16).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    // MARK: - Views

    let accountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(16)
        label.textColor = .screenForegroundColor
        label.text = "Account:".localized
        return label
    }()

    let accountTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .line
        textField.textColor = .screenForegroundColor
        return textField
    }()

    let sumLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(16)
        label.textColor = .screenForegroundColor
        label.text = "Sum:".localized
        return label
    }()

    let sumTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.textColor = .screenForegroundColor
        textField.borderStyle = .line
        textField.keyboardType = .decimalPad
        return textField
    }()

    let submitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        button.layer.cornerRadius = 5
        button.setTitle("Pay".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.setBackgroundColor(.primaryColor, for: .normal)
        button.setBackgroundColor(.primaryColorPale, for: .disabled)
        button.isEnabled = false
        return button
    }()

    let accountPicker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        return picker
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

}
