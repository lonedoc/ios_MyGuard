//
//  SensorsViewCell.swift
//  myprotection
//
//  Created by Rubeg NPO on 02.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import SkeletonView

class SensorsCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        cardView.addSubview(titleLabel)
        cardView.addSubview(iconView)
        cardView.addSubview(valueLabel)

        addSubview(cardView)
    }

    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cardView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -16).isActive = true

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        iconView.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 16).isActive = true
        iconView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.topAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 16).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -16).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: iconView.bottomAnchor).isActive = true
    }

    // MARK: - Views

    let cardView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4
        return view
    }()

    let iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.isSkeletonable = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.isSkeletonable = true
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.isSkeletonable = true
        return label
    }()

}
