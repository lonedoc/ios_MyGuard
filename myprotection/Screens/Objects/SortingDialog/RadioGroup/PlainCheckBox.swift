//
//  PlainCheckBox.swift
//  myprotection
//
//  Created by Rubeg NPO on 23.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

class PlainCheckBox: UIView, CheckBox {

    private var state: CheckBoxState = .notSelected

    private var images = [CheckBoxState: UIImage]()

    weak var delegate: CheckBoxDelegate?
    private(set) var value: Int = 0

    var values: [Int] {
        return [value]
    }

    var isSelected: Bool = false {
        didSet {
            state = isSelected ? .selected : .notSelected
            delegate?.stateChanged(sender: self)
            updateView()
        }
    }

    func select(value: Int?) {
        isSelected = true
    }

    func setValue(_ value: Int) {
        self.value = value
    }

    func setTitle(_ title: String) {
        titleView.text = title
    }

    func setImage(_ image: UIImage?, for state: CheckBoxState) {
        if let image = image {
            images[state] = image
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
        isSelected = !isSelected
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

    private func updateView() {
        titleView.textColor = isSelected ? tintColor : .black
        imageView.image = images[state]
        imageView.tintColor = tintColor
    }

    // MARK: Views

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
