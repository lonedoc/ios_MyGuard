//
//  LoginView.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 01/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import MobileVLCKit

class LoginScreenLayout: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .darkBackgroundColor

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(backgroundView)

        contentView.addSubview(logoView)
        contentView.addSubview(logoTextView)
        contentView.addSubview(cityTextField)
        contentView.addSubview(guardServiceTextField)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(submitButton)

        wrapperView.addSubview(contentView)
        scrollView.addSubview(wrapperView)

        addSubview(scrollView)

        toolbar.setItems(
            [prevButtonItem, gap, nextButtonItem, spacer, doneButtonItem],
            animated: false
        )

        cityTextField.inputView = cityPicker
        guardServiceTextField.inputView = guardServicePicker
    }

    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true

        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        wrapperView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        wrapperView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        wrapperView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        wrapperView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 410).isActive = true
        contentView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor).isActive = true

        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        logoView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        logoTextView.translatesAutoresizingMaskIntoConstraints = false
        logoTextView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 16).isActive = true
        logoTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cityTextField.topAnchor.constraint(equalTo: logoTextView.bottomAnchor, constant: 60).isActive = true
        cityTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cityTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        guardServiceTextField.translatesAutoresizingMaskIntoConstraints = false
        guardServiceTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        guardServiceTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 1).isActive = true
        guardServiceTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        guardServiceTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        phoneTextField.topAnchor.constraint(equalTo: guardServiceTextField.bottomAnchor, constant: 1).isActive = true
        phoneTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        phoneTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        submitButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 32).isActive = true
        submitButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        submitButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }

    // MARK: Views

    let backgroundView: UIImageView = {
        let image = UIImage.assets(.background)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFill
        return view
    }()

    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        return view
    }()

    let wrapperView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    let contentView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    let logoView: UIImageView = {
        let image = UIImage.assets(.logo)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFill
        return view
    }()

    let logoTextView: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .white
        view.font = UIFont.boldSystemFont(ofSize: 30)
        view.text = "Рубеж НПО" // It shouldn't be localized, as it's part of the logo
        return view
    }()

    let cityTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.setLeftPadding(16)
        textField.setRightPadding(16)
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        textField.textColor = .white

        let placeholderText = "City".localized
        let placeholderColor = UIColor.white.withAlphaComponent(0.6)
        let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        let placeholder = NSAttributedString(string: placeholderText, attributes: attributes)

        textField.attributedPlaceholder = placeholder

        return textField
    }()

    let guardServiceTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.setLeftPadding(16)
        textField.setRightPadding(16)
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        textField.textColor = .white

        let placeholderText = "Security company".localized
        let placeholderColor = UIColor.white.withAlphaComponent(0.6)
        let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        let placeholder = NSAttributedString(string: placeholderText, attributes: attributes)

        textField.attributedPlaceholder = placeholder

        return textField
    }()

    let phoneTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.textContentType = .telephoneNumber
        textField.keyboardType = .phonePad
        textField.setLeftPadding(16)
        textField.setRightPadding(16)
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        textField.textColor = .white

        let placeholderText = "Phone number".localized
        let placeholderColor = UIColor.white.withAlphaComponent(0.6)
        let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        let placeholder = NSAttributedString(string: placeholderText, attributes: attributes)

        textField.attributedPlaceholder = placeholder

        return textField
    }()

    let submitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        button.layer.cornerRadius = 5
        button.setTitle("Get password".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.setBackgroundColor(.primaryColor, for: .normal)
        button.setBackgroundColor(.primaryColorPale, for: .disabled)
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
