//
//  SensorsView.swift
//  myprotection
//
//  Created by Rubeg NPO on 02.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

private let cerberThermostatCellIdentifier = "cerberThermostatCellIdentifier"

class SensorsScreenLayout: UIView {

    private var devices = [Device]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(devices: [Device]) {
        self.devices = devices
        collectionView.reloadData()
    }

    private func setup() {
        backgroundColor = UIColor(color: .backgroundPrimary)

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(collectionView)
        addSubview(emptyListLabel)

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            CerberThermostatCell.self,
            forCellWithReuseIdentifier: cerberThermostatCellIdentifier
        )
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        emptyListLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyListLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emptyListLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    // MARK: - Views

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = UIColor(color: .backgroundPrimary)

        return collectionView
    }()

    let emptyListLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(color: .textSecondary)
        label.text = "Empty".localized
        return label
    }()

}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

private let itemsPerRow: CGFloat = 2
private let itemHeight: Double = 128.0

private let insets = UIEdgeInsets(
    top: 16.0,
    left: 16.0,
    bottom: 16.0,
    right: 16.0
)

extension SensorsScreenLayout:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return devices.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let device = devices[indexPath.row]

        switch device.deviceType {
        case .cerberThermostat:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cerberThermostatCellIdentifier,
                for: indexPath
            )

            if let thermostat = device as? CerberThermostat {
                (cell as? CerberThermostatCell)?.bind(thermostat)
            }

            return cell
        default:
            break
        }

        fatalError("Could not dequeue reusable cell")
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let gaps = insets.left * (itemsPerRow + 1)
        let availableWidth = frame.width - gaps
        let itemWidth = availableWidth / itemsPerRow
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return insets
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return insets.left
    }

}

