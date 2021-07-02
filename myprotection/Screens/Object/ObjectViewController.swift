//
//  ObjectViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import SkeletonView
import Swinject

extension ObjectViewController: ObjectContract.View {

    func setStatusDescription(_ description: String) {
        DispatchQueue.main.async {
            self.rootView.statusDescriptionView.text = description
        }
    }

    func setAddress(_ address: String) {
        DispatchQueue.main.async {
            self.rootView.addressView.text = address
        }
    }

    func setStatusIcon(_ status: StatusCode) {
        DispatchQueue.main.async {
            self.rootView.armButtonIcon = status.image
            self.rootView.armButtonColor = status.color
        }
    }

    func setLinkIconHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.linkIconWrapper.isHidden = hidden
        }
    }

    func setLinkIcon(linked: Bool) {
        DispatchQueue.main.async {
            let iconResource: AssetsImage = linked ? .link : .linkOff
            self.rootView.linkIcon.image = UIImage.assets(iconResource)
        }
    }

    func setArmButtonEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.rootView.armButton.isEnabled = enabled
        }
    }

    func setAlarmButtonEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.rootView.bottomAppBar.floatingButton.setEnabled(enabled, animated: true)
        }
    }

    func showProgressBar(message: String, type: ExecutingCommandType) {
        DispatchQueue.main.async {
            let color: UIColor = type == .arming ? .guardedStatusColor : .notGuardedStatusColor

            self.rootView.armingProgressText.text = message
            self.rootView.armingProgressView.progressTintColor = color
            self.rootView.armingProgressView.trackTintColor = color.withAlphaComponent(0.5)

            self.rootView.armingProgressView.alpha = 0
            self.rootView.armingProgressText.alpha = 0
            self.rootView.armingProgressView.startAnimating()

            UIView.animate(withDuration: 1) {
                self.rootView.armingProgressView.alpha = 1
                self.rootView.armingProgressText.alpha = 1
            }
        }
    }

    func hideProgressBar() {
        DispatchQueue.main.async {
            self.rootView.armingProgressView.alpha = 1
            self.rootView.armingProgressText.alpha = 1

            UIView.animate(
                withDuration: 1,
                animations: {
                    self.rootView.armingProgressView.alpha = 0
                    self.rootView.armingProgressText.alpha = 0
                },
                completion: { _ in self.rootView.armingProgressView.stopAnimating() }
            )
        }
    }

    func showEventsView(objectId: String, communicationData: CommunicationData) {
        getUnitOfWork { unitOfWork in
            DispatchQueue.main.async {
                let viewController = Container.shared.resolve(
                    EventsContract.View.self,
                    arguments: objectId, communicationData, unitOfWork
                )!
                self.include(viewController: viewController)
            }
        }
    }

    func showConfirmDialog(message: String, proceed: @escaping () -> Void) {
        let dialog = UIAlertController(
            title: "Confirmation required".localized,
            message: message,
            preferredStyle: .alert
        )

        dialog.view.tintColor = .primaryColor

        let proceedAction = UIAlertAction(title: "Proceed".localized, style: .default, handler: { _ in proceed() })
        dialog.addAction(proceedAction)

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        dialog.addAction(cancelAction)

        self.present(dialog, animated: true, completion: nil)
    }

    func showEditNameDialog(currentName: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(
                title: "Facility's name".localized,
                message: nil,
                preferredStyle: .alert
            )

            controller.view.tintColor = .primaryColor

            controller.addTextField { textField in
                textField.text = currentName
                textField.selectAll(nil)
            }

            let cancelAction = UIAlertAction(
                title: "Cancel".localized,
                style: .cancel
            ) { _ in controller.dismiss(animated: true, completion: nil) }

            let doneAction = UIAlertAction(
                title: "Done".localized,
                style: .default
            ) { _ in
                let name = controller.textFields![0].text!

                if name.count == 0 {
                    return
                }

                self.presenter.newNameProvided(name: name)
            }

            controller.addAction(cancelAction)
            controller.addAction(doneAction)

            self.present(controller, animated: true, completion: nil)
        }
    }

    func showTestAlarmView(objectId: String, communicationData: CommunicationData) {
        DispatchQueue.main.async {
            let controller = Container.shared.resolve(
                TestContract.View.self,
                arguments: objectId, communicationData
            )!

            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
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

class ObjectViewController: UIViewController {

    private let presenter: ObjectContract.Presenter
    private var rootView: ObjectView { return view as! ObjectView } // swiftlint:disable:this force_cast

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return formatter
    }()

    init(with presenter: ObjectContract.Presenter) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ObjectView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

    private func setup() {
        rootView.editButton.target = self
        rootView.editButton.action = #selector(editButtonTapped)

        navigationItem.rightBarButtonItem = rootView.editButton

        let gestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(armButtonLongPressed)
        )

        rootView.armButton.addGestureRecognizer(gestureRecognizer)
        rootView.armButton.addTarget(self, action: #selector(armButtonTapped), for: .touchUpInside)

        rootView.bottomAppBar.floatingButton.addTarget(
            self,
            action: #selector(alarmButtonTapped),
            for: .touchUpInside
        )

        rootView.testAlarmButton.target = self
        rootView.testAlarmButton.action = #selector(testAlarmButtonTapped)
    }

    @objc func alarmButtonTapped() {
        presenter.alarmButtonTapped()
    }

    @objc func testAlarmButtonTapped() {
        presenter.testAlarmButtonTapped()
    }

    @objc func editButtonTapped() {
        presenter.editButtonTapped()
    }

    @objc func armButtonTapped() {
        presenter.armButtonTapped()
    }

    @objc func armButtonLongPressed(_ recognizer: UIGestureRecognizer) {
        if recognizer.state != .ended {
            return
        }

        presenter.armButtonLongPressed()
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

    private func getUnitOfWork(completion: @escaping (UnitOfWork?) -> Void) {
        let contextProvider = Container.shared.resolve(CoreDataContextProvider.self)!
        contextProvider.loadStores { error in
            if error != nil {
                completion(nil)
            } else {
                let unitOfWork = Container.shared.resolve(
                    UnitOfWork.self,
                    argument: contextProvider.newBackgroundContext()
                )
                completion(unitOfWork)
            }
        }
    }

    private func include(viewController: UIViewController) {
        addChild(viewController)

        viewController.view.frame = rootView.bottomView.bounds
        rootView.bottomView.addSubview(viewController.view)

        viewController.didMove(toParent: self)
    }

}
