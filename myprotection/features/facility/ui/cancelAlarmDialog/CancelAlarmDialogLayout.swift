//
//  CancelAlarmDialogLayout.swift
//  myprotection
//
//  Created by Rubeg NPO on 30.03.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

class CancelAlarmDialogLayout: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .black.withAlphaComponent(0.5)

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        container.addSubview(titleView)
        container.addSubview(radioButton0)
        container.addSubview(radioButton1)
        container.addSubview(radioButton2)
        container.addSubview(radioButton3)
        container.addSubview(cancelButton)
        container.addSubview(proceedButton)

        addSubview(container)
    }

    private func setupConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 240).isActive = true

        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
        titleView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true

        radioButton0.translatesAutoresizingMaskIntoConstraints = false
        radioButton0.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16).isActive = true
        radioButton0.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        radioButton0.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 16).isActive = true
        radioButton0.heightAnchor.constraint(equalToConstant: 24).isActive = true

        radioButton1.translatesAutoresizingMaskIntoConstraints = false
        radioButton1.topAnchor.constraint(equalTo: radioButton0.bottomAnchor, constant: 12).isActive = true
        radioButton1.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        radioButton1.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 16).isActive = true
        radioButton1.heightAnchor.constraint(equalToConstant: 24).isActive = true

        radioButton2.translatesAutoresizingMaskIntoConstraints = false
        radioButton2.topAnchor.constraint(equalTo: radioButton1.bottomAnchor, constant: 12).isActive = true
        radioButton2.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        radioButton2.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 16).isActive = true
        radioButton2.heightAnchor.constraint(equalToConstant: 24).isActive = true

        radioButton3.translatesAutoresizingMaskIntoConstraints = false
        radioButton3.topAnchor.constraint(equalTo: radioButton2.bottomAnchor, constant: 12).isActive = true
        radioButton3.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        radioButton3.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 16).isActive = true
        radioButton3.heightAnchor.constraint(equalToConstant: 24).isActive = true

        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        proceedButton.topAnchor.constraint(equalTo: radioButton3.bottomAnchor, constant: 16).isActive = true
        proceedButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: radioButton3.bottomAnchor, constant: 16).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: proceedButton.leadingAnchor, constant: -24).isActive = true
    }

    // MARK: - Views
    let container: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()

    let titleView: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Cancel the alarm".localized
        return label
    }()

    let radioButton0: RadioButton = {
        let radioButton = RadioButton(frame: .zero)
        return radioButton
    }()

    let radioButton1: RadioButton = {
        let radioButton = RadioButton(frame: .zero)
        return radioButton
    }()

    let radioButton2: RadioButton = {
        let radioButton = RadioButton(frame: .zero)
        return radioButton
    }()

    let radioButton3: RadioButton = {
        let radioButton = RadioButton(frame: .zero)
        return radioButton
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Go back".localized, for: .normal)
        button.setTitleColor(UIColor.primaryColor, for: .normal)
        button.setTitleColor(UIColor.primaryColorPale, for: .highlighted)

        let descriptor = button.titleLabel?.font?.fontDescriptor.addingAttributes(
            [.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]]
        )

        if let descriptor = descriptor {
            let font = UIFont(descriptor: descriptor, size: 18)
            button.titleLabel?.font = font
        } else {
            button.titleLabel?.font = button.titleLabel?.font.withSize(18)
        }

        return button
    }()

    let proceedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Cancel the alarm".localized, for: .normal)
        button.setTitleColor(UIColor.primaryColor, for: .normal)
        button.setTitleColor(UIColor.primaryColorPale, for: .highlighted)
        button.setTitleColor(UIColor.primaryColorPale, for: .disabled)

        let descriptor = button.titleLabel?.font?.fontDescriptor.addingAttributes(
            [.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]]
        )

        if let descriptor = descriptor {
            let font = UIFont(descriptor: descriptor, size: 18)
            button.titleLabel?.font = font
        } else {
            button.titleLabel?.font = button.titleLabel?.font.withSize(18)
        }

        button.isEnabled = false

        return button
    }()

}
