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

private let cellIdentifier = "sensorsCollectionViewCell"
private let animationDuration = 0.5

extension SensorsViewController: SensorsView {

    func showPlaceholder() {
        DispatchQueue.main.async {
            self.rootView.collectionView.showAnimatedSkeleton(
                transition: .crossDissolve(animationDuration)
            )
        }
    }

    func hidePlaceholder() {
        DispatchQueue.main.async {
            self.rootView.collectionView.hideSkeleton(
                reloadDataAfter: true,
                transition: .crossDissolve(animationDuration)
            )
        }
    }

    func hideRefresher() {
        DispatchQueue.main.async {
            self.rootView.refreshControl.endRefreshing()
        }
    }

    func setSensors(_ sensors: [Sensor]) {
        DispatchQueue.main.async {
            self.sensors = sensors
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

    private var sensors = [Sensor]()

//    private var sensors: [Sensor] = [
//        Sensor(type: .temperature, name: "Temperature 1", data: 24.5),
//        Sensor(type: .temperature, name: "Temperature 2", data: -31.2),
//        Sensor(type: .temperature, name: "Temperature 3", data: 8.7),
//        Sensor(type: .temperature, name: "Temperature 4", data: 26.4),
//        Sensor(type: .humidity, name: "Humidity 1", data: 44),
//        Sensor(type: .humidity, name: "Humidity 2", data: 70)
//    ]

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
            SensorsCollectionViewCell.self,
            forCellWithReuseIdentifier: cellIdentifier
        )

        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self

        rootView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        rootView.collectionView.addSubview(rootView.refreshControl)

        rootView.collectionView.isSkeletonable = true
        SkeletonAppearance.default.multilineCornerRadius = 5
    }

    @objc func refresh() {
        presenter.refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        subscribe()
    }

    private func subscribe() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewWentBackground),
            name: TestViewController.willAppear,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewWentForeground),
            name: TestViewController.willDisappear,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
        unsubscribe()
    }

    private func unsubscribe() {
        NotificationCenter.default.removeObserver(
            self,
            name: TestViewController.willAppear,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: TestViewController.willDisappear,
            object: nil
        )
    }

    @objc private func viewWentBackground() {
        presenter.viewWentBackground()
    }

    @objc private func viewWentForeground() {
        presenter.viewWentForeground()
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SensorsViewController: SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return cellIdentifier
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sensors.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        ) as? SensorsCollectionViewCell {
            let sensor = sensors[indexPath.row]

            if sensor.type == .temperature {
                cell.iconView.image = UIImage.assets(.temperatureIcon) // Get image by sensor type
                cell.titleLabel.text = sensor.name
                cell.valueLabel.text = String(sensor.data as? Double ?? 0.0) // Get string representation of the sensor value
            } else {
                cell.iconView.image = UIImage.assets(.humidityIcon)
                cell.titleLabel.text = sensor.name
                cell.valueLabel.text = String(sensor.data as? Int ?? 0) + "%"
            }
            return cell
        }

        fatalError("Could not dequeue reusable cell")
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 24, height: 115)
    }

}
