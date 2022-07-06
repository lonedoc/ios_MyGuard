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
        backgroundColor = .mainBackgroundColor

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        self.addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    // MARK: Views

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.rowHeight = 112
        tableView.backgroundColor = .mainBackgroundColor
        return tableView
    }()

    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primaryColor
        return refreshControl
    }()

    let sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage.assets(.sort),
            style: .plain,
            target: nil,
            action: nil
        )
        return button
    }()

}
