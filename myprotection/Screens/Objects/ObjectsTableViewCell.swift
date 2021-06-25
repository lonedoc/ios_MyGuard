//
//  ObjectsTableViewCell.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import SkeletonView

class ObjectsTableViewCell: UITableViewCell {

    var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }

    var address: String {
        get { return addressLabel.text ?? "" }
        set { addressLabel.text = newValue }
    }

    var status: String {
        get { return statusLabel.text ?? "" }
        set { statusLabel.text = newValue }
    }

    var statusIcon: UIImage? {
        get { return iconView.image }
        set { iconView.image = newValue }
    }

    var statusColor: UIColor? {
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
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(statusLabel)

        contentView.addSubview(iconView)
        contentView.addSubview(stackView)
    }

    private func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        iconView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: iconView.bottomAnchor).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }

    // MARK: Views

    let iconView: UIImageView = {
        let image = UIImage.assets(.notGuardedStatus)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.tintColor = .white
        imageView.backgroundColor = .green
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.isSkeletonable = true
        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(20)
        label.isSkeletonable = true
        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(16)
        label.isSkeletonable = true
        return label
    }()

    let statusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = label.font.withSize(16)
        label.isSkeletonable = true
        return label
    }()

}
