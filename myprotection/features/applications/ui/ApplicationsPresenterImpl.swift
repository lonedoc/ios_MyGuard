//
//  ApplicationsPresenterImpl.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.05.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import RubegProtocol_v2_0
import RxSwift
import Swinject

extension ApplicationsPresenterImpl: ApplicationsPresenter {

    func attach(view: ApplicationsView) {
        self.view = view
    }

    func viewDidLoad() {
        DispatchQueue.global(qos: .background).async {
            self.loadPredefinedApplications()
        }
    }

    func didSelect(application: String) {
        applicationText = application

        let applicationSelected = application != "Custom application".localized
        let isSubmitButtonInabled = isSubmitButtonEnabled(applicationText: application, date: timestamp)

//        view?.setIsApplicationTextFieldEnabled(!applicationSelected)
        view?.setSelectedApplication(application)
        view?.setApplicationText(applicationSelected ? application : "")
        view?.setIsSubmitButtonEnabled(isSubmitButtonInabled)
    }

    func didChangeApplicationText(applicationText: String) {
        self.applicationText = applicationText

        let isSubmitButtonInabled = isSubmitButtonEnabled(applicationText: applicationText, date: timestamp)
        view?.setIsSubmitButtonEnabled(isSubmitButtonInabled)
    }

    func didSelect(dateTime: Date) {
        self.timestamp = dateTime

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let text = formatter.string(from: dateTime)
        let isSubmitButtonInabled = isSubmitButtonEnabled(applicationText: applicationText, date: timestamp)

        view?.setDateTimeText(text)
        view?.setIsSubmitButtonEnabled(isSubmitButtonInabled)
    }

    func didPushSubmitButton() {
        DispatchQueue.global(qos: .background).async {
            self.sendApplication()
        }
    }

}

// MARK: -

class ApplicationsPresenterImpl {

    private weak var view: ApplicationsView?

    private let interactor: ApplicationsInteractor
    private let disposeBag = DisposeBag()

    private let facilityId: String
    private var applicationText: String?
    private var timestamp: Date?

    init(facilityId: String, interactor: ApplicationsInteractor) {
        self.facilityId = facilityId
        self.interactor = interactor
    }

    private func loadPredefinedApplications() {
        interactor.getPredefinedApplications()
            .subscribe(
                onNext: { [weak self] applications in
                    self?.view?.setApplications(["Custom application".localized] + applications)
                },
                onError: { [weak self] error in
                    let errorMessage = getErrorMessage(by: error)

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage
                    )
                }
            )
            .disposed(by: disposeBag)
    }

    private func sendApplication() {
        guard let text = applicationText else { return }
        guard let timestamp = timestamp else { return }

        interactor.sendApplication(facilityId: facilityId, text: text, timestamp: timestamp)
            .subscribe(
                onNext: { [weak self] success in
                    if success {
                        self?.view?.goBack()
                    } else {
                        self?.view?.showAlertDialog(
                            title: "Error".localized,
                            message: "Could not send application".localized
                        )
                    }
                },
                onError: { [weak self] error in
                    let errorMessage = getErrorMessage(by: error)

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage
                    )
                }
            )
            .disposed(by: disposeBag)
    }

    private func isSubmitButtonEnabled(applicationText: String?, date: Date?) -> Bool {
        guard let applicationText = applicationText else {
            return false
        }

        return !applicationText.isEmpty && date != nil
    }

}
