//
//  AccountScreenLayout.swift
//  myprotection
//
//  Created by Rubeg NPO on 11.01.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

class AccountScreenLayout: UIView {

    var accountLabelLeftMarginConstraint: NSLayoutConstraint?
    var accountLabelRightMarginConstraint: NSLayoutConstraint?
    var accountLabelLeftPaddingConstraint: NSLayoutConstraint?
    var accountLabelRightPaddingConstraint: NSLayoutConstraint?
    var amountLabelLeftMarginConstraint: NSLayoutConstraint?
    var amountLabelRightMarginConstraint: NSLayoutConstraint?
    var amountLabelLeftPaddingConstraint: NSLayoutConstraint?
    var amountLabelRightPaddingConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        updateAppearance()
        super.layoutSubviews()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateAppearance()
    }

    private func setup() {
        backgroundColor = UIColor(color: .backgroundPrimary)

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        accountLabelBackgroundView.addSubview(accountLabel)
        amountLabelBackgroundView.addSubview(amountLabel)
        wrapperView.addSubview(accountLabelBackgroundView)
        wrapperView.addSubview(accountTextField)
        wrapperView.addSubview(accountTextFieldBorderView)
        wrapperView.addSubview(amountLabelBackgroundView)
        wrapperView.addSubview(amountTextField)
        wrapperView.addSubview(amountTextFieldBorderView)
        wrapperView.addSubview(submitButton)
        scrollView.addSubview(wrapperView)
        addSubview(scrollView)

        toolbar.setItems(
            [prevButtonItem, gap, nextButtonItem, spacer, doneButtonItem],
            animated: false
        )

        accountTextField.inputView = accountPicker
        accountTextField.inputAccessoryView = toolbar
        amountTextField.inputAccessoryView = toolbar
    }

    // swiftlint:disable line_length
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        wrapperView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        wrapperView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        wrapperView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        accountLabelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        accountLabelBackgroundView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 16).isActive = true
        accountLabelBackgroundView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        accountLabelLeftMarginConstraint = accountLabelBackgroundView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16)
        accountLabelRightMarginConstraint = accountLabelBackgroundView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16)
        NSLayoutConstraint.activate([accountLabelLeftMarginConstraint!, accountLabelRightMarginConstraint!])

        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.centerYAnchor.constraint(equalTo: accountLabelBackgroundView.centerYAnchor).isActive = true
        accountLabelLeftPaddingConstraint = accountLabel.leadingAnchor.constraint(equalTo: accountLabelBackgroundView.leadingAnchor, constant: 12)
        accountLabelRightPaddingConstraint = accountLabel.trailingAnchor.constraint(equalTo: accountLabelBackgroundView.trailingAnchor, constant: -12)
        NSLayoutConstraint.activate([accountLabelLeftPaddingConstraint!, accountLabelRightPaddingConstraint!])

        accountTextField.translatesAutoresizingMaskIntoConstraints = false
        accountTextField.topAnchor.constraint(equalTo: accountLabelBackgroundView.bottomAnchor, constant: 6).isActive = true
        accountTextField.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16).isActive = true
        accountTextField.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16).isActive = true
        accountTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        accountTextFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        accountTextFieldBorderView.leadingAnchor.constraint(equalTo: accountTextField.leadingAnchor).isActive = true
        accountTextFieldBorderView.trailingAnchor.constraint(equalTo: accountTextField.trailingAnchor).isActive = true
        accountTextFieldBorderView.bottomAnchor.constraint(equalTo: accountTextField.bottomAnchor, constant: 1).isActive = true
        accountTextFieldBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        amountLabelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        amountLabelBackgroundView.topAnchor.constraint(equalTo: accountTextFieldBorderView.topAnchor, constant: 16).isActive = true
        amountLabelBackgroundView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        amountLabelLeftMarginConstraint = amountLabelBackgroundView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16)
        amountLabelRightMarginConstraint = amountLabelBackgroundView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16)
        NSLayoutConstraint.activate([amountLabelLeftMarginConstraint!, amountLabelRightMarginConstraint!])

        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.centerYAnchor.constraint(equalTo: amountLabelBackgroundView.centerYAnchor).isActive = true
        amountLabelLeftPaddingConstraint = amountLabel.leadingAnchor.constraint(equalTo: amountLabelBackgroundView.leadingAnchor, constant: 12)
        amountLabelRightPaddingConstraint = amountLabel.trailingAnchor.constraint(equalTo: amountLabelBackgroundView.trailingAnchor, constant: -12)
        NSLayoutConstraint.activate([amountLabelLeftPaddingConstraint!, amountLabelRightPaddingConstraint!])

        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.topAnchor.constraint(equalTo: amountLabelBackgroundView.bottomAnchor, constant: 6).isActive = true
        amountTextField.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16).isActive = true
        amountTextField.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16).isActive = true
        amountTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        amountTextFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        amountTextFieldBorderView.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor).isActive = true
        amountTextFieldBorderView.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor).isActive = true
        amountTextFieldBorderView.bottomAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 1).isActive = true
        amountTextFieldBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: amountTextFieldBorderView.bottomAnchor, constant: 56).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -32).isActive = true
    }

    private func updateAppearance() {
        if #available(iOS 12.0, *) {
            applyAppearance(dark: traitCollection.userInterfaceStyle == .dark)
        } else {
            applyAppearance(dark: false)
        }
    }

    private func applyAppearance(dark: Bool) {
        let labelsCornerRadius = dark ? 0.0 : 8
        let labelsMargin = dark ? 0.0 : 16.0
        let labelsPadding = dark ? 16.0 : 12.0
        let textFieldsPadding = dark ? 0.0 : 16.0

        accountLabelBackgroundView.layer.cornerRadius = labelsCornerRadius
        accountLabelLeftMarginConstraint?.constant = labelsMargin
        accountLabelRightMarginConstraint?.constant = labelsMargin * -1
        accountLabelLeftPaddingConstraint?.constant = labelsPadding
        accountLabelRightPaddingConstraint?.constant = labelsPadding * -1

        amountLabelBackgroundView.layer.cornerRadius = labelsCornerRadius
        amountLabelLeftMarginConstraint?.constant = labelsMargin
        amountLabelRightMarginConstraint?.constant = labelsMargin * -1
        amountLabelLeftPaddingConstraint?.constant = labelsPadding
        amountLabelRightPaddingConstraint?.constant = labelsPadding * -1

        accountTextField.setLeftPadding(textFieldsPadding)
        amountTextField.setLeftPadding(textFieldsPadding)

        if let imageView = (accountTextField.subviews.first { subview in subview is UIImageView }) {
            // Reset constraints
            imageView.removeFromSuperview()
            accountTextField.addSubview(imageView)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            imageView.centerYAnchor.constraint(equalTo: accountTextField.centerYAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: accountTextField.trailingAnchor, constant: textFieldsPadding * -1).isActive = true
        }

        layoutIfNeeded()
    }
    // swiftlint:enable line_length

    // MARK: - Views

    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        return view
    }()

    let wrapperView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    let accountLabelBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(color: .backgroundSurfaceVariant)
        view.layer.cornerRadius = 8
        return view
    }()

    let accountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption2.font
        label.textColor = UIColor(color: .textContrast)
        label.text = "Account".localized + ":"
        return label
    }()

    let accountTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor(color: .backgroundSurface)
        textField.layer.cornerRadius = 12
        textField.font = TextStyle.paragraph.font
        textField.textColor = UIColor(color: .textPrimary)

        let placeholderText = "Account".localized
        let placeholderColor = UIColor(color: .textSecondary)
        let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        let placeholder = NSAttributedString(string: placeholderText, attributes: attributes)

        textField.attributedPlaceholder = placeholder

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        imageView.image = UIImage(image: .dropdownIcon)
        imageView.contentMode = .scaleAspectFit

        textField.addSubview(imageView)

        return textField
    }()

    let accountTextFieldBorderView: UIView = {
        var bottomLine = UIView(frame: .zero)
        bottomLine.backgroundColor = UIColor(color: .darkAppearanceBorder)
        return bottomLine
    }()

    let amountLabelBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(color: .backgroundSurfaceVariant)
        view.layer.cornerRadius = 8
        return view
    }()

    let amountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption2.font
        label.textColor = UIColor(color: .textContrast)
        label.text = "Amount".localized + ":"
        return label
    }()

    let amountTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor(color: .backgroundSurface)
        textField.layer.cornerRadius = 12
        textField.setLeftPadding(16)
        textField.font = TextStyle.paragraph.font
        textField.textColor = UIColor(color: .textPrimary)
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad

        let placeholderText = "Amount".localized
        let placeholderColor = UIColor(color: .textSecondary)
        let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        let placeholder = NSAttributedString(string: placeholderText, attributes: attributes)

        textField.attributedPlaceholder = placeholder

        return textField
    }()

    let amountTextFieldBorderView: UIView = {
        var bottomLine = UIView(frame: .zero)
        bottomLine.backgroundColor = UIColor(color: .darkAppearanceBorder)
        return bottomLine
    }()

    let submitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 16
        button.setBackgroundColor(UIColor(color: .accent), for: .normal)
        button.setBackgroundColor(UIColor(color: .accentPale), for: .disabled)
        button.setTitleColor(UIColor(color: .textOnAccent), for: .normal)
        button.setTitleColor(UIColor(color: .textOnAccent), for: .disabled)
        button.titleLabel?.font = TextStyle.paragraph.font
        button.setTitle("Pay".localized, for: .normal)
        button.isEnabled = false
        return button
    }()

    let accountPicker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        return picker
    }()

    let prevButtonItem: UIBarButtonItem = {
        let image = UIImage.assets(.leftArrow)
        let item = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        return item
    }()

    let nextButtonItem: UIBarButtonItem = {
        let image = UIImage.assets(.rightArrow)
        let item = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        return item
    }()

    let doneButtonItem: UIBarButtonItem = {
        let titleText = "Done".localized
        let item = UIBarButtonItem(title: titleText, style: .done, target: nil, action: nil)
        return item
    }()

    let spacer: UIBarButtonItem = {
        let item = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        return item
    }()

    let gap: UIBarButtonItem = {
        let item = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: nil,
            action: nil
        )
        item.width = 16
        return item
    }()

    let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.tintColor = UIColor(color: .accent)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        return toolbar
    }()

}
