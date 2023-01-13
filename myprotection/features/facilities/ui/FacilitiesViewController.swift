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

private let cellIdentifier = "object_cell"

class FacilitiesViewController: UIViewController, FacilitiesView {

    private let presenter: FacilitiesPresenter

    // swiftlint:disable:next force_cast
    private var rootView: FacilitiesScreenLayout { return view as! FacilitiesScreenLayout }

    private var facilities = [Facility]()

    init() {
        self.presenter = Assembler.shared.resolver.resolve(FacilitiesPresenter.self)!

        super.init(nibName: nil, bundle: nil)
        title = "Facilities list".localized
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    func call(_ url: URL) {
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                self.presenter.phoneCallFailed()
            }
        }
    }

    func openFacilityScreen(facility: Facility) {
        DispatchQueue.main.async {
            let viewController = FacilityViewController(facility: facility)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(color: .cardBackground)

        rootView.phoneButton.target = self
        rootView.phoneButton.action = #selector(phoneButtonTapped)

        navigationItem.leftBarButtonItem = rootView.phoneButton

        rootView.sortingSegmentedControl.selectedSegmentIndex = 0
        rootView.sortingSegmentedControl.addTarget(
            nil,
            action: #selector(sortingChanged),
            for: .valueChanged
        )

        rootView.tableView.register(FacilitiesTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        rootView.tableView.isSkeletonable = true

        SkeletonAppearance.default.multilineCornerRadius = 5

        rootView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        rootView.tableView.addSubview(rootView.refreshControl)
    }

    @objc private func sortingChanged() {
        let sorting: FacilitiesSorting

        switch rootView.sortingSegmentedControl.selectedSegmentIndex {
        case 1:
            sorting = FacilitiesSorting.byNameAscending
        case 2:
            sorting = FacilitiesSorting.byAddressAscending
        default:
            sorting = FacilitiesSorting.byStatus
        }

        print(sorting)

        presenter.sortingChanged(sorting)
    }

    @objc private func refresh() {
        presenter.refresh()
    }

    @objc private func phoneButtonTapped() {
        presenter.phoneButtonTapped()
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
        cell.bind(facility: facility)

        return cell
    }

    func collectionSkeletonView(
        _ skeletonView: UITableView,
        cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return cellIdentifier
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.facilitySelected(facilities[indexPath.row])
    }

}
