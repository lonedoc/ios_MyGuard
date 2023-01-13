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

// swiftlint:disable file_length type_body_length
class FacilityViewController: UIViewController, FacilityView, CancelAlarmDialogDelegate {

    private let presenter: FacilityPresenter

    // swiftlint:disable:next force_cast
    private var rootView: FacilityScreenLayout { return view as! FacilityScreenLayout }

    private let tabTitles = [
        "Events".localized,
        "Sensors".localized,
        "Payment".localized,
        "Application".localized
    ]

    private var eventsViewController: EventsViewController?
    private var sensorsViewController: SensorsViewController?
    private var accountViewController: AccountViewController?
    private var applicationsViewController: ApplicationsViewController?
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
        title = "Details".localized
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAlarmButtonHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.alarmButton.isHidden = hidden
        }
    }

    func setCancelAlarmButtonHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.cancelAlarmButton.isHidden = hidden
        }
    }

    func setArmButtonHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.armButton.isHidden = hidden
        }
    }

    func setDisarmButtonHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.disarmButton.isHidden = hidden
        }
    }

    func setTitle(_ title: String) {
        DispatchQueue.main.async {
            self.rootView.titleLabel.text = title
        }
    }

    func setStatusDescription(_ description: String) {
        DispatchQueue.main.async {
            self.rootView.statusLabel.text = description
        }
    }

    func setStatusIcon(_ status: StatusCode) {
        DispatchQueue.main.async {
            self.rootView.updateStatus(statusCode: status)
        }
    }

    func setOnlineChannelIconHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.onlineChannelIcon.isHidden = hidden
        }
    }

    func setElectricityIconHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.powerSupplyMalfunctionIcon.isHidden = hidden
        }
    }

    func setBatteryIconHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            self.rootView.batteryMalfunctionIcon.isHidden = hidden
        }
    }

    func setDevices(_ devices: [Device]) {
        DispatchQueue.main.async {
            self.sensorsViewController?.setDevices(devices)
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

        replaceChild(viewController: viewController)
    }

    func showAccountView(accounts: [Account]) {
        let viewController = accountViewController ?? AccountViewController()
        accountViewController = viewController

        viewController.updateAccounts(accounts)

        replaceChild(viewController: viewController)
    }

    func showApplicationView(facilityId: String) {
        let viewController = applicationsViewController ?? ApplicationsViewController(facilityId: facilityId)
        applicationsViewController = viewController

        replaceChild(viewController: viewController)
    }

    func showConfirmDialog(message: String, proceedText: String, proceed: @escaping () -> Void) {
        let dialog = UIAlertController(
            title: "Confirmation required".localized,
            message: message,
            preferredStyle: .alert
        )

        dialog.view.tintColor = UIColor(color: .accent)

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

            controller.view.tintColor = UIColor(color: .accent)

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

    func openApplicationView(facilityId: String) {
        DispatchQueue.main.async {
            let controller = ApplicationsViewController(facilityId: facilityId)
            controller.title = "Application".localized
            self.navigationController?.pushViewController(controller, animated: true)
        }
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        subscribeForAppEvents()
        subscribeForKeyboardEvents()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
        unsubscribeFromAppEvents()
        unsubscribeFromKeyboardEvents()
    }

    private func setup() {
        navigationItem.rightBarButtonItems = [rootView.testModeButton, rootView.renameButton]

        rootView.testModeButton.target = self
        rootView.testModeButton.action = #selector(testAlarmButtonTapped)

        rootView.renameButton.target = self
        rootView.renameButton.action = #selector(editButtonTapped)

        let gestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(self.armButtonLongPressed)
        )

        rootView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        rootView.cancelAlarmButton.addTarget(self, action: #selector(cancelAlarmButtonTapped), for: .touchUpInside)
        rootView.armButton.addTarget(self, action: #selector(armButtonTapped), for: .touchUpInside)
        rootView.disarmButton.addTarget(self, action: #selector(disarmButtonTapped), for: .touchUpInside)
        rootView.armButton.addGestureRecognizer(gestureRecognizer)

        rootView.tabs.titles = tabTitles
        rootView.tabs.menuDelegate = self

        rootView.tabs.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
    }

    @objc func alarmButtonTapped() {
        presenter.alarmButtonTapped()
    }

    @objc func cancelAlarmButtonTapped() {
        presenter.cancelAlarmButtonTapped()
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

    @objc func disarmButtonTapped() {
        presenter.disarmButtonTapped()
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

    @objc func testAlarmButtonTapped() {
        presenter.testAlarmButtonTapped()
    }

    @objc func editButtonTapped() {
        presenter.editButtonTapped()
    }

    @objc func applyButtonTapped() {
        presenter.applyButtonTapped()
    }

    private func subscribeForAppEvents() {
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

    private func subscribeForKeyboardEvents() {
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

    private func unsubscribeFromAppEvents() {
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

    private func unsubscribeFromKeyboardEvents() {
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
        rootView.scrollView.scrollRectToVisible(rootView.contentView.frame, animated: true)
    }

    @objc func keyboardWillHide(_: Notification) {
        rootView.scrollView.contentInset = .zero
        rootView.scrollView.scrollIndicatorInsets = rootView.scrollView.contentInset
    }

    func didSelectPasscode(passcode: String) {
        presenter.cancelAlarmPasscodeProvided(passcode: passcode)
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

        rootView.contentView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.topAnchor.constraint(equalTo: rootView.contentView.topAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: rootView.contentView.leadingAnchor).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: rootView.contentView.trailingAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: rootView.contentView.bottomAnchor).isActive = true

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

extension FacilityViewController: MenuBarDelegate {

    func menuBarDidSelectItemAt(menu: MenuTabsView, index: Int) {
        switch index {
        case 0:
            presenter.eventsButtonTapped()
        case 1:
            presenter.sensorsButtonTapped()
        case 2:
            presenter.accountButtonTapped()
        case 3:
            presenter.applyButtonTapped()
        default:
            return
        }
    }

}
