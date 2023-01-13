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

class SensorsViewController: UIViewController, SensorsView {

    private let presenter: SensorsPresenter

    // swiftlint:disable:next force_cast
    private var rootView: SensorsScreenLayout { return view as! SensorsScreenLayout }

    private var devices: [Device] {
        didSet {
            rootView.bind(devices: devices)
        }
    }

    init(facilityId: String) {
        presenter = Assembler.shared.resolver.resolve(
            SensorsPresenter.self,
            argument: facilityId
        )!

        devices = []

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    override func loadView() {
        view = SensorsScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

}
