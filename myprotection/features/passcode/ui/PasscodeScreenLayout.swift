//
//  PasswordView.swift
//  myprotection
//
//  Created by Rubeg NPO on 22.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit

// swiftlint:disable type_body_length
class PasscodeScreenLayout: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setIndicator(value: Int) {
        indicator.setIndicator(value: value)
    }

    func changeBiometricButtonType(_ biometryType: BiometryType) {
        let image: UIImage

        switch biometryType {
        case .faceID:
            image = UIImage(image: .faceIdIcon)
        case .touchID:
            image = UIImage(image: .touchIdIcon)
        case .none:
            biometricButton.alpha = 0
            biometricButton.isUserInteractionEnabled = false
            return
        }

        if #available(iOS 13.0, *) {
            let color = UIColor(color: .error)
            let imageNormal = image.withTintColor(color, renderingMode: .alwaysOriginal)
            let imageHighlighted = image.withTintColor(color, renderingMode: .alwaysOriginal)

            biometricButton.setImage(imageNormal, for: .normal)
            biometricButton.setImage(imageHighlighted, for: .highlighted)
        } else {
            biometricButton.setImage(image, for: .normal)
            biometricButton.setImage(image, for: .highlighted)
            biometricButton.tintColor = UIColor(color: .error)
        }

        biometricButton.alpha = 1
        biometricButton.isUserInteractionEnabled = true
    }

    private func setup() {
        backgroundColor = .darkBackgroundColor

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = UIColor(color: .backgroundPrimary)

        digitButtons[1...4].forEach { button in keyboardRows[0].addArrangedSubview(button) }
        digitButtons[4...7].forEach { button in keyboardRows[1].addArrangedSubview(button) }
        digitButtons[7... ].forEach { button in keyboardRows[2].addArrangedSubview(button) }

        keyboardRows[3].addArrangedSubview(biometricButton)
        keyboardRows[3].addArrangedSubview(digitButtons[0])
        keyboardRows[3].addArrangedSubview(backspaceButton)

        keyboardRows.forEach { row in keyboardStackView.addArrangedSubview(row) }

        containerView.addArrangedSubview(hintLabel)
        containerView.addArrangedSubview(indicator)
        containerView.addArrangedSubview(keyboardStackView)
        containerView.addArrangedSubview(forgotPasscodeButton)

        addSubview(containerView)
    }

    // swiftlint:disable function_body_length line_length
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 72).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true

        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        hintLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true

        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 96).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 12).isActive = true

        (digitButtons + [biometricButton, backspaceButton]).forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 80).isActive = true
            button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }

        keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
        keyboardStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        keyboardStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true

        forgotPasscodeButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasscodeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        forgotPasscodeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        forgotPasscodeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
    }
    // swiftlint:enable function_body_length line_length

    // MARK: Views

    let containerView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()

    let hintLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = TextStyle.paragraph.font
        label.textColor = UIColor(color: .textContrast)
        label.text = "Create a PIN-code".localized
        return label
    }()

    let indicator: PasscodeIndicator = {
        let indicator = PasscodeIndicator(frame: .zero)
        return indicator
    }()

    let forgotPasscodeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(UIColor(color: .accent), for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        button.setTitle("Forgot the PIN-code?".localized, for: .normal)
        button.isHidden = true
        return button
    }()

    let keyboardStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 18
        return stackView
    }()

    let keyboardRows: [UIStackView] = {
        var rows = [UIStackView]()

        var index = 0
        while index < 4 {
            let row = UIStackView(frame: .zero)
            row.axis = .horizontal
            row.alignment = .fill
            row.distribution = .equalSpacing
            row.spacing = 24

            rows.append(row)

            index += 1
        }

        return rows
    }()

    let digitButtons: [UIButton] = {
        var buttons = [UIButton]()

        let tips = [
            "+",
            " ",
            "abc",
            "def",
            "ghi",
            "jkl",
            "mno",
            "pqrs",
            "tuv",
            "wxyz"
        ]

        var index = 0
        while index < 10 {
            let button = SolidButton()
            button.layer.cornerRadius = 40
            button.backgroundColorNormal = UIColor(color: .digitButtonBackground)
            button.backgroundColorHighlighted = UIColor(color: .digitButtonBackground).lighter
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.textAlignment = .center
            button.tag = index

            let digitAttributes = [
                NSAttributedString.Key.font: TextStyle.digitButtonTitle.font,
                NSAttributedString.Key.foregroundColor: UIColor(color: .textContrast)
            ]

            let digitString = NSMutableAttributedString(string: "\(String(index))\n", attributes: digitAttributes)

            let tipAttributes = [
                NSAttributedString.Key.font: TextStyle.caption4.font,
                NSAttributedString.Key.foregroundColor: UIColor(color: .textContrast)
            ]

            let tipString = NSAttributedString(string: tips[index].localized, attributes: tipAttributes)

            digitString.append(tipString)

            button.setAttributedTitle(digitString, for: .normal)

            buttons.append(button)

            index += 1
        }

        return buttons
    }()

    let biometricButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        let image = UIImage(image: .faceIdIcon)

        if #available(iOS 13.0, *) {
            let coloredImage = image.withTintColor(
                UIColor(color: .error),
                renderingMode: .alwaysOriginal
            )

            button.setImage(coloredImage, for: .normal)
            button.setImage(coloredImage, for: .highlighted)
        } else {
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = UIColor(color: .error)
        }

        button.layer.cornerRadius = 40

        return button
    }()

    let backspaceButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(image: .backspaceIcon)

        if #available(iOS 13.0, *) {
            let coloredImage = image.withTintColor(
                UIColor(color: .backspaceButtonColor),
                renderingMode: .alwaysOriginal
            )

            button.setImage(coloredImage, for: .normal)
            button.setImage(coloredImage, for: .highlighted)
        } else {
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = UIColor(color: .backspaceButtonColor)
        }

        button.layer.cornerRadius = 40

        return button
    }()

    let phoneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage.assets(.phone),
            style: .plain,
            target: nil,
            action: nil
        )
        return button
    }()

    let exitButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage.assets(.exit),
            style: .plain,
            target: nil,
            action: nil
        )
        return button
    }()

}
