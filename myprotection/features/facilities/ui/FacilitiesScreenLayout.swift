//
//  ObjectsView.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

class FacilitiesScreenLayout: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = UIColor(color: .backgroundPrimary)

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        self.addSubview(sortingSegmentedControl)
        self.addSubview(tableView)
    }

    // swiftlint:disable line_length
    private func setupConstraints() {
        sortingSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        sortingSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        sortingSegmentedControl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        sortingSegmentedControl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: sortingSegmentedControl.bottomAnchor, constant: 16).isActive = true
        tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    // swiftlint:enable line_length

    // MARK: Views

    let sortingSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            "By status".localized,
            "By title".localized,
            "By address".localized
        ])

        segmentedControl.backgroundColor = UIColor(color: .segmentedControlBackground)

        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor(color: .selectedSegmentBackground)
        } else {
            segmentedControl.tintColor = UIColor(color: .selectedSegmentBackground)
        }

        return segmentedControl
    }()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.rowHeight = 128
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        tableView.backgroundColor = UIColor(color: .backgroundPrimary)

        return tableView
    }()

    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(color: .accent)
        return refreshControl
    }()

    let phoneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage.assets(.phone),
            style: .plain,
            target: nil,
            action: nil
        )
        return button
    }()

}
