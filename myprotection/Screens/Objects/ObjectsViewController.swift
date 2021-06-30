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

extension ObjectsViewController: ObjectsContract.View {

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

    func openObjectScreen(facility: Facility, communicationData: CommunicationData) {
        DispatchQueue.main.async {
            let viewController = Container.shared.resolve(
                ObjectContract.View.self,
                arguments: facility, communicationData
            )!

            self.navigationController?.pushViewController(viewController, animated: true)
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

private let cellIdentifier = "object_cell"

class ObjectsViewController: UIViewController, SortingDialogDelegate {

    private let presenter: ObjectsContract.Presenter
    private var rootView: ObjectsView { return view as! ObjectsView } // swiftlint:disable:this force_cast

    private var facilities = [Facility]()

    init(with presenter: ObjectsContract.Presenter) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        title = "Objects list".localized
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ObjectsView(frame: UIScreen.main.bounds)
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
    }

    private func setup() {
        rootView.tableView.register(ObjectsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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

extension ObjectsViewController: SkeletonTableViewDataSource, UITableViewDelegate {

    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ObjectsTableViewCell

        let facility = facilities[indexPath.row]

        cell.title = facility.name
        cell.address = facility.address
        cell.status = facility.status
        cell.statusIcon = facility.statusCode.image
        cell.statusColor = facility.statusCode.color

        return cell
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
