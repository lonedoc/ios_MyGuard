//
//  EventTableViewCell.swift
//  myprotection
//
//  Created by Rubeg NPO on 29.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import SkeletonView

class EventsTableViewCell: UITableViewCell {

    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return formatter
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(event: Event) {
        titleLabel.text = event.description
        descriptionLabel.text = event.zone

        if let timestamp = event.timestamp {
            timestampLabel.text = formatter.string(from: timestamp)
        } else {
            timestampLabel.text = ""
        }

        let icon = getEventIcon(event: event)
        iconView.image = icon
    }

    private func getEventIcon(event: Event) -> UIImage? {
        switch event.type {
        case 1, 2, 3, 77, 79, 85:
            return UIImage(image: .eventAlarmIcon)
        case 4: // fire alarm
            return UIImage(image: .eventOtherIcon)
        case 5:
            return UIImage(image: .eventMalfunctionIcon)
        case 6, 8, 9, 66, 67: // armed
            return UIImage(image: .eventOtherIcon)
        case 10, 69, 68: // disarmed
            return UIImage(image: .eventOtherIcon)
        case 33, 81: // battery
            return UIImage(image: .eventOtherIcon)
        default:
            return UIImage(image: .eventOtherIcon)
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
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(timestampLabel)

        contentView.addSubview(containerView)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 96).isActive = true

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 32).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true

        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        timestampLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        timestampLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: timestampLabel.topAnchor, constant: -4).isActive = true
    }

    // MARK: Views

    let containerView: UIView = {
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

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.paragraph.font
        label.textColor = UIColor(color: .textContrast)
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption3.font
        label.textColor = UIColor(color: .textSecondary)
        return label
    }()

    let timestampLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption3.font
        label.textColor = UIColor(color: .textSecondary)
        return label
    }()

}
