//
//  SolidButton.swift
//  myprotection
//
//  Created by Rubeg NPO on 23.11.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

class SolidButton: UIButton {

    var backgroundColorNormal: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }

    var backgroundColorHighlighted: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }

    var backgroundColorDisabled: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }

    override open var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    override open var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateBackgroundColor() {
        if !isEnabled {
            backgroundColor = backgroundColorDisabled
            return
        }

        backgroundColor = isHighlighted ?
            backgroundColorHighlighted :
            backgroundColorNormal
    }

}
