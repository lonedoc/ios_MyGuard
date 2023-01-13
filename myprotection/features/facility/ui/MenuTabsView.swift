//
//  MenuTabsView.swift
//  myprotection
//
//  Created by Rubeg NPO on 06.12.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

private let cellId = "tabCellId"

class MenuTabsView: UIView {

//    var isSizeToFitCellsNeeded: Bool = false {
//        didSet {
//            collectionView.reloadData()
//        }
//    }

    var titles: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var menuDelegate: MenuBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear

        collectionView.register(TabItemCell.self, forCellWithReuseIdentifier: cellId)

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }

    // MARK: Views

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension MenuTabsView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TabItemCell {
            cell.titleLabel.text = titles[indexPath.item]
            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let leftPadding = 16
        let rightPadding = 16
        let horizontalGaps = (titles.count - 1) * 8
        let totalOffset = leftPadding + rightPadding + horizontalGaps
        let availableSpace = frame.width - CGFloat(totalOffset)

        let estimatedTotalSize = titles.reduce(0) { acc, title in
            let estimatedRect = NSString(string: title).boundingRect(
                with: CGSize(width: frame.width, height: frame.height),
                options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
                attributes: [NSAttributedString.Key.font: TextStyle.caption1.font],
                context: nil
            )

            return acc + estimatedRect.size.width + 16
        }

        let ratio = estimatedTotalSize < availableSpace ?
            availableSpace / estimatedTotalSize :
            1.0

        let title = titles[indexPath.item]

        let estimatedRect = NSString(string: title).boundingRect(
            with: CGSize(width: frame.width, height: frame.height),
            options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
            attributes: [NSAttributedString.Key.font: TextStyle.caption1.font],
            context: nil
        )

        let itemWidth = (estimatedRect.size.width + 16) * ratio

        return CGSize(width: itemWidth, height: 52)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collecitionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = Int(indexPath.item)
        menuDelegate?.menuBarDidSelectItemAt(menu: self, index: index)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }

}
