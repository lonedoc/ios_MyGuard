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

// swiftlint:disable file_length

extension FacilityViewController: FacilityView {

    func setName(_ name: String) {
        DispatchQueue.main.async {
            self.title = name
        }
    }

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
            if let image = self.getStatusImage(status) {
                self.rootView.armButton.setImage(image, for: .normal)
            }
        }
    }

    func setDevices(_ devices: [Device]) {
        DispatchQueue.main.async {
            self.sensorsViewController?.setDevices(devices)
        }
    }

    func setLinkIconHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.linkIconWrapper.isHidden = hidden
        }
    }

    func setElectricityIconHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.electricityMalfunctionIconWrapper.isHidden = hidden
        }
    }

    func setBatteryIconHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.batteryMalfunctionIconWrapper.isHidden = hidden
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

    func setAlarmButtonVariant(_ isStartAlarmVariant: Bool) {
        let backgroundColor = isStartAlarmVariant ? UIColor.errorColor : UIColor.secondaryColor
        let icon = isStartAlarmVariant ? UIImage.assets(.alarm) : UIImage.assets(.cancelAlarm)

        DispatchQueue.main.async {
            self.rootView.bottomAppBar.floatingButton.setImage(icon, for: .normal)
            self.rootView.bottomAppBar.floatingButton.setBackgroundColor(backgroundColor, for: .normal)
        }
    }

    func setAccountsButtonHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            let buttons = hidden ?
                [self.rootView.testAlarmButton] :
                [self.rootView.accountButton, self.rootView.testAlarmButton]

            self.rootView.bottomAppBar.trailingBarButtonItems = buttons
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

    func showEventsView(facilityId: String) {
        if let viewController = eventsViewController {
            replaceChild(viewController: viewController)
            return
        }

        getUnitOfWork { unitOfWork in
            DispatchQueue.main.async {
                let viewController = EventsViewController(
                    facilityId: facilityId,
                    unitOfWork: unitOfWork
                )

                self.eventsViewController = viewController

                self.replaceChild(viewController: viewController)
            }
        }
    }

    func showSensorsView(facility: Facility) {
        let viewController = sensorsViewController ?? SensorsViewController(facilityId: facility.id)
        sensorsViewController = viewController

        viewController.setDevices(facility.devices)

        self.replaceChild(viewController: viewController)
    }

    func showAccountView(accounts: [Account]) {
        let viewController = accountViewController ?? AccountViewController()
        accountViewController = viewController

        viewController.updateAccounts(accounts)

        self.replaceChild(viewController: viewController)
    }

    func showConfirmDialog(message: String, proceedText: String, proceed: @escaping () -> Void) {
        let dialog = UIAlertController(
            title: "Confirmation required".localized,
            message: message,
            preferredStyle: .alert
        )

        dialog.view.tintColor = .primaryColor

        let proceedAction = UIAlertAction(title: proceedText, style: .default, handler: { _ in proceed() })
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

    func showCancelAlarmDialog(passcodes: [String]) {
        DispatchQueue.main.async {
            let controller = CancelAlarmDialogController(passcodes: passcodes)
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }

    func showTestAlarmView(facilityId: String) {
        DispatchQueue.main.async {
            let controller = TestViewController(facilityId: facilityId)
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }

    func showNavigationItems(isApplicationsEnabled: Bool) {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItems = isApplicationsEnabled ?
                [self.rootView.applyButton, self.rootView.editButton] :
                [self.rootView.editButton]
        }
    }

    func openApplicationScreen(facilityId: String) {
        DispatchQueue.main.async {
            let controller = ApplicationsViewController(facilityId: facilityId)
            controller.title = "Application".localized
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

}

// MARK: -

class FacilityViewController: UIViewController, CancelAlarmDialogDelegate {

    private let presenter: FacilityPresenter

    // swiftlint:disable:next force_cast
    private var rootView: FacilityScreenLayout { return view as! FacilityScreenLayout }

    private var eventsViewController: EventsViewController?
    private var sensorsViewController: SensorsViewController?
    private var accountViewController: AccountViewController?
    private var currentViewController: UIViewController?

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return formatter
    }()

    init(facility: Facility) {
        self.presenter = Assembler.shared.resolver.resolve(
            FacilityPresenter.self,
            argument: facility
        )!

        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = FacilityScreenLayout(frame: UIScreen.main.bounds)
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

        rootView.applyButton.target = self
        rootView.applyButton.action = #selector(applyButtonTapped)

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

        rootView.eventsButton.target = self
        rootView.eventsButton.action = #selector(eventsButtonTapped)

        rootView.sensorsButton.target = self
        rootView.sensorsButton.action = #selector(sensorsButtonTapped)

        rootView.accountButton.target = self
        rootView.accountButton.action = #selector(accountButtonTapped)
    }

    @objc func eventsButtonTapped() {
        presenter.eventsButtonTapped()
    }

    @objc func sensorsButtonTapped() {
        presenter.sensorsButtonTapped()
    }

    @objc func accountButtonTapped() {
        presenter.accountButtonTapped()
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

    @objc func applyButtonTapped() {
        presenter.applyButtonTapped()
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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
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

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func viewWentBackground() {
        presenter.viewWentBackground()
    }

    @objc private func viewWentForeground() {
        presenter.viewWentForeground()
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardSize = keyboardFrame.cgRectValue

        rootView.scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardSize.height,
            right: 0
        )

        rootView.scrollView.scrollIndicatorInsets = rootView.scrollView.contentInset
    }

    @objc func keyboardWillHide(_: Notification) {
        rootView.scrollView.contentInset = .zero
        rootView.scrollView.scrollIndicatorInsets = rootView.scrollView.contentInset
    }

    func didSelectPasscode(passcode: String) {
        presenter.cancelAlarmPasscodeProvided(passcode: passcode)
    }

    private func getStatusImage(_ status: StatusCode) -> UIImage? {
        if status.isAlarm {
            if status.isGuarded {
                return UIImage.assets(.alarmGuardedStatus)
            } else {
                return UIImage.assets(.alarmNotGuardedStatus)
            }
        } else {
            if status.isGuarded {
                return UIImage.assets(.guardedStatus)
            } else {
                return UIImage.assets(.notGuardedStatus)
            }
        }
    }

    private func getUnitOfWork(completion: @escaping (UnitOfWork?) -> Void) {
        let contextProvider = Assembler.shared.resolver.resolve(CoreDataContextProvider.self)!

        contextProvider.loadStores { error in
            if error != nil {
                completion(nil)
            } else {
                let unitOfWork = Assembler.shared.resolver.resolve(
                    UnitOfWork.self,
                    argument: contextProvider.newBackgroundContext()
                )

                completion(unitOfWork)
            }
        }
    }

    private func replaceChild(viewController: UIViewController) {
        if let currentViewController = currentViewController {
            remove(viewController: currentViewController)
        }

        include(viewController: viewController)

        currentViewController = viewController
    }

    private func include(viewController: UIViewController) {
        addChild(viewController)

        viewController.view.frame = rootView.bottomView.bounds
        rootView.bottomView.addSubview(viewController.view)

        viewController.didMove(toParent: self)
    }

    private func remove(viewController: UIViewController) {
        guard viewController.parent != nil else {
            return
        }

        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

}
