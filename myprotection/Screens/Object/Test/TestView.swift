//
//  TestView.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.05.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation

class TestView: UIView {

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
        containerView.addSubview(tipText)
        containerView.addSubview(countDownText)
        containerView.addSubview(resetButton)
        containerView.addSubview(completeButton)

        addSubview(containerView)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        tipText.translatesAutoresizingMaskIntoConstraints = false
        tipText.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        tipText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        tipText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        tipText.heightAnchor.constraint(equalToConstant: 48).isActive = true

        countDownText.translatesAutoresizingMaskIntoConstraints = false
        countDownText.topAnchor.constraint(equalTo: tipText.bottomAnchor).isActive = true
        countDownText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        countDownText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        countDownText.bottomAnchor.constraint(equalTo: resetButton.topAnchor).isActive = true

        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        resetButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -8).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
        completeButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 8).isActive = true
        completeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        completeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

    // MARK: - Views

    let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .backgroundColor
        return view
    }()

    let tipText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .paleTextColor
        return label
    }()

    let countDownText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .contrastTextColor
        label.font = label.font.withSize(64)
        label.text = "0:00"
        return label
    }()

    let resetButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.setBackgroundColor(.primaryColor, for: .normal)
        button.setBackgroundColor(.primaryColorPale, for: .disabled)
        button.setTitle("Reset".localized, for: .normal)
        button.isEnabled = false
        return button
    }()

    let completeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.setBackgroundColor(.primaryColor, for: .normal)
        button.setBackgroundColor(.primaryColorPale, for: .disabled)
        button.setTitle("Complete".localized, for: .normal)
        return button
    }()
    
}
