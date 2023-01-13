//
//  ObjectsTableViewCell.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import SkeletonView

class FacilitiesTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(facility: Facility) {
        titleLabel.text = facility.name
        addressLabel.text = facility.address
        statusLabel.text = facility.status
        updateStatus(facility.statusCode)
    }

    private func updateStatus(_ statusCode: StatusCode) {
        iconView.image = getStatusIcon(statusCode: statusCode)
        statusLabel.textColor = getStatusTextColor(statusCode: statusCode)
    }

    private func getStatusIcon(statusCode: StatusCode) -> UIImage? {
        switch statusCode {
        case let status where status.isAlarm:
            return nil // TODO
        case let status where status.isNotGuarded:
            return UIImage(image: .notGuardedStatusIcon)
        case let status where status.isPerimeterOnlyGuarded:
            return UIImage(image: .perimeterGuardedStatusIcon)
        case let status where status.isGuarded:
            return UIImage(image: .guardedStatusIcon)
        default:
            return nil
        }
    }

    private func getStatusTextColor(statusCode: StatusCode) -> UIColor {
        switch statusCode {
        case let status where status.isAlarm:
            return UIColor(color: .error)
        case let status where status.isNotGuarded:
            return UIColor(color: .textSecondary)
        case let status where status.isGuarded || status.isPerimeterOnlyGuarded:
            return UIColor(color: .accent)
        default:
            return UIColor(color: .textSecondary)
        }
    }

    private func setup() {
        backgroundColor = .clear

        setupViews()
        setupConstraints()

        selectionStyle = .none
        isSkeletonable = true
    }

    private func setupViews() {
        cardView.addSubview(iconView)
        cardView.addSubview(statusLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(addressLabel)
        cardView.addSubview(chevronIconView)

        contentView.addSubview(cardView)
    }

    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 32).isActive = true

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true

        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16).isActive = true

        chevronIconView.translatesAutoresizingMaskIntoConstraints = false
        chevronIconView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        chevronIconView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true
        chevronIconView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        chevronIconView.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }

    // MARK: Views

    let cardView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(color: .cardBackground)
        return view
    }()

    let iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .center
        imageView.isSkeletonable = true
        return imageView
    }()

    let statusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption2.font
        label.textColor = UIColor(color: .accent)
        label.isSkeletonable = true
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.paragraph.font
        label.textColor = UIColor(color: .textContrast)
        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption2.font
        label.textColor = UIColor(color: .textSecondary)
        return label
    }()

    let chevronIconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .center
        imageView.image = UIImage(image: .chevronRightIcon)
        return imageView
    }()

}
