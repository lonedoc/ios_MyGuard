//
//  RadioButton.swift
//  myprotection
//
//  Created by Rubeg NPO on 22.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

protocol CheckBox: UIView {
    var isSelected: Bool { get set }
    var value: Int { get }
    var values: [Int] { get }
    var delegate: CheckBoxDelegate? { get set }
    func select(value: Int?)
}

extension CheckBox {
    func select() {
        select(value: nil)
    }
}

protocol CheckBoxDelegate: AnyObject {
    func stateChanged(sender: CheckBox)
}

enum CheckBoxState {
    case selected, notSelected
}
