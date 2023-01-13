//
//  TestView.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.05.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation

class TestScreenLayout: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .black.withAlphaComponent(0.5)
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(tipLabel)
        containerView.addSubview(countDownLabel)
        containerView.addSubview(resetButton)
        containerView.addSubview(resetButtonTopBorder)
        containerView.addSubview(completeButton)
        containerView.addSubview(completeButtonTopBorder)
        addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
        
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        tipLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        tipLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        tipLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
        
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        completeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        completeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        completeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        completeButtonTopBorder.translatesAutoresizingMaskIntoConstraints = false
        completeButtonTopBorder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        completeButtonTopBorder.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        completeButtonTopBorder.bottomAnchor.constraint(equalTo: completeButton.topAnchor).isActive = true
        completeButtonTopBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        resetButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        resetButton.bottomAnchor.constraint(equalTo: completeButtonTopBorder.topAnchor).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        resetButtonTopBorder.translatesAutoresizingMaskIntoConstraints = false
        resetButtonTopBorder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        resetButtonTopBorder.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        resetButtonTopBorder.bottomAnchor.constraint(equalTo: resetButton.topAnchor).isActive = true
        resetButtonTopBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        countDownLabel.translatesAutoresizingMaskIntoConstraints = false
        countDownLabel.topAnchor.constraint(equalTo: tipLabel.bottomAnchor).isActive = true
        countDownLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        countDownLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        countDownLabel.bottomAnchor.constraint(equalTo: resetButtonTopBorder.topAnchor).isActive = true
    }
    
    // MARK: - Views
    
    let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(color: .alertDialogBackground)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.dialogTitle.font
        label.textColor = UIColor(color: .textContrast)
        label.text = "Testing".localized
        label.textAlignment = .center
        return label
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = TextStyle.caption3.font
        label.textColor = UIColor(color: .textSecondary)
        label.textAlignment = .center
        return label
    }()
    
    let countDownLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.font = TextStyle.display2.font
        label.textColor = UIColor(color: .accent)
        label.textAlignment = .center
        label.text = "0:00"
        return label
    }()
    
    let resetButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(UIColor(color: .accent), for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        button.setTitle("Reset".localized, for: .normal)
        return button
    }()
    
    var resetButtonTopBorder: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(color: .tabMenuDelimiter)
        return view
    }()
    
    let completeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(UIColor(color: .error), for: .normal)
        button.titleLabel?.font = TextStyle.paragraph.font
        button.setTitle("Complete".localized, for: .normal)
        return button
    }()
    
    var completeButtonTopBorder: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(color: .tabMenuDelimiter)
        return view
    }()
    
}
