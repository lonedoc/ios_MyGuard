//
//  ObjectsViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import SkeletonView
import Swinject

extension FacilitiesViewController: FacilitiesView {

    func showPlaceholder() {
        DispatchQueue.main.async {
            self.rootView.tableView.showAnimatedSkeleton(transition: .crossDissolve(0.5))
        }
    }

    func hidePlaceholder() {
        DispatchQueue.main.async {
            self.rootView.tableView.hideSkeleton(
                reloadDataAfter: true,
                transition: .crossDissolve(0.5)
            )
        }
    }

    func hideRefresher() {
        DispatchQueue.main.async {
            self.rootView.refreshControl.endRefreshing()
        }
    }

    func updateData(facilities: [Facility]) {
        DispatchQueue.main.async {
            self.facilities = facilities
            self.rootView.tableView.reloadData()
        }
    }

    func showSortingDialog(options: [SortingOption], defaultValue: Int) {
        DispatchQueue.main.async {
            let sortingDialog = SortingDialogController()
            sortingDialog.delegate = self

            options.forEach { option in
                sortingDialog.addOption(option)
            }

            sortingDialog.setDefault(value: defaultValue)

            self.present(sortingDialog, animated: true, completion: nil)
        }
    }

    func openObjectScreen(facility: Facility) {
        DispatchQueue.main.async {
            let viewController = FacilityViewController(facility: facility)
            viewController.title = facility.name

            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

}

// MARK: -

private let cellIdentifier = "object_cell"

class FacilitiesViewController: UIViewController, SortingDialogDelegate {

    private let presenter: FacilitiesPresenter

    // swiftlint:disable:next force_cast
    private var rootView: FacilitiesScreenLayout { return view as! FacilitiesScreenLayout }

    private var facilities = [Facility]()

    init() {
        self.presenter = Assembler.shared.resolver.resolve(FacilitiesPresenter.self)!

        super.init(nibName: nil, bundle: nil)
        title = "Objects list".localized
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = FacilitiesScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

    private func setup() {
        rootView.tableView.register(FacilitiesTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        rootView.tableView.isSkeletonable = true

        SkeletonAppearance.default.multilineCornerRadius = 5

        rootView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        rootView.tableView.addSubview(rootView.refreshControl)

        rootView.sortButton.target = self
        rootView.sortButton.action = #selector(sortButtonTapped)
        navigationItem.rightBarButtonItem = rootView.sortButton
    }

    @objc private func refresh() {
        presenter.refresh()
    }

    @objc private func sortButtonTapped() {
        presenter.sortButtonTapped()
    }

    func sortingChanged(sorting: Int) {
        presenter.sortingChanged(sorting)
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate

extension FacilitiesViewController: SkeletonTableViewDataSource, UITableViewDelegate {

    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FacilitiesTableViewCell

        let facility = facilities[indexPath.row]

        cell.title = facility.name
        cell.address = facility.address
        cell.status = facility.status
        cell.statusIcon = getStatusIcon(by: facility.statusCode)
        cell.statusColor = getStatusColor(by: facility.statusCode)

        return cell
    }

    private func getStatusIcon(by statusCode: StatusCode) -> UIImage? {
        switch statusCode {
        case let status where status.isNotGuarded:
            return UIImage.assets(.notGuardedStatusIcon)
        case let status where status.isFullGuarded:
            return UIImage.assets(.guardedStatusIcon)
        case let status where status.isPerimeterOnlyGuarded:
            return UIImage.assets(.perimeterOnlyStatusIcon)
        case let status where status.isAlarm:
            return UIImage.assets(.alarmStatusIcon)
        case let status where status.isMalfunction:
            return UIImage.assets(.malfunctionStatusIcon)
        default:
            return nil
        }
    }

    private func getStatusColor(by statusCode: StatusCode) -> UIColor {
        switch statusCode {
        case let status where status.isAlarm:
            return .alarmStatusColor
        case let status where status.isMalfunction:
            return .malfunctionStatusColor
        case let status where status.isNotGuarded:
            return .notGuardedStatusColor
        case let status where status.isGuarded:
            return .guardedStatusColor
        default:
            return .malfunctionStatusColor
        }
    }

    func collectionSkeletonView(
        _ skeletonView: UITableView,
        cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return cellIdentifier
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.objectSelected(facilities[indexPath.row])
    }

}
