//
//  CancelAlarmDialog.swift
//  myprotection
//
//  Created by Rubeg NPO on 30.03.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

protocol RadioButtonDelegate : AnyObject {
    func didCheckRadioButton(_ radioButton: RadioButton)
}

class RadioButton: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isChecked: Bool = false {
        didSet {
            let image: UIImage?
            let tintColor: UIColor?

            if isChecked {
                image = UIImage.assets(.radioButtonChecked)
                tintColor = .primaryColor
            } else {
                image = UIImage.assets(.radioButtonUnchecked)
                tintColor = .darkGray
            }

            iconView.image = image
            iconView.tintColor = tintColor
            titleView.textColor = tintColor

            delegate?.didCheckRadioButton(self)
        }
    }

    var text: String = "" {
        didSet {
            titleView.text = text
        }
    }

    weak var delegate: RadioButtonDelegate?

    private func setup() {
        setupViews()
        setupConstraints()

        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap)
        )

        addGestureRecognizer(gestureRecognizer)
    }

    @objc private func didTap() {
        isChecked = !isChecked
    }

    private func setupViews() {
        addSubview(iconView)
        addSubview(titleView)
    }

    private func setupConstraints() {        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8).isActive = true
        titleView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    // MARK: - Views

    let iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage.assets(.radioButtonUnchecked)
        imageView.tintColor = .darkGray
        return imageView
    }()

    let titleView: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()

}
