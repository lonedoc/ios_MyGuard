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

    func changeIndicatorState(indicator: UIImageView, highlighted: Bool) {
        let image = UIImage.assets(highlighted ? .dotSolid : .dotOutlined)

        if #available(iOS 13.0, *) {
            let coloredImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
            indicator.image = coloredImage
        } else {
            indicator.image = image?.withRenderingMode(.alwaysTemplate)
            indicator.tintColor = .white
        }
    }

    func changeBiometricButtonType(_ biometryType: BiometryType) {
        let image: UIImage?

        switch biometryType {
        case .faceID:
            image = UIImage.assets(.faceId)
        case .touchID:
            image = UIImage.assets(.touchId)
        case .none:
            biometricButton.alpha = 0
            biometricButton.isUserInteractionEnabled = false
            return
        }

        if #available(iOS 13.0, *) {
            let imageNormal = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
            let imageHighlighted = image?.withTintColor(.white, renderingMode: .alwaysOriginal)

            biometricButton.setImage(imageNormal, for: .normal)
            biometricButton.setImage(imageHighlighted, for: .highlighted)
        } else {
            biometricButton.setImage(image, for: .normal)
            biometricButton.setImage(image, for: .highlighted)
            biometricButton.tintColor = .white
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
        addSubview(backgroundView)

        digitButtons[1...4].forEach { keyboardRows[0].addArrangedSubview($0) }
        digitButtons[4...7].forEach { keyboardRows[1].addArrangedSubview($0) }
        digitButtons[7... ].forEach { keyboardRows[2].addArrangedSubview($0) }

        keyboardRows[3].addArrangedSubview(biometricButton)
        keyboardRows[3].addArrangedSubview(digitButtons[0])
        keyboardRows[3].addArrangedSubview(backspaceButton)

        keyboardRows.forEach { keyboardStackView.addArrangedSubview($0) }

        indicators.forEach { indicatorRow.addArrangedSubview($0) }

        wrapperView.addSubview(tipLabel)
        wrapperView.addSubview(indicatorRow)

        addSubview(forgotPasscodeButton)
        addSubview(keyboardStackView)
        addSubview(wrapperView)

        titleView.addSubview(logoView)
    }

    // swiftlint:disable function_body_length line_length
    private func setupConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        forgotPasscodeButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasscodeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        forgotPasscodeButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true

        keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
        keyboardStackView.bottomAnchor.constraint(equalTo: forgotPasscodeButton.topAnchor, constant: -16).isActive = true
        keyboardStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        keyboardStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true

        digitButtons.forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 80).isActive = true
            button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }

        biometricButton.translatesAutoresizingMaskIntoConstraints = false
        biometricButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        biometricButton.heightAnchor.constraint(equalToConstant: 80).isActive = true

        backspaceButton.translatesAutoresizingMaskIntoConstraints = false
        backspaceButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backspaceButton.heightAnchor.constraint(equalToConstant: 80).isActive = true

        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        wrapperView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        wrapperView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: keyboardStackView.topAnchor).isActive = true

        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.bottomAnchor.constraint(equalTo: wrapperView.centerYAnchor, constant: -8).isActive = true
        tipLabel.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor).isActive = true

        indicators.forEach { indicator in
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
            indicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }

        indicatorRow.translatesAutoresizingMaskIntoConstraints = false
        indicatorRow.widthAnchor.constraint(equalToConstant: 120).isActive = true
        indicatorRow.topAnchor.constraint(equalTo: wrapperView.centerYAnchor, constant: 8).isActive = true
        indicatorRow.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor).isActive = true

        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.heightAnchor.constraint(equalTo: titleView.heightAnchor, multiplier: 0.8).isActive = true
        logoView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
    }
    // swiftlint:enable function_body_length line_length

    // MARK: Views

    let backgroundView: UIImageView = {
        let image = UIImage.assets(.background)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFill
        return view
    }()

    let wrapperView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    let tipLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.text = "Enter the code".localized
        return label
    }()

    let indicatorRow: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    let indicators: [UIImageView] = {
        var indicators = [UIImageView]()

        var i = 0 // swiftlint:disable:this identifier_name
        while i < 4 {
            let image = UIImage.assets(.dotOutlined)

            if #available(iOS 13.0, *) {
                let coloredImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
                let indicator = UIImageView(image: coloredImage)
                indicators.append(indicator)
            } else {
                let indicator = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
                indicator.tintColor = .white
                indicators.append(indicator)
            }

            i += 1
        }

        return indicators
    }()

    let forgotPasscodeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Forgot passcode?".localized.uppercased(), for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .normal)
        button.setTitleColor(.white, for: .highlighted)

        let descriptor = button.titleLabel?.font?.fontDescriptor.addingAttributes(
            [.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold]]
        )

        if let descriptor = descriptor {
            let font = UIFont(descriptor: descriptor, size: 18)
            button.titleLabel?.font = font
        } else {
            button.titleLabel?.font = button.titleLabel?.font.withSize(18)
        }

        return button
    }()

    let keyboardStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()

    let keyboardRows: [UIStackView] = {
        var rows = [UIStackView]()

        var i = 0 // swiftlint:disable:this identifier_name
        while i < 4 {
            let row = UIStackView(frame: .zero)
            row.axis = .horizontal
            row.alignment = .fill
            row.distribution = .equalCentering
            row.spacing = 15
            rows.append(row)

            i += 1
        }

        return rows
    }()

    let digitButtons: [UIButton] = {
        var buttons = [UIButton]()

        let tips = [
            " ",
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

        var i = 0 // swiftlint:disable:this identifier_name
        while i < 10 {
            let button = UIButton(type: .custom)
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.textAlignment = .center
            button.tag = i

            let digitAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]

            let digitString = NSMutableAttributedString(string: "\(String(i))\n", attributes: digitAttributes)

            let tipAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)
            ]

            let tipString = NSAttributedString(string: tips[i].localized, attributes: tipAttributes)

            digitString.append(tipString)

            button.setAttributedTitle(digitString, for: .normal)

            let backgroundColor = UIColor.white.withAlphaComponent(0.2)
            button.setBackgroundColor(backgroundColor, for: .highlighted)
            button.layer.cornerRadius = 40

            buttons.append(button)

            i += 1
        }

        return buttons
    }()

    let biometricButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let image = UIImage.assets(.faceId)

        if #available(iOS 13.0, *) {
            let coloredImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
            button.setImage(coloredImage, for: .normal)
            button.setImage(coloredImage, for: .highlighted)
        } else {
            button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .white
        }

        let backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.setBackgroundColor(backgroundColor, for: .highlighted)
        button.layer.cornerRadius = 40

        return button
    }()

    let backspaceButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage.assets(.backspace)

        if #available(iOS 13.0, *) {
            let coloredImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
            button.setImage(coloredImage, for: .normal)
            button.setImage(coloredImage, for: .highlighted)
        } else {
            button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .white
        }

        let backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.setBackgroundColor(backgroundColor, for: .highlighted)
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

    let titleView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    let logoView: UIImageView = {
        let view = UIImageView(image: UIImage.assets(.logo))
        view.contentMode = .scaleAspectFit
        return view
    }()

}
