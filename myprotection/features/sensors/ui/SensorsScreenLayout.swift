//
//  SensorsView.swift
//  myprotection
//
//  Created by Rubeg NPO on 02.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

class SensorsScreenLayout: UIView {

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
    }

    private func setupViews() {
        addSubview(collectionView)
        addSubview(emptyListLabel)
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        emptyListLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyListLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emptyListLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -32).isActive = true
    }

    // MARK: - Views

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 96, right: 0)
        return collectionView
    }()

    let emptyListLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.text = "Empty".localized
        return label
    }()

}
