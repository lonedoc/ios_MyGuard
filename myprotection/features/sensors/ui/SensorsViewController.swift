//
//  SensorsViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 02.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import SkeletonView

private let cerberThermostatCellIdentifier = "cerberThermostatCellIdentifier"
private let animationDuration = 0.5

extension SensorsViewController: SensorsView {

    func showEmptyListMessage() {
        DispatchQueue.main.async {
            self.rootView.emptyListLabel.isHidden = false
            self.rootView.collectionView.isHidden = true
        }
    }

    func hideEmptyListMessage() {
        DispatchQueue.main.async {
            self.rootView.emptyListLabel.isHidden = true
            self.rootView.collectionView.isHidden = false
        }
    }

    func setDevices(_ devices: [Device]) {
        presenter.setDevices(devices)
    }

    func updateDevices(_ devices: [Device]) {
        DispatchQueue.main.async {
            self.devices = devices
            self.rootView.collectionView.reloadData()
        }
    }

    func showAlertDialog(title: String, message: String, completion: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.view.tintColor = .primaryColor

            let action = UIAlertAction(title: "OK", style: .default, handler: completion)
            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
    }

}

class SensorsViewController: UIViewController {

    private let presenter: SensorsPresenter

    // swiftlint:disable:next force_cast
    private var rootView: SensorsScreenLayout { return view as! SensorsScreenLayout }

    private var devices = [Device]()

    init(facilityId: String) {
        presenter = Assembler.shared.resolver.resolve(
            SensorsPresenter.self,
            argument: facilityId
        )!

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = SensorsScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

    private func setupCollectionView() {
        rootView.collectionView.register(
            CerberThermostatCell.self,
            forCellWithReuseIdentifier: cerberThermostatCellIdentifier
        )

        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
    }

}

private let itemsPerRow: CGFloat = 2

private let insets = UIEdgeInsets(
    top: 16.0,
    left: 16.0,
    bottom: 16.0,
    right: 16.0
)

private let itemHeight: Double = 128.0

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SensorsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

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
        let availableWidth = view.frame.width - gaps
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
