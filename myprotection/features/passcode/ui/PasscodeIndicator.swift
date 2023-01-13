//
//  PasscodeIndicator.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.11.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

class PasscodeIndicator: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setIndicator(value: Int) {
        for (index, indicator) in indicators.enumerated() {
            indicator.backgroundColor = index >= value ?
                UIColor(color: .indicatorColor) :
                UIColor(color: .accent)
        }
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        indicators.forEach { indicator in
            indicatorRow.addArrangedSubview(indicator)
        }

        addSubview(indicatorRow)
    }

    private func setupConstraints() {
        indicatorRow.translatesAutoresizingMaskIntoConstraints = false
        indicatorRow.topAnchor.constraint(equalTo: topAnchor).isActive = true
        indicatorRow.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicatorRow.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        indicators.forEach { indicator in
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.widthAnchor.constraint(equalToConstant: 12).isActive = true
            indicator.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
    }

    // MARK: Views

    private let indicatorRow: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 24
        return stackView
    }()

    private let indicators: [UIView] = {
        var indicators = [UIView]()

        var index = 0
        while index < 4 {
            let view = UIView(frame: .zero)
            view.layer.cornerRadius = 6
            view.backgroundColor = UIColor(color: .indicatorColor)
            indicators.append(view)

            index += 1
        }

        return indicators
    }()

}
