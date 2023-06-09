//
//  TestViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.05.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation
import Swinject

extension TestViewController: TestView {

    static let willAppear = Notification.Name("testViewControllerWillAppear")
    static let willDisappear = Notification.Name("testViewControllerWillDisappear")

    func setTip(text: String) {
        DispatchQueue.main.async {
            self.rootView.tipText.text = text
        }
    }

    func setCountdown(text: String) {
        DispatchQueue.main.async {
            self.rootView.countDownText.text = text
        }
    }

    func setResetButtonEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.rootView.resetButton.isEnabled = enabled
        }
    }

    func close() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

// MARK: -

class TestViewController: UIViewController {

    private let presenter: TestPresenter

    // swiftlint:disable:next force_cast
    private var rootView: TestScreenLayout { return view as! TestScreenLayout }

    init(facilityId: String) {
        self.presenter = Assembler.shared.resolver.resolve(
            TestPresenter.self,
            argument: facilityId
        )!

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = TestScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.post(name: TestViewController.willAppear, object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: TestViewController.willDisappear, object: nil)
        NotificationCenter.default.removeObserver(self)
    }

    private func setup() {
        rootView.resetButton.addTarget(
            self,
            action: #selector(resetButtonPressed),
            for: .touchUpInside
        )

        rootView.completeButton.addTarget(
            self,
            action: #selector(completeButtonPressed),
            for: .touchUpInside
        )
    }

    @objc func applicationWillResignActive() {
        presenter.applicationWillResignActive()
    }

    @objc func resetButtonPressed() {
        presenter.resetButtonPressed()
    }

    @objc func completeButtonPressed() {
        presenter.completeButtonPressed()
    }

}
