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

    private var state: CheckBoxState = .notSelected
    private var variant: CheckBoxVariant = .main

    private var variantsByValue = [Int: CheckBoxVariant]()
    private var valuesByVariant = [CheckBoxVariant: Int]()
    private var subtitles = [CheckBoxVariant: String]()
    private var images = [CheckBoxVariant: UIImage]()

    var delegate: CheckBoxDelegate?

    var value: Int {
        return valuesByVariant[variant] ?? 0
    }

    var values: [Int] {
        return Array(variantsByValue.keys)
    }

    var isSelected: Bool = false {
        didSet {
            delegate?.stateChanged(sender: self)
            updateView()
        }
    }

    func select(value: Int?) {
        defer {
            isSelected = true
            updateView()
        }

        guard let val = value else { return }
        guard let variant = variantsByValue[val] else { return }
        self.variant = variant
    }

    func setValue(_ value: Int, for variant: CheckBoxVariant) {
        valuesByVariant[variant] = value
        variantsByValue[value] = variant
    }

    func setTitle(_ title: String) {
        titleView.text = title
    }

    func setSubtitle(_ subtitle: String, for variant: CheckBoxVariant) {
        subtitles[variant] = subtitle
        updateView()
    }

    func setImage(_ image: UIImage?, for variant: CheckBoxVariant) {
        if let image = image {
            images[variant] = image
        }
        updateView()
    }

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

        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(checkBoxTapped)
        )

        addGestureRecognizer(tapRecognizer)
    }

    @objc func checkBoxTapped() {
        if !isSelected {
            isSelected = true
        } else {
            if variant == .main {
                variant = .alternative
            } else {
                variant = .main
            }
        }

        delegate?.stateChanged(sender: self)

        updateView()
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

    private func updateView() {
        subtitleView.text = subtitles[variant]
        imageView.image = images[variant]

        titleView.textColor = isSelected ? tintColor : .black
        imageView.tintColor = isSelected ? tintColor : .gray
    }

    // MARK: Views

    let titleView: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    let subtitleView: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()

}
