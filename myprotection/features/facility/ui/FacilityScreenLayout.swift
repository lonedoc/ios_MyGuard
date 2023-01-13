//
//  ObjectView.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomAppBar
import MaterialComponents.MaterialProgressView

// swiftlint:disable:next type_body_length
class FacilityScreenLayout: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateStatus(statusCode: StatusCode) {
        statusImageView.image = getStatusIcon(statusCode: statusCode)
        statusLabel.textColor = getStatusTextColor(statusCode: statusCode)
    }

    private func getStatusIcon(statusCode: StatusCode) -> UIImage? {
        switch statusCode {
        case let status where status.isAlarm:
            return nil
        case let status where status.isNotGuarded:
            return UIImage(image: .notGuardedIconLight)
        case let status where status.isPerimeterOnlyGuarded:
            return UIImage(image: .perimeterGuardedIconLight)
        case let status where status.isGuarded:
            return UIImage(image: .guardedIconLight)
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
        backgroundColor = UIColor(color: .backgroundPrimary)

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        warningsStackView.addArrangedSubview(onlineChannelIcon)
        warningsStackView.addArrangedSubview(batteryMalfunctionIcon)
        warningsStackView.addArrangedSubview(powerSupplyMalfunctionIcon)
        actionsStackView.addArrangedSubview(alarmButton)
        actionsStackView.addArrangedSubview(cancelAlarmButton)
        actionsStackView.addArrangedSubview(armButton)
        actionsStackView.addArrangedSubview(disarmButton)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(statusLabel)
        wrapperView.addSubview(statusImageView)
        wrapperView.addSubview(warningsStackView)
        wrapperView.addSubview(actionsStackView)
        wrapperView.addSubview(tabs)
        wrapperView.addSubview(delimiter)
        wrapperView.addSubview(contentView)
        scrollView.addSubview(wrapperView)
        addSubview(scrollView)
    }

    // swiftlint:disable line_length
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        wrapperView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        wrapperView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        wrapperView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        wrapperView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16).isActive = true
        statusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16).isActive = true
        statusImageView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor).isActive = true
        statusImageView.widthAnchor.constraint(equalToConstant: 96).isActive = true
        statusImageView.heightAnchor.constraint(equalToConstant: 96).isActive = true

        warningsStackView.translatesAutoresizingMaskIntoConstraints = false
        warningsStackView.topAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: 16).isActive = true
        warningsStackView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor).isActive = true
        warningsStackView.heightAnchor.constraint(equalToConstant: 28).isActive = true

        [onlineChannelIcon, batteryMalfunctionIcon, powerSupplyMalfunctionIcon].forEach { iconView in
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.widthAnchor.constraint(equalToConstant: 28).isActive = true
            iconView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        }

        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        actionsStackView.topAnchor.constraint(equalTo: warningsStackView.bottomAnchor, constant: 16).isActive = true
        actionsStackView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16).isActive = true
        actionsStackView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16).isActive = true
        actionsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

        [alarmButton, cancelAlarmButton, armButton, disarmButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalTo: actionsStackView.widthAnchor).isActive = true
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }

        tabs.translatesAutoresizingMaskIntoConstraints = false
        tabs.topAnchor.constraint(equalTo: actionsStackView.bottomAnchor, constant: 12).isActive = true
        tabs.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        tabs.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
        tabs.widthAnchor.constraint(equalTo: wrapperView.widthAnchor).isActive = true
        tabs.heightAnchor.constraint(equalToConstant: 52).isActive = true

        delimiter.translatesAutoresizingMaskIntoConstraints = false
        delimiter.topAnchor.constraint(equalTo: tabs.bottomAnchor).isActive = true
        delimiter.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        delimiter.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
        delimiter.heightAnchor.constraint(equalToConstant: 1).isActive = true

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: delimiter.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
    }
    // swiftlint:enable line_length

    // MARK: - Views

    let testModeButton = UIBarButtonItem(
        image: UIImage(image: .testModeButtonIcon),
        style: .plain,
        target: nil,
        action: nil
    )

    let renameButton = UIBarButtonItem(
        image: UIImage(image: .renameButtonIcon),
        style: .plain,
        target: nil,
        action: nil
    )

    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        return view
    }()

    let wrapperView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.headline.font
        label.textColor = UIColor(color: .textContrast)
        label.textAlignment = .center
        return label
    }()

    let statusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption2.font
        label.textColor = UIColor(color: .accent)
        label.textAlignment = .center
        return label
    }()

    let statusImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let warningsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()

    let actionsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()

    let onlineChannelIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(image: .onlineChannelIcon)
        return imageView
    }()

    let batteryMalfunctionIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(image: .batteryMalfunctionIcon)
        return imageView
    }()

    let powerSupplyMalfunctionIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(image: .powerSupplyMalfunctionIcon)
        return imageView
    }()

    let alarmButton: UIButton = {
        let button = SolidButton()
        button.layer.cornerRadius = 16
        button.backgroundColorNormal = UIColor(color: .alarmButtonBackground)
        button.backgroundColorHighlighted = UIColor(color: .alarmButtonBackground).darker
        button.backgroundColorDisabled = UIColor(color: .alarmButtonBackground).darker
        button.setTitleColor(UIColor(color: .error), for: .normal)
        button.setTitle("Start an alarm".localized, for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        return button
    }()

    let cancelAlarmButton: UIButton = {
        let button = SolidButton()
        button.layer.cornerRadius = 16
        button.backgroundColorNormal = UIColor(color: .backgroundSurfaceVariant)
        button.backgroundColorHighlighted = UIColor(color: .backgroundSurfaceVariant).darker
        button.backgroundColorDisabled = UIColor(color: .backgroundSurfaceVariant).darker
        button.setTitleColor(UIColor(color: .error), for: .normal)
        button.setTitle("Cancel the alarm".localized, for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        return button
    }()

    let armButton: UIButton = {
        let button = SolidButton()
        button.layer.cornerRadius = 16
        button.backgroundColorNormal = UIColor(color: .armButtonBackground)
        button.backgroundColorHighlighted = UIColor(color: .armButtonBackground).darker
        button.backgroundColorDisabled = UIColor(color: .armButtonBackground).darker
        button.setTitleColor(UIColor(color: .accent), for: .normal)
        button.setTitle("Turn on security".localized, for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        return button
    }()

    let disarmButton: UIButton = {
        let button = SolidButton()
        button.layer.cornerRadius = 16
        button.backgroundColorNormal = UIColor(color: .backgroundSurfaceVariant)
        button.backgroundColorHighlighted = UIColor(color: .backgroundSurfaceVariant).darker
        button.backgroundColorDisabled = UIColor(color: .backgroundSurfaceVariant).darker
        button.setTitleColor(UIColor(color: .accent), for: .normal)
        button.setTitle("Turn off security".localized, for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        return button
    }()

    let tabs: MenuTabsView = {
        let tabsView = MenuTabsView(frame: .zero)
        tabsView.isUserInteractionEnabled = true
        return tabsView
    }()

    var delimiter: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(color: .tabMenuDelimiter)
        return view
    }()

    let contentView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

}
