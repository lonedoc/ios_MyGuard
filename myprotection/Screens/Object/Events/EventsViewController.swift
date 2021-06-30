//
//  EventsViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 05.04.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import SkeletonView

extension EventsViewController: EventsContract.View {

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

private let cellIdentifier = "eventsTableViewCell"
private let animationDuration = 0.5

class EventsViewController: UIViewController {

    private let presenter: EventsContract.Presenter
    private var rootView: EventsView { return view as! EventsView } // swiftlint:disable:this force_cast

    private var events = [Event]()

    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return formatter
    }()

    init(with presenter: EventsContract.Presenter) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = EventsView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        presenter.attach(view: self)
        presenter.viewDidLoad()
    }

    private func setupTableView() {
        rootView.tableView.register(EventsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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

        cell.eventDescription = event.description
        cell.zone = event.zone

        if let timestamp = event.timestamp {
            cell.timestamp = formatter.string(from: timestamp)
        } else {
            cell.timestamp = ""
        }

        cell.eventIcon = getIcon(by: event)
        cell.eventColor = getColor(by: event)

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

    private func getIcon(by event: Event) -> UIImage? {
        switch event.type {
        case 1, 2, 3, 77, 79, 85:
            return UIImage.assets(.alarmStatus)
        case 4:
            return UIImage.assets(.fireAlarm)
        case 5:
            return UIImage.assets(.malfunctionStatus)
        case 6, 8, 9, 66, 67:
            return UIImage.assets(.guardedStatus)
        case 10, 69, 68:
            return UIImage.assets(.notGuardedStatus)
        case 33, 81:
            return UIImage.assets(.battery)
        default:
            return UIImage.assets(.settings)
        }
    }

    private func getColor(by event: Event) -> UIColor? {
        switch event.type {
        case 1, 2, 3, 77, 79, 85:
            return .alarmStatusColor
        case 4:
            return .alarmStatusColor
        case 5:
            return .malfunctionStatusColor
        case 6, 8, 9, 66, 67:
            return .guardedStatusColor
        case 10, 69, 68:
            return .notGuardedStatusColor
        case 33:
            return .malfunctionStatusColor
        case 81:
            return .alarmStatusColor
        default:
            return .unknownStatusColor
        }
    }

}
