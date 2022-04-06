//
//  CancelAlarmDialog.swift
//  myprotection
//
//  Created by Rubeg NPO on 30.03.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

protocol CancelAlarmDialogDelegate: AnyObject {
    func didSelectPasscode(passcode: String)
}

class CancelAlarmDialogController: UIViewController, RadioButtonDelegate {

    private let passcodes: [String]

    // swiftlint:disable:next force_cast
    private var rootView: CancelAlarmDialogLayout { return view as! CancelAlarmDialogLayout }

    init(passcodes: [String]) {
        self.passcodes = passcodes
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: CancelAlarmDialogDelegate?

    override func loadView() {
        view = CancelAlarmDialogLayout(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        rootView.radioButton0.text = passcodes[0]
        rootView.radioButton1.text = passcodes[1]
        rootView.radioButton2.text = passcodes[2]
        rootView.radioButton3.text = passcodes[3]

        rootView.radioButton0.delegate = self
        rootView.radioButton1.delegate = self
        rootView.radioButton2.delegate = self
        rootView.radioButton3.delegate = self

        rootView.cancelButton.addTarget(
            self,
            action: #selector(didTapCancelButton),
            for: .touchUpInside
        )

        rootView.proceedButton.addTarget(
            self,
            action: #selector(didTapProceedButton),
            for: .touchUpInside
        )
    }

    @objc private func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func didTapProceedButton() {
        let passcodeIndex: Int

        if rootView.radioButton1.isChecked {
            passcodeIndex = 1
        } else if rootView.radioButton2.isChecked {
            passcodeIndex = 2
        } else if rootView.radioButton3.isChecked {
            passcodeIndex = 3
        } else {
            passcodeIndex = 0
        }

        delegate?.didSelectPasscode(passcode: passcodes[passcodeIndex])

        self.dismiss(animated: true, completion: nil)
    }

    func didCheckRadioButton(_ radioButton: RadioButton) { 
        let radioButtons = [
            rootView.radioButton0,
            rootView.radioButton1,
            rootView.radioButton2,
            rootView.radioButton3
        ]

        defer {
            rootView.proceedButton.isEnabled = true
        }

        if (radioButtons.allSatisfy { !$0.isChecked }) {
            radioButton.isChecked = true
            return
        }

        if radioButton.isChecked {
            radioButtons.forEach {
                if $0 != radioButton {
                    $0.isChecked = false
                }
            }
        }
    }

}
