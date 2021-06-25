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

    var eventDescription: String {
        get { return descriptionLabel.text ?? "" }
        set { descriptionLabel.text = newValue }
    }

    var zone: String {
        get { return zoneLabel.text ?? "" }
        set { zoneLabel.text = newValue }
    }

    var timestamp: String {
        get { return timestampLabel.text ?? "" }
        set { timestampLabel.text = newValue }
    }

    var eventIcon: UIImage? {
        get { return iconView.image }
        set { iconView.image = newValue }
    }

    var eventColor: UIColor? {
        get { return iconView.backgroundColor }
        set { iconView.backgroundColor = newValue }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupViews()
        setupConstraints()

        selectionStyle = .none
        isSkeletonable = true
    }

    private func setupViews() {
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(zoneLabel)
        stackView.addArrangedSubview(timestampLabel)

        contentView.addSubview(iconView)
        contentView.addSubview(stackView)
    }

    private func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: iconView.topAnchor, constant: -8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        zoneLabel.translatesAutoresizingMaskIntoConstraints = false
        zoneLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    // MARK: Views

    let iconView: UIImageView = {
        let image = UIImage.assets(.notGuardedStatus)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.tintColor = .white
        imageView.backgroundColor = .green
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        
        imageView.isSkeletonable = true
        return imageView
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        stackView.isSkeletonable = true
        return stackView
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18)
        label.isSkeletonable = true
        return label
    }()

    let zoneLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(16)
        label.isSkeletonable = true
        return label
    }()

    let timestampLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(16)
        label.isSkeletonable = true
        return label
    }()

}
