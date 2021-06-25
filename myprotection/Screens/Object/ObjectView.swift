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

class ObjectView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var armButtonIcon: UIImage? {
        get { armButton.imageView?.image }
        set {
            armButton.setImage(newValue, for: .normal)
            armButton.tintColor = .white
        }
    }

    var armButtonColor: UIColor? {
        get { armButton.backgroundColor }
        set { armButton.backgroundColor = newValue }
    }

    func setArmButtonIcon(by status: StatusCode) {
        switch status {
        case .alarm:
            armButton.backgroundColor = .errorColor

            if let image = UIImage.assets(.dotOutlined) {
                let colorlessImage = image.withRenderingMode(.alwaysTemplate)
                armButton.setImage(colorlessImage, for: .normal)
                armButton.tintColor = .white
            }
        default:
            armButton.backgroundColor = .primaryColor
            if let image = UIImage.assets(.dotSolid) {
                let colorlessImage = image.withRenderingMode(.alwaysTemplate)
                armButton.setImage(colorlessImage, for: .normal)
                armButton.tintColor = .white
            }
        }
    }

    private func setup() {
        backgroundColor = .white

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = .white

        linkIconWrapper.addSubview(linkIcon)

        topView.addSubview(backgroundView)
        topView.addSubview(statusDescriptionView)
        topView.addSubview(addressView)
        topView.addSubview(armButton)
        topView.addSubview(linkIconWrapper)
        topView.addSubview(armingProgressView)
        topView.addSubview(armingProgressText)

        bottomAppBar.trailingBarButtonItems = [testAlarmButton]

        addSubview(topView)
        addSubview(bottomView)
        addSubview(bottomAppBar)
    }

    private func setupConstraints() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true

        armingProgressView.translatesAutoresizingMaskIntoConstraints = false
        armingProgressView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        armingProgressView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        armingProgressView.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
        armingProgressView.heightAnchor.constraint(equalToConstant: 2).isActive = true

        armingProgressText.translatesAutoresizingMaskIntoConstraints = false
        armingProgressText.topAnchor.constraint(equalTo: armingProgressView.bottomAnchor, constant: 8).isActive = true
        armingProgressText.centerXAnchor.constraint(equalTo: armingProgressView.centerXAnchor).isActive = true

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: topView.widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: topView.heightAnchor).isActive = true

        addressView.translatesAutoresizingMaskIntoConstraints = false
        addressView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        addressView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -8).isActive = true

        statusDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        statusDescriptionView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        statusDescriptionView.bottomAnchor.constraint(equalTo: addressView.topAnchor, constant: -16).isActive = true

        armButton.translatesAutoresizingMaskIntoConstraints = false
        armButton.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        armButton.bottomAnchor.constraint(equalTo: statusDescriptionView.topAnchor, constant: -16).isActive = true
        armButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        armButton.heightAnchor.constraint(equalToConstant: 80).isActive = true

        let side = 40.0
        let shift = side - sqrt(side * side / 2)

        linkIconWrapper.translatesAutoresizingMaskIntoConstraints = false
        linkIconWrapper.centerXAnchor.constraint(equalTo: armButton.trailingAnchor, constant: CGFloat(-shift)).isActive = true
        linkIconWrapper.centerYAnchor.constraint(equalTo: armButton.topAnchor, constant: CGFloat(shift)).isActive = true
        linkIconWrapper.widthAnchor.constraint(equalToConstant: 24).isActive = true
        linkIconWrapper.heightAnchor.constraint(equalToConstant: 24).isActive = true

        linkIcon.translatesAutoresizingMaskIntoConstraints = false
        linkIcon.centerXAnchor.constraint(equalTo: linkIconWrapper.centerXAnchor).isActive = true
        linkIcon.centerYAnchor.constraint(equalTo: linkIconWrapper.centerYAnchor).isActive = true
        linkIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        linkIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true

        bottomAppBar.translatesAutoresizingMaskIntoConstraints = false
        bottomAppBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomAppBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomAppBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true

        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    // MARK: - Views

    let topView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    let backgroundView: UIView = {
        let image = UIImage.assets(.background)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFill
        return view
    }()

    let armingProgressView: MDCProgressView = {
        let progressView = MDCProgressView()
        progressView.mode = .indeterminate
        progressView.alpha = 0
        return progressView
    }()

    let armingProgressText: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.5)
        label.alpha = 0
        return label
    }()

    let statusDescriptionView: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()

    let addressView: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()

    let armButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 40
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.backgroundColor = .red

        if let image = UIImage.assets(.dotSolid) {
            let colorlessImage = image.withRenderingMode(.alwaysTemplate)
            button.setImage(colorlessImage, for: .normal)
            button.tintColor = .white
        }

        return button
    }()

    let linkIconWrapper: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 12
        view.backgroundColor = .black
        view.tintColor = .white
        return view
    }()

    let linkIcon: UIImageView = {
        let image = UIImage.assets(.linkOff)
        let imageView = UIImageView(image: image)
        return imageView
    }()

    let bottomView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()

    let editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage.assets(.edit),
            style: .plain,
            target: nil,
            action: nil
        )
        return button
    }()

    let testAlarmButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage.assets(.checkAlarm)
        button.tintColor = .white
        return button
    }()

    let bottomAppBar: MaterialComponents.MDCBottomAppBarView = {
        let appBar = MDCBottomAppBarView(frame: .zero)
        appBar.barTintColor = .darkBackgroundColor
        appBar.tintColor = .white
        appBar.floatingButton.setImage(UIImage.assets(.alarm), for: .normal)
        appBar.floatingButton.setBackgroundColor(.errorColor, for: .normal)
        appBar.floatingButton.setBackgroundColor(.gray, for: .disabled)
        appBar.floatingButton.setImageTintColor(.white, for: .normal)
        appBar.floatingButton.setImageTintColor(.white, for: .disabled)
        appBar.floatingButton.disabledAlpha = 1
        return appBar
    }()

}
