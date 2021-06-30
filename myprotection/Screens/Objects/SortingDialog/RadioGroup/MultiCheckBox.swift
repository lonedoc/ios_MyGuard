//
//  MultiCheckBox.swift
//  myprotection
//
//  Created by Rubeg NPO on 23.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

enum CheckBoxVariant {
    case main, alternative
}

class MultiCheckBox: UIView, CheckBox {

    private var subtitles = [CheckBoxVariant: String]()
    private var images = [CheckBoxVariant: UIImage?]()
    private var valuesByVariant = [CheckBoxVariant: Int]()
    private var variantsByValue = [Int: CheckBoxVariant]()

    private(set) var selectedVariant: CheckBoxVariant = .main {
        didSet {
            updateView()
            delegate?.stateChanged(sender: self)
        }
    }

    var isSelected: Bool = false {
        didSet {
            updateView()
            delegate?.stateChanged(sender: self)
        }
    }

    var values: [Int] {
        return Array(valuesByVariant.values)
    }

    var value: Int {
        return valuesByVariant[selectedVariant] ?? 0
    }

    var mainColor: UIColor? {
        didSet {
            updateView()
        }
    }

    var minorColor: UIColor? {
        didSet {
            updateView()
        }
    }

    override var tintColor: UIColor? {
        didSet {
            updateView()
        }
    }

    var title: String? {
        get { return titleView.text }
        set { titleView.text = newValue }
    }

    var delegate: CheckBoxDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSubtitle(_ subtitle: String, for variant: CheckBoxVariant) {
        subtitles[variant] = subtitle
        updateView()
    }

    func setImage(_ image: UIImage?, for variant: CheckBoxVariant) {
        images[variant] = image
        updateView()
    }

    func setValue(_ value: Int, for variant: CheckBoxVariant) {
        valuesByVariant[variant] = value
    }

    func select(value: Int) {
        guard let variant = variantsByValue[value] else {
            return
        }

        selectedVariant = variant
    }

    private func setup() {
        setupViews()
        setupConstraints()

        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(checkBoxTapped)
        )

        addGestureRecognizer(tapRecognizer)
    }

    private func setupViews() {
        backgroundColor = .none

        addSubview(titleView)
        addSubview(subtitleView)
        addSubview(imageView)
    }

    private func setupConstraints() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -1).isActive = true

        subtitleView.translatesAutoresizingMaskIntoConstraints = false
        subtitleView.topAnchor.constraint(equalTo: centerYAnchor, constant: 1).isActive = true
        subtitleView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    @objc private func checkBoxTapped() {
        if !isSelected {
            isSelected = true
        } else {
            selectedVariant = (selectedVariant == .main) ? .alternative : .main
        }
    }

    private func updateView() {
        subtitleView.text = subtitles[selectedVariant]

        titleView.textColor = isSelected ? tintColor : mainColor
        subtitleView.textColor = minorColor

        guard let image = images[selectedVariant] else {
            return
        }

        guard let imageColor = isSelected ? tintColor : minorColor else {
            imageView.image = image
            return
        }

        if #available(iOS 13.0, *) {
            let coloredImage = image?.withTintColor(imageColor, renderingMode: .alwaysOriginal)
            imageView.image = coloredImage
        } else {
            let templateImage = image?.withRenderingMode(.alwaysTemplate)
            imageView.image = templateImage
            imageView.tintColor = imageColor
        }
    }

    // MARK: - Views

    private let titleView: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let subtitleView: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()

}
