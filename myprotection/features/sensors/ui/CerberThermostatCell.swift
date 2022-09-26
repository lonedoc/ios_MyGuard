//
//  SensorsViewCell.swift
//  myprotection
//
//  Created by Rubeg NPO on 02.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

class CerberThermostatCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ device: CerberThermostat) {
        let onlineIconBackgroundColor: UIColor = device.isOnline ? .secondaryColor : .errorColor
        let onlineIcon = device.isOnline ? UIImage.assets(.link) : UIImage.assets(.linkOff)

        self.isOnlineIconWrapper.backgroundColor = onlineIconBackgroundColor
        self.isOnlineIcon.image = onlineIcon
        self.valueLabel.text = "\(device.temperature)°C"
        self.titleLabel.text = device.description
    }

    private func setup() {
        backgroundColor = .screenBackgroundColor

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        cardView.addSubview(isOnlineIconWrapper)
        cardView.addSubview(isOnlineIcon)
        cardView.addSubview(iconView)
        cardView.addSubview(valueLabel)
        cardView.addSubview(titleLabel)
        addSubview(cardView)
    }

    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cardView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 128).isActive = true

        isOnlineIconWrapper.translatesAutoresizingMaskIntoConstraints = false
        isOnlineIconWrapper.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        isOnlineIconWrapper.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true
        isOnlineIconWrapper.widthAnchor.constraint(equalToConstant: 24).isActive = true
        isOnlineIconWrapper.heightAnchor.constraint(equalToConstant: 24).isActive = true

        isOnlineIcon.translatesAutoresizingMaskIntoConstraints = false
        isOnlineIcon.centerXAnchor.constraint(equalTo: isOnlineIconWrapper.centerXAnchor).isActive = true
        isOnlineIcon.centerYAnchor.constraint(equalTo: isOnlineIconWrapper.centerYAnchor).isActive = true
        isOnlineIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        isOnlineIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: isOnlineIconWrapper.bottomAnchor).isActive = true
        iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor).isActive = true
        iconView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8).isActive = true

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.topAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: iconView.bottomAnchor).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true
    }

    // MARK: - Views

    let cardView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .surfaceBackgroundColor
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        return view
    }()

    let isOnlineIconWrapper: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 12
        view.backgroundColor = .secondaryColor
        view.tintColor = .white
        return view
    }()

    let isOnlineIcon: UIImageView = {
        let image = UIImage.assets(.link)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        return imageView
    }()

    let iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage.assets(.temperatureIcon)
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .surfaceForegroundColor
        label.backgroundColor = .red
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .surfaceForegroundColor
        return label
    }()

}
