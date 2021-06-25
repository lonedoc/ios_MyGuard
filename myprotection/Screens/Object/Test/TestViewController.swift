//
//  TestViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.05.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation

extension TestViewController: TestContract.View {

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

// MARK: -

class TestViewController: UIViewController {

    private var rootView: TestView { return view as! TestView } // swiftlint:disable:this force_cast
    private let presenter: TestContract.Presenter

    init(with presenter: TestContract.Presenter) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = TestView(frame: UIScreen.main.bounds)
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
