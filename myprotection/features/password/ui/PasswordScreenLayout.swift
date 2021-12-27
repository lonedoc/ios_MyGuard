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

    private func setup() {
        backgroundColor = .darkBackgroundColor

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(backgroundView)

        contentView.addSubview(requestLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(timeLeftLabel)
        contentView.addSubview(retryButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(proceedButton)

        wrapperView.addSubview(contentView)
        scrollView.addSubview(wrapperView)

        addSubview(scrollView)

        toolbar.setItems([spacer, doneButtonItem], animated: false)

        passwordTextField.inputAccessoryView = toolbar
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
        contentView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        contentView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor).isActive = true

        requestLabel.translatesAutoresizingMaskIntoConstraints = false
        requestLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        requestLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        requestLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: requestLabel.bottomAnchor, constant: 32).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        timeLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLeftLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32).isActive = true
        timeLeftLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32).isActive = true
        timeLeftLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32).isActive = true

        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.centerXAnchor.constraint(equalTo: timeLeftLabel.centerXAnchor).isActive = true
        retryButton.centerYAnchor.constraint(equalTo: timeLeftLabel.centerYAnchor).isActive = true

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: timeLeftLabel.bottomAnchor, constant: 48).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8).isActive = true

        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        proceedButton.topAnchor.constraint(equalTo: timeLeftLabel.bottomAnchor, constant: 48).isActive = true
        proceedButton.leftAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8).isActive = true
        proceedButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
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

    let requestLabel: UILabel = {
        // swiftlint:disable:next line_length
        let text = "An sms message with a password has been sent to your number. Please, enter it in the text field below:".localized
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.text = text
        return label
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.keyboardType = .numberPad
        textField.setLeftPadding(16)
        textField.setRightPadding(16)
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        textField.textColor = .white

        let placeholderText = "Password".localized
        let placeholderColor = UIColor.white.withAlphaComponent(0.6)
        let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        let placeholder = NSAttributedString(string: placeholderText, attributes: attributes)

        textField.attributedPlaceholder = placeholder

        return textField
    }()

    let timeLeftLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = label.font.withSize(16)
        label.text = " "
        return label
    }()

    let retryButton: UIButton = {
        let title = "Get new password".localized.uppercased()
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let button = UIButton(frame: .zero)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.secondaryColor, for: .normal)
        button.titleLabel?.font = font
        button.isHidden = true
        return button
    }()
    let cancelButton: UIButton = {
        let title = "Cancel".localized
        let button = UIButton(frame: .zero)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        button.layer.cornerRadius = 5
        button.setBackgroundColor(.errorColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    let proceedButton: UIButton = {
        let title = "Next".localized
        let button = UIButton(frame: .zero)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        button.layer.cornerRadius = 5
        button.setBackgroundColor(.primaryColor, for: .normal)
        button.setBackgroundColor(.primaryColorPale, for: .disabled)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.isEnabled = false
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
        toolbar.tintColor = .primaryColor
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        return toolbar
    }()
}
