//
//  EventsView.swift
//  myprotection
//
//  Created by Rubeg NPO on 05.04.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

class EventsScreenLayout: UIView {

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
        addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    // MARK: - Views

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.rowHeight = 104
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 24, right: 0)
        tableView.backgroundColor = UIColor(color: .backgroundPrimary)
        return tableView
    }()

    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(color: .accent)
        return refreshControl
    }()

}
