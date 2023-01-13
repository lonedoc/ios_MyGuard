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
        let description = device.description.isEmpty ?
            "Unknown sensor".localized :
            device.description

        descriptionLabel.text = description
        valueLabel.text = "\(device.temperature)°C"
    }

    private func setup() {
        backgroundColor = .clear

        setupViews()
        setupConstraints()

        isSkeletonable = true
    }

    private func setupViews() {
        cardView.addSubview(iconView)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(valueLabel)
        addSubview(cardView)
    }

    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cardView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 114).isActive = true

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 32).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16).isActive = true

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor).isActive = true
    }

    // MARK: - Views

    let cardView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(color: .cardBackground)
        return view
    }()

    let iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .center
        imageView.image = UIImage(image: .thermostatIcon)
        return imageView
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption3.font
        label.textColor = UIColor(color: .textSecondary)
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.paragraph.font
        label.textColor = UIColor(color: .textContrast)
        return label
    }()

}
