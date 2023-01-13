//
//  ApplicationsScreenLayout.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.05.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

class ApplicationsScreenLayout: UIView {

    var applicationsLabelLeftMarginConstraint: NSLayoutConstraint?
    var applicationsLabelRightMarginConstraint: NSLayoutConstraint?
    var applicationsLabelLeftPaddingConstraint: NSLayoutConstraint?
    var applicationsLabelRightPaddingConstraint: NSLayoutConstraint?
    var applicationLabelLeftMarginConstraint: NSLayoutConstraint?
    var applicationLabelRightMarginConstraint: NSLayoutConstraint?
    var applicationLabelLeftPaddingConstraint: NSLayoutConstraint?
    var applicationLabelRightPaddingConstraint: NSLayoutConstraint?
    var dateTimeLabelLeftMarginConstraint: NSLayoutConstraint?
    var dateTimeLabelRightMarginConstraint: NSLayoutConstraint?
    var dateTimeLabelLeftPaddingConstraint: NSLayoutConstraint?
    var dateTimeLabelRightPaddingConstraint: NSLayoutConstraint?

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
        applicationsLabelBackgroundView.addSubview(applicationsLabel)
        applicationLabelBackgroundView.addSubview(applicationLabel)
        dateTimeLabelBackgroundView.addSubview(dateTimeLabel)
        wrapperView.addSubview(applicationsLabelBackgroundView)
        wrapperView.addSubview(applicationsTextField)
        wrapperView.addSubview(applicationsTextFieldBorderView)
        wrapperView.addSubview(applicationLabelBackgroundView)
        wrapperView.addSubview(applicationTextField)
        wrapperView.addSubview(applicationTextFieldBorderView)
        wrapperView.addSubview(dateTimeLabelBackgroundView)
        wrapperView.addSubview(dateTimeTextField)
        wrapperView.addSubview(dateTimeTextFieldBorderView)
        wrapperView.addSubview(submitButton)
        scrollView.addSubview(wrapperView)
        addSubview(scrollView)

        toolbar.setItems(
            [prevButtonItem, gap, nextButtonItem, spacer, doneButtonItem],
            animated: false
        )

        applicationsTextField.inputView = applicationPicker
        applicationsTextField.inputAccessoryView = toolbar

        applicationTextField.inputAccessoryView = toolbar

        dateTimeTextField.inputView = datePicker
        dateTimeTextField.inputAccessoryView = toolbar
    }

    // swiftlint:disable line_length
    // swiftlint:disable:next function_body_length
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

        applicationsLabelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        applicationsLabelBackgroundView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 16).isActive = true
        applicationsLabelBackgroundView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        applicationsLabelLeftMarginConstraint = applicationsLabelBackgroundView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16)
        applicationsLabelRightMarginConstraint = applicationsLabelBackgroundView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16)
        NSLayoutConstraint.activate([applicationsLabelLeftMarginConstraint!, applicationsLabelRightMarginConstraint!])

        applicationsLabel.translatesAutoresizingMaskIntoConstraints = false
        applicationsLabel.centerYAnchor.constraint(equalTo: applicationsLabelBackgroundView.centerYAnchor).isActive = true
        applicationsLabelLeftPaddingConstraint = applicationsLabel.leadingAnchor.constraint(equalTo: applicationsLabelBackgroundView.leadingAnchor, constant: 12)
        applicationsLabelRightPaddingConstraint = applicationsLabel.trailingAnchor.constraint(equalTo: applicationsLabelBackgroundView.trailingAnchor, constant: -12)
        NSLayoutConstraint.activate([applicationsLabelLeftPaddingConstraint!, applicationsLabelRightPaddingConstraint!])

        applicationsTextField.translatesAutoresizingMaskIntoConstraints = false
        applicationsTextField.topAnchor.constraint(equalTo: applicationsLabelBackgroundView.bottomAnchor, constant: 6).isActive = true
        applicationsTextField.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16).isActive = true
        applicationsTextField.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16).isActive = true
        applicationsTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        applicationsTextFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        applicationsTextFieldBorderView.leadingAnchor.constraint(equalTo: applicationsTextField.leadingAnchor).isActive = true
        applicationsTextFieldBorderView.trailingAnchor.constraint(equalTo: applicationsTextField.trailingAnchor).isActive = true
        applicationsTextFieldBorderView.bottomAnchor.constraint(equalTo: applicationsTextField.bottomAnchor, constant: 1).isActive = true
        applicationsTextFieldBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        applicationLabelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        applicationLabelBackgroundView.topAnchor.constraint(equalTo: applicationsTextFieldBorderView.bottomAnchor, constant: 16).isActive = true
        applicationLabelBackgroundView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        applicationLabelLeftMarginConstraint = applicationLabelBackgroundView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16)
        applicationLabelRightMarginConstraint = applicationLabelBackgroundView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16)
        NSLayoutConstraint.activate([applicationLabelLeftMarginConstraint!, applicationLabelRightMarginConstraint!])

        applicationLabel.translatesAutoresizingMaskIntoConstraints = false
        applicationLabel.centerYAnchor.constraint(equalTo: applicationLabelBackgroundView.centerYAnchor).isActive = true
        applicationLabelLeftPaddingConstraint = applicationLabel.leadingAnchor.constraint(equalTo: applicationLabelBackgroundView.leadingAnchor, constant: 12)
        applicationLabelRightPaddingConstraint = applicationLabel.trailingAnchor.constraint(equalTo: applicationLabelBackgroundView.trailingAnchor, constant: -12)
        NSLayoutConstraint.activate([applicationLabelLeftPaddingConstraint!, applicationLabelRightPaddingConstraint!])

        applicationTextField.translatesAutoresizingMaskIntoConstraints = false
        applicationTextField.topAnchor.constraint(equalTo: applicationsTextFieldBorderView.topAnchor, constant: 50).isActive = true
        applicationTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        applicationTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        applicationTextField.heightAnchor.constraint(equalToConstant: 128).isActive = true

        applicationTextFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        applicationTextFieldBorderView.leadingAnchor.constraint(equalTo: applicationTextField.leadingAnchor).isActive = true
        applicationTextFieldBorderView.trailingAnchor.constraint(equalTo: applicationTextField.trailingAnchor).isActive = true
        applicationTextFieldBorderView.bottomAnchor.constraint(equalTo: applicationTextField.bottomAnchor, constant: 1).isActive = true
        applicationTextFieldBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        dateTimeLabelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        dateTimeLabelBackgroundView.topAnchor.constraint(equalTo: applicationTextFieldBorderView.bottomAnchor, constant: 16).isActive = true
        dateTimeLabelBackgroundView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        dateTimeLabelLeftMarginConstraint = dateTimeLabelBackgroundView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16)
        dateTimeLabelRightMarginConstraint = dateTimeLabelBackgroundView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16)
        NSLayoutConstraint.activate([dateTimeLabelLeftMarginConstraint!, dateTimeLabelRightMarginConstraint!])

        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTimeLabel.centerYAnchor.constraint(equalTo: dateTimeLabelBackgroundView.centerYAnchor).isActive = true
        dateTimeLabelLeftPaddingConstraint = dateTimeLabel.leadingAnchor.constraint(equalTo: dateTimeLabelBackgroundView.leadingAnchor, constant: 12)
        dateTimeLabelRightPaddingConstraint = dateTimeLabel.trailingAnchor.constraint(equalTo: dateTimeLabelBackgroundView.trailingAnchor, constant: -12)
        NSLayoutConstraint.activate([dateTimeLabelLeftPaddingConstraint!, dateTimeLabelRightPaddingConstraint!])

        dateTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTimeTextField.topAnchor.constraint(equalTo: dateTimeLabelBackgroundView.bottomAnchor, constant: 6).isActive = true
        dateTimeTextField.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16).isActive = true
        dateTimeTextField.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -16).isActive = true
        dateTimeTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        dateTimeTextFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        dateTimeTextFieldBorderView.leadingAnchor.constraint(equalTo: dateTimeTextField.leadingAnchor).isActive = true
        dateTimeTextFieldBorderView.trailingAnchor.constraint(equalTo: dateTimeTextField.trailingAnchor).isActive = true
        dateTimeTextFieldBorderView.bottomAnchor.constraint(equalTo: dateTimeTextField.bottomAnchor, constant: 1).isActive = true
        dateTimeTextFieldBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: dateTimeTextFieldBorderView.bottomAnchor, constant: 56).isActive = true
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

        applicationsLabelBackgroundView.layer.cornerRadius = labelsCornerRadius
        applicationsLabelLeftMarginConstraint?.constant = labelsMargin
        applicationsLabelRightMarginConstraint?.constant = labelsMargin * -1
        applicationsLabelLeftPaddingConstraint?.constant = labelsPadding
        applicationsLabelRightPaddingConstraint?.constant = labelsPadding * -1

        applicationLabelBackgroundView.layer.cornerRadius = labelsCornerRadius
        applicationLabelLeftMarginConstraint?.constant = labelsMargin
        applicationLabelRightMarginConstraint?.constant = labelsMargin * -1
        applicationLabelLeftPaddingConstraint?.constant = labelsPadding
        applicationLabelRightPaddingConstraint?.constant = labelsPadding * -1

        dateTimeLabelBackgroundView.layer.cornerRadius = labelsCornerRadius
        dateTimeLabelLeftMarginConstraint?.constant = labelsMargin
        dateTimeLabelRightMarginConstraint?.constant = labelsMargin * -1
        dateTimeLabelLeftPaddingConstraint?.constant = labelsPadding
        dateTimeLabelRightPaddingConstraint?.constant = labelsPadding * -1

        applicationsTextField.setLeftPadding(textFieldsPadding)
        dateTimeTextField.setLeftPadding(textFieldsPadding)

        [applicationsTextField, dateTimeTextField].forEach { textField in
            if let imageView = (textField.subviews.first { subview in subview is UIImageView }) {
                // Reset constraints
                imageView.removeFromSuperview()
                textField.addSubview(imageView)

                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
                imageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
                imageView.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: textFieldsPadding * -1).isActive = true
            }
        }

        applicationTextField.textContainerInset = UIEdgeInsets(top: 16, left: textFieldsPadding, bottom: 16, right: textFieldsPadding)

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

    let applicationsLabelBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(color: .backgroundSurfaceVariant)
        view.layer.cornerRadius = 8
        return view
    }()

    let applicationsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption2.font
        label.textColor = UIColor(color: .textContrast)
        label.text = "Application".localized + ":"
        return label
    }()

    let applicationsTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor(color: .backgroundSurface)
        textField.layer.cornerRadius = 12
        textField.font = TextStyle.paragraph.font
        textField.textColor = UIColor(color: .textPrimary)

        let placeholderText = "Application".localized
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

    let applicationsTextFieldBorderView: UIView = {
        var bottomLine = UIView(frame: .zero)
        bottomLine.backgroundColor = UIColor(color: .darkAppearanceBorder)
        return bottomLine
    }()

    let applicationLabelBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(color: .backgroundSurfaceVariant)
        view.layer.cornerRadius = 8
        return view
    }()

    let applicationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption2.font
        label.textColor = UIColor(color: .textContrast)
        label.text = "Custom application".localized + ":"
        return label
    }()

    let applicationTextField: UITextView = {
        let textField = UITextView(frame: .zero)
        textField.backgroundColor = UIColor(color: .backgroundSurface)
        textField.layer.cornerRadius = 12
        textField.font = TextStyle.paragraph.font
        textField.textColor = UIColor(color: .textPrimary)
        textField.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return textField
    }()

    let applicationTextFieldBorderView: UIView = {
        var bottomLine = UIView(frame: .zero)
        bottomLine.backgroundColor = UIColor(color: .darkAppearanceBorder)
        return bottomLine
    }()

    let dateTimeLabelBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(color: .backgroundSurfaceVariant)
        view.layer.cornerRadius = 8
        return view
    }()

    let dateTimeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption2.font
        label.textColor = UIColor(color: .textContrast)
        label.text = "Date and time".localized + ":"
        return label
    }()

    let dateTimeTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor(color: .backgroundSurface)
        textField.layer.cornerRadius = 12
        textField.font = TextStyle.paragraph.font
        textField.textColor = UIColor(color: .textPrimary)

        let placeholderText = "Date and time".localized
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

    let dateTimeTextFieldBorderView: UIView = {
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
        button.setTitle("Submit".localized, for: .normal)
        button.isEnabled = false
        return button
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

    let applicationPicker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        return picker
    }()

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.datePickerMode = .dateAndTime

        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }

        picker.minimumDate = Date()

        return picker
    }()

}
