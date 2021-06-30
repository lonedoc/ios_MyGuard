//
//  SortingViewController.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

struct SortingOption {
    let title: String
    let values: [Int]
}

protocol SortingDialogDelegate: AnyObject {
    func sortingChanged(sorting: Int)
}

class SortingDialogController: UIViewController {

    private var rootView: SortingDialogView { return view as! SortingDialogView } // swiftlint:disable:this force_cast
    private var radioGroup = RadioGroup()

    private var options = [SortingOption]()
    private var defaultValue = 0

    weak var delegate: SortingDialogDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = SortingDialogView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        options.forEach { option in
            switch option.values.count {
            case 1:
                rootView.addOption(title: option.title, value: option.values[0])
            case 2:
                rootView.addOption(title: option.title, values: option.values)
            default:
                return
            }
        }

        radioGroup.append(contentsOf: rootView.radioButtons)
        radioGroup.setDefault(value: defaultValue)

        radioGroup.delegate = self

        rootView.closeButton.addTarget(
            self,
            action: #selector(closeButtonTapped),
            for: .touchUpInside
        )

        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        swipeRecognizer.direction = .down
        rootView.container.addGestureRecognizer(swipeRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareToSlideIn()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slideIn()
    }

    @objc func closeButtonTapped() {
        slideOut {
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func prepareToSlideIn() {
        rootView.container.alpha = 0
    }

    private func slideIn() {
        let origin = rootView.container.frame.origin
        let size = rootView.container.frame.size

        rootView.container.frame = CGRect(
            x: origin.x,
            y: origin.y + size.height,
            width: size.width,
            height: size.height
        )

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn,
            animations: {
                self.rootView.container.alpha = 1
                self.rootView.container.frame = CGRect(
                    x: origin.x,
                    y: origin.y,
                    width: size.width,
                    height: size.height
                )
            }
        )
    }

    private func slideOut(completion: @escaping () -> Void) {
        let origin = rootView.container.frame.origin
        let size = rootView.container.frame.size

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn,
            animations: {
                self.rootView.container.alpha = 0
                self.rootView.container.frame = CGRect(
                    x: origin.x,
                    y: origin.y + size.height,
                    width: size.width,
                    height: size.height
                )
            },
            completion: { _ in
                completion()
            }
        )
    }

    func addOption(_ option: SortingOption) {
        options.append(option)
    }

    func setDefault(value: Int) {
        defaultValue = value
    }

}

extension SortingDialogController: RadioGroupDelegate {

    func valueChanged(value: Int) {
        delegate?.sortingChanged(sorting: value)
    }

}
