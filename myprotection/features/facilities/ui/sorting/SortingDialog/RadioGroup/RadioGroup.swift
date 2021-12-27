//
//  RadioGroup.swift
//  myprotection
//
//  Created by Rubeg NPO on 23.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol RadioGroupDelegate: AnyObject {
    func valueChanged(value: Int)
}

class RadioGroup: CheckBoxDelegate {

    private var radioButtons = [CheckBox]()

    weak var delegate: RadioGroupDelegate?

    init() {}

    init(radioButtons: [CheckBox]) {
        self.radioButtons.append(contentsOf: radioButtons)

        self.radioButtons.forEach {
            $0.delegate = self
        }
    }

    func append(_ radioButton: CheckBox) {
        radioButtons.append(radioButton)
        radioButton.delegate = self
    }

    func append(contentsOf collection: [CheckBox]) {
        radioButtons.append(contentsOf: collection)
        collection.forEach { $0.delegate = self }
    }

    func stateChanged(sender: CheckBox) {
        if sender.isSelected {
            delegate?.valueChanged(value: sender.value)

            radioButtons
                .filter { $0.value != sender.value && $0.isSelected }
                .forEach { $0.isSelected = false }

            return
        }

        if (radioButtons.allSatisfy { !$0.isSelected }) {
            sender.isSelected = true
        }
    }

    func setDefault(value: Int) {
        radioButtons.first { $0.values.contains(value) }?.select(value: value)
    }

}
