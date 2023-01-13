//
//  LoginView.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 01/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import MobileVLCKit

// swiftlin:disable type_body_length
class LoginScreenLayout: UIView {

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
        backgroundColor = UIColor(color: .backgroundPrimary)

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(hintLabel)
        wrapperView.addSubview(cityTextField)
        wrapperView.addSubview(cityTextFieldBorderView)
        wrapperView.addSubview(guardServiceTextField)
        wrapperView.addSubview(guardServiceTextFieldBorderView)
        wrapperView.addSubview(phoneTextField)
        wrapperView.addSubview(phoneTextFieldBorderView)
        wrapperView.addSubview(submitButton)

        scrollView.addSubview(wrapperView)

        addSubview(scrollView)

        toolbar.setItems(
            [prevButtonItem, gap, nextButtonItem, spacer, doneButtonItem],
            animated: false
        )

        cityTextField.inputAccessoryView = toolbar
        guardServiceTextField.inputAccessoryView = toolbar
        phoneTextField.inputAccessoryView = toolbar

        cityTextField.inputView = cityPicker
        guardServiceTextField.inputView = guardServicePicker
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

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 96).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: dimensions.windowPadding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -dimensions.windowPadding).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true

        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        hintLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: dimensions.windowPadding).isActive = true
        hintLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -dimensions.windowPadding).isActive = true
        hintLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: dimensions.oneLineTextFieldHeight).isActive = true

        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 56).isActive = true
        cityTextField.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: dimensions.windowPadding).isActive = true
        cityTextField.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -dimensions.windowPadding).isActive = true
        cityTextField.heightAnchor.constraint(equalToConstant: dimensions.oneLineTextFieldHeight).isActive = true

        cityTextFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        cityTextFieldBorderView.leadingAnchor.constraint(equalTo: cityTextField.leadingAnchor).isActive = true
        cityTextFieldBorderView.trailingAnchor.constraint(equalTo: cityTextField.trailingAnchor).isActive = true
        cityTextFieldBorderView.bottomAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 1).isActive = true
        cityTextFieldBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        guardServiceTextField.translatesAutoresizingMaskIntoConstraints = false
        guardServiceTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 8).isActive = true
        guardServiceTextField.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: dimensions.windowPadding).isActive = true
        guardServiceTextField.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -dimensions.windowPadding).isActive = true
        guardServiceTextField.heightAnchor.constraint(equalToConstant: dimensions.oneLineTextFieldHeight).isActive = true

        guardServiceTextFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        guardServiceTextFieldBorderView.leadingAnchor.constraint(equalTo: guardServiceTextField.leadingAnchor).isActive = true
        guardServiceTextFieldBorderView.trailingAnchor.constraint(equalTo: guardServiceTextField.trailingAnchor).isActive = true
        guardServiceTextFieldBorderView.bottomAnchor.constraint(equalTo: guardServiceTextField.bottomAnchor, constant: 1).isActive = true
        guardServiceTextFieldBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.topAnchor.constraint(equalTo: guardServiceTextField.bottomAnchor, constant: 8).isActive = true
        phoneTextField.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16).isActive = true
        phoneTextField.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: dimensions.oneLineTextFieldHeight).isActive = true

        phoneTextFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        phoneTextFieldBorderView.leadingAnchor.constraint(equalTo: phoneTextField.leadingAnchor).isActive = true
        phoneTextFieldBorderView.trailingAnchor.constraint(equalTo: phoneTextField.trailingAnchor).isActive = true
        phoneTextFieldBorderView.bottomAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 1).isActive = true
        phoneTextFieldBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: dimensions.windowPadding).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -dimensions.windowPadding).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -96).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: dimensions.buttonHeight).isActive = true
    }
    // swiftlint:enable line_length

    private func updateAppearance() {
        cityTextField.setLeftPadding(dimensions.textFieldHorizontalPadding)
        guardServiceTextField.setLeftPadding(dimensions.textFieldHorizontalPadding)
        phoneTextField.setLeftPadding(dimensions.textFieldHorizontalPadding)

        [cityTextField, guardServiceTextField].forEach { textField in
            if let imageView = (textField.subviews.first { subview in subview is UIImageView }) {
                // Reset constraints
                imageView.removeFromSuperview()
                textField.addSubview(imageView)

                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: dimensions.dropdownIconSize).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: dimensions.dropdownIconSize).isActive = true
                imageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
                imageView.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -dimensions.textFieldHorizontalPadding).isActive = true // swiftlint:disable:this line_length
            }
        }

        layoutIfNeeded()
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

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.display1.font
        label.textColor = UIColor(color: .textPrimary)
        label.text = "Log in".localized
        return label
    }()

    let hintLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = TextStyle.paragraph.font
        label.textColor = UIColor(color: .textSecondary)
        label.text = "Enter your credentials in the text fields below".localized
        return label
    }()

    let cityTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor(color: .backgroundSurface)
        textField.layer.cornerRadius = Dimensions.defaultValues.textFieldCornerRadius
        textField.font = TextStyle.paragraph.font
        textField.textColor = UIColor(color: .textPrimary)

        let placeholderText = "City".localized
        let placeholderColor = UIColor(color: .textSecondary)
        let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        let placeholder = NSAttributedString(string: placeholderText, attributes: attributes)

        textField.attributedPlaceholder = placeholder

        let imageViewFrame = CGRect(
            x: 0,
            y: 0,
            width: Dimensions.defaultValues.dropdownIconSize,
            height: Dimensions.defaultValues.dropdownIconSize
        )

        let imageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(image: .dropdownIcon)
        imageView.contentMode = .scaleAspectFit

        textField.addSubview(imageView)

        return textField
    }()

    let cityTextFieldBorderView: UIView = {
        var bottomLine = UIView(frame: .zero)
        bottomLine.backgroundColor = UIColor(color: .darkAppearanceBorder)
        return bottomLine
    }()

    let guardServiceTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor(color: .backgroundSurface)
        textField.layer.cornerRadius = Dimensions.defaultValues.textFieldCornerRadius
        textField.font = TextStyle.paragraph.font
        textField.textColor = UIColor(color: .textPrimary)

        let placeholderText = "Guard service".localized
        let placeholderColor = UIColor(color: .textSecondary)
        let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        let placeholder = NSAttributedString(string: placeholderText, attributes: attributes)

        textField.attributedPlaceholder = placeholder

        let imageViewFrame = CGRect(
            x: 0,
            y: 0,
            width: Dimensions.defaultValues.dropdownIconSize,
            height: Dimensions.defaultValues.dropdownIconSize
        )

        let imageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(image: .dropdownIcon)
        imageView.contentMode = .scaleAspectFit

        textField.addSubview(imageView)

        return textField
    }()

    let guardServiceTextFieldBorderView: UIView = {
        var bottomLine = UIView(frame: .zero)
        bottomLine.backgroundColor = UIColor(color: .darkAppearanceBorder)
        return bottomLine
    }()

    let phoneTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor(color: .backgroundSurface)
        textField.layer.cornerRadius = Dimensions.defaultValues.textFieldCornerRadius
        textField.setLeftPadding(Dimensions.defaultValues.textFieldHorizontalPadding)
        textField.font = TextStyle.paragraph.font
        textField.textColor = UIColor(color: .textPrimary)
        textField.clearButtonMode = .whileEditing
        textField.textContentType = .telephoneNumber
        textField.keyboardType = .phonePad

        let placeholderText = "Phone number".localized
        let placeholderColor = UIColor(color: .textSecondary)
        let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        let placeholder = NSAttributedString(string: placeholderText, attributes: attributes)

        textField.attributedPlaceholder = placeholder

        return textField
    }()

    let phoneTextFieldBorderView: UIView = {
        var bottomLine = UIView(frame: .zero)
        bottomLine.backgroundColor = UIColor(color: .darkAppearanceBorder)
        return bottomLine
    }()

    let submitButton: UIButton = {
        let button = SolidButton()
        button.layer.cornerRadius = Dimensions.defaultValues.buttonCornerRadius
        button.backgroundColorNormal = UIColor(color: .accent)
        button.backgroundColorHighlighted = UIColor(color: .accent).lighter
        button.backgroundColorDisabled = UIColor(color: .accent).lighter
        button.setTitleColor(UIColor(color: .textOnAccent), for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        button.setTitle("Get password".localized, for: .normal)
        button.isEnabled = false
        return button
    }()

    let cityPicker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        return picker
    }()

    let guardServicePicker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        return picker
    }()

    let prevButtonItem: UIBarButtonItem = {
        let image = UIImage(image: .previousButtonIcon)
        let item = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        return item
    }()

    let nextButtonItem: UIBarButtonItem = {
        let image = UIImage(image: .nextButtonIcon)
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
        toolbar.tintColor = UIColor(color: .accent)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        return toolbar
    }()

}
