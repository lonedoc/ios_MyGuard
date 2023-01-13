//
//  PasswordView.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 22/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit

class PasswordScreenLayout: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        updateAppearance()
        super.layoutSubviews()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateAppearance()
    }

    private func setup() {
        backgroundColor = .darkBackgroundColor

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = UIColor(color: .backgroundPrimary)

        wrapperView.addSubview(hintLabel)
        wrapperView.addSubview(passwordTextField)
        wrapperView.addSubview(passwordTextFieldBorderView)
        wrapperView.addSubview(timeLeftLabel)
        wrapperView.addSubview(retryButton)
        wrapperView.addSubview(cancelButton)
        wrapperView.addSubview(proceedButton)

        scrollView.addSubview(wrapperView)

        addSubview(scrollView)

        toolbar.setItems([spacer, doneButtonItem], animated: false)
        passwordTextField.inputAccessoryView = toolbar
    }

    // swiftlint:disable line_length
    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        wrapperView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        wrapperView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        wrapperView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        wrapperView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 128).isActive = true
        hintLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: dimensions.windowPadding).isActive = true
        hintLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -dimensions.windowPadding).isActive = true
        hintLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 56).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: dimensions.windowPadding).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -dimensions.windowPadding).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: dimensions.oneLineTextFieldHeight).isActive = true

        passwordTextFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldBorderView.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        passwordTextFieldBorderView.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        passwordTextFieldBorderView.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 1).isActive = true
        passwordTextFieldBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        timeLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLeftLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 56).isActive = true
        timeLeftLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: dimensions.windowPadding).isActive = true
        timeLeftLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -dimensions.windowPadding).isActive = true
        timeLeftLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true

        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.centerXAnchor.constraint(equalTo: timeLeftLabel.centerXAnchor).isActive = true
        retryButton.centerYAnchor.constraint(equalTo: timeLeftLabel.centerYAnchor).isActive = true

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: dimensions.windowPadding).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -dimensions.windowPadding).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -96).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: dimensions.buttonHeight).isActive = true

        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        proceedButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: dimensions.windowPadding).isActive = true
        proceedButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -dimensions.windowPadding).isActive = true
        proceedButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -8).isActive = true
        proceedButton.heightAnchor.constraint(equalToConstant: dimensions.buttonHeight).isActive = true
    }
    // swiftlint:enable line_length

    private func updateAppearance() {
        passwordTextField.setLeftPadding(dimensions.textFieldHorizontalPadding)
    }

    // MARK: Views

    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        return view
    }()

    let wrapperView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    let hintLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = TextStyle.paragraph.font
        label.textColor = UIColor(color: .textContrast)
        label.text = "An SMS message with a password has been sent to your number".localized
        return label
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor(color: .backgroundSurface)
        textField.layer.cornerRadius = Dimensions.defaultValues.textFieldCornerRadius
        textField.setLeftPadding(Dimensions.defaultValues.textFieldHorizontalPadding)
        textField.font = TextStyle.paragraph.font
        textField.textColor = UIColor(color: .textPrimary)
        textField.keyboardType = .numberPad

        if #available(iOS 12, *) {
            textField.textContentType = .oneTimeCode
        }

        let placeholderText = "Enter the code".localized
        let placeholderColor = UIColor(color: .textSecondary)
        let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        let placeholder = NSAttributedString(string: placeholderText, attributes: attributes)

        textField.attributedPlaceholder = placeholder

        return textField
    }()

    let passwordTextFieldBorderView: UIView = {
        var bottomLine = UIView(frame: .zero)
        bottomLine.backgroundColor = UIColor(color: .darkAppearanceBorder)
        return bottomLine
    }()

    let timeLeftLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = TextStyle.paragraph.font
        label.textColor = UIColor(color: .textContrast)
        label.text = " "
        return label
    }()

    let retryButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(UIColor(color: .accent), for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        button.setTitle("Get new password".localized, for: .normal)
        button.isHidden = true
        return button
    }()

    let proceedButton: UIButton = {
        let button = SolidButton()
        button.layer.cornerRadius = Dimensions.defaultValues.buttonCornerRadius
        button.backgroundColorNormal = UIColor(color: .backgroundSurfaceVariant)
        button.backgroundColorHighlighted = UIColor(color: .backgroundSurfaceVariant).darker
        button.backgroundColorDisabled = UIColor(color: .backgroundSurfaceVariant).darker
        button.setTitleColor(UIColor(color: .accent), for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        button.setTitle("Proceed".localized, for: .normal)
        return button
    }()

    let cancelButton: UIButton = {
        let button = SolidButton()
        button.layer.cornerRadius = Dimensions.defaultValues.buttonCornerRadius
        button.backgroundColor = nil
        button.setTitleColor(UIColor(color: .error), for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        button.setTitle("Cancel".localized, for: .normal)
        return button
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

    let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.tintColor = UIColor(color: .accent)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        return toolbar
    }()
}
