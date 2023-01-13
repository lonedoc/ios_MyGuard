//
//  TabItemCell.swift
//  myprotection
//
//  Created by Rubeg NPO on 07.12.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

class TabItemCell : UICollectionViewCell {

    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.indicatorView.backgroundColor = self.isSelected ?
                    UIColor(color: .backgroundSurfaceVariant) :
                    .clear

                self.titleLabel.textColor = self.isSelected ?
                    UIColor(color: .textContrast) :
                    UIColor(color: .textSecondary)

                self.layoutIfNeeded()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    private func setup() {
        backgroundColor = .clear

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        indicatorView.addSubview(titleLabel)
        addSubview(indicatorView)
    }

    private func setupConstraints() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 36).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor).isActive = true
    }

    // MARK: Views

    let indicatorView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 8
        view.backgroundColor = .clear
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = TextStyle.caption1.font
        label.textColor = UIColor(color: .textSecondary)
        return label
    }()

}
