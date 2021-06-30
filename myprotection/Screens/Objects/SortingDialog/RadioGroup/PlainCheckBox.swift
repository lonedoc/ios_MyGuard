//
//  PlainCheckBox.swift
//  myprotection
//
//  Created by Rubeg NPO on 23.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

enum CheckBoxState {
    case selected, notSelected
}

class PlainCheckBox: UIView, CheckBox {

    private var imageSelected: UIImage?
    private var imageNotSelected: UIImage?

    var isSelected: Bool = false {
        didSet {
            updateView()
            delegate?.stateChanged(sender: self)
        }
    }

    var value: Int = 0

    var values: [Int] {
        return [value]
    }

    var mainColor: UIColor? {
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

    weak var delegate: CheckBoxDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage?, for state: CheckBoxState) {
        if state == .selected {
            imageSelected = image
        } else {
            imageNotSelected = image
        }
    }

    func select(value: Int) {
        isSelected = true
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
        addSubview(imageView)
    }

    private func setupConstraints() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    @objc private func checkBoxTapped() {
        isSelected = !isSelected
    }

    private func updateView() {
        titleView.textColor = isSelected ? tintColor : mainColor
        
        let image = isSelected ? imageSelected : imageNotSelected

        guard let imageColor = tintColor else {
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

    let titleView: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()

}
