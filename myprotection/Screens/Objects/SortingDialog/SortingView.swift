//
//  SortingView.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

class SortingDialogView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addOption(title: String, value: Int) {
        let checkbox = PlainCheckBox(frame: .zero)
        checkbox.value = value
        checkbox.title = title

        checkbox.mainColor = .contrastTextColor
        checkbox.tintColor = .primaryColor

        checkbox.setImage(UIImage.assets(.done), for: .selected)

        radioButtons.append(checkbox)
        optionsStackView.addArrangedSubview(checkbox)

        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.leadingAnchor.constraint(equalTo: optionsStackView.leadingAnchor).isActive = true
        checkbox.trailingAnchor.constraint(equalTo: optionsStackView.trailingAnchor).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

    func addOption(title: String, values: [Int]) {
        let checkbox = MultiCheckBox(frame: .zero)
        checkbox.setValue(values[0], for: .main)
        checkbox.setValue(values[1], for: .alternative)

        checkbox.mainColor = .contrastTextColor
        checkbox.minorColor = .paleTextColor
        checkbox.tintColor = .primaryColor

        checkbox.title = title
        checkbox.setSubtitle("Ascending".localized, for: .main)
        checkbox.setSubtitle("Descending".localized, for: .alternative)

        checkbox.setImage(UIImage.assets(.downwardArrow), for: .main)
        checkbox.setImage(UIImage.assets(.upwardArrow), for: .alternative)

        radioButtons.append(checkbox)
        optionsStackView.addArrangedSubview(checkbox)

        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.leadingAnchor.constraint(equalTo: optionsStackView.leadingAnchor).isActive = true
        checkbox.trailingAnchor.constraint(equalTo: optionsStackView.trailingAnchor).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = UIColor.black.withAlphaComponent(0.25)

        container.addSubview(closeButton)
        container.addSubview(titleLabel)
        container.addSubview(optionsStackView)

        addSubview(container)
    }

    private func setupConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true

        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16).isActive = true
        optionsStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32).isActive = true
        optionsStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32).isActive = true
        optionsStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24).isActive = true
    }

    // MARK: - Views

    let container: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .backgroundColor
        return view
    }()

    let closeButton: UIButton = {
        let button = UIButton(type: .custom)

        let image = UIImage.assets(.close)
        if #available(iOS 13.0, *) {
            let coloredImage = image?.withTintColor(.contrastTextColor)
            button.setImage(coloredImage, for: .normal)
        } else {
            let templateImage = image?.withRenderingMode(.alwaysTemplate)
            button.setImage(templateImage, for: .normal)
        }

        button.tintColor = .contrastTextColor
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .contrastTextColor
        label.text = "Sorting".localized
        return label
    }()

    let optionsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()

    var radioButtons = [CheckBox]()

}
