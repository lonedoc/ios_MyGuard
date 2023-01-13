//
//  EventsViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 05.04.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import Swinject
import SkeletonView

private let cellIdentifier = "eventsTableViewCell"
private let animationDuration = 0.5

class EventsViewController: UIViewController, EventsView {

    private let presenter: EventsPresenter

    // swiftlint:disable:next force_cast
    private var rootView: EventsScreenLayout { return view as! EventsScreenLayout }

    private var events = [Event]()



    init(facilityId: String, unitOfWork: UnitOfWork?) {
        self.presenter = Assembler.shared.resolver.resolve(
            EventsPresenter.self,
            arguments: facilityId, unitOfWork
        )!

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showPlaceholder() {
        DispatchQueue.main.async {
            self.rootView.tableView.showAnimatedSkeleton(
                transition: .crossDissolve(animationDuration)
            )
        }
    }

    func hidePlaceholder() {
        DispatchQueue.main.async {
            self.rootView.tableView.hideSkeleton(
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

    func setEvents(_ events: [Event]) {
        DispatchQueue.main.async {
            self.events = events
            self.rootView.tableView.reloadData()
        }
    }

    override func loadView() {
        view = EventsScreenLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
        unsubscribe()
    }

    private func setupTableView() {
        rootView.tableView.register(
            EventsTableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )

        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self

        rootView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        rootView.tableView.addSubview(rootView.refreshControl)

        rootView.tableView.isSkeletonable = true
        SkeletonAppearance.default.multilineCornerRadius = 5
    }

    @objc func refresh() {
        presenter.refresh()
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

// MARK: - UITableViewDataSource, UITableViewDelegate

extension EventsViewController: SkeletonTableViewDataSource, UITableViewDelegate {

    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! EventsTableViewCell

        let event = events[indexPath.row]
        cell.bind(event: event)

        return cell
    }

    func collectionSkeletonView(
        _ skeletonView: UITableView,
        cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        return cellIdentifier
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == events.count {
            presenter.endOfTableReached()
        }
    }

}
