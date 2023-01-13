//
//  LoginPresenter.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 11/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation
import RubegProtocol_v2_0
import RxSwift
import Swinject

private let driverPort: Int32 = 8301

class LoginPresenterImpl : LoginPresenter {

    private weak var view: LoginView?

    private let interactor: LoginInteractor
    private let disposeBag = DisposeBag()

    private var guardServices: [GuardService] = []
    private var selectedCity: String?
    private var selectedGuardService: GuardService?
    private var phoneNumber: String?

    init(interactor: LoginInteractor) {
        self.interactor = interactor
    }

    func attach(view: LoginView) {
        self.view = view
    }

    func viewDidLoad() {
        DispatchQueue.global(qos: .background).async {
            self.loadCachedData()
            self.loadCompaniesData()

            self.view?.setSubmitButtonEnabled(self.isReadyForSubmit())
        }
    }

    func citySelected(_ city: String) {
        view?.setCity(city)
        view?.setGuardService("")

        selectedCity = city
        selectedGuardService = nil

        let cities = getCities()
        let cityIndex = cities.firstIndex(of: city) ?? 0
        view?.selectCityPickerRow(cityIndex)

        let guardServicesInCity = getGuardServicesNames(by: city)
        view?.setGuardServices(guardServicesInCity)
        view?.selectGuardServicePickerRow(0)

        view?.setSubmitButtonEnabled(isReadyForSubmit())
    }

    func guardServiceSelected(_ guardService: String) {
        view?.setGuardService(guardService)
        selectedGuardService = guardServices.first { $0.city == selectedCity && $0.name == guardService }

        let guardServicesInCity = getGuardServicesNames(by: selectedCity ?? "")
        let companyIndex = guardServicesInCity.firstIndex(of: guardService) ?? 0
        view?.selectGuardServicePickerRow(companyIndex)

        view?.setSubmitButtonEnabled(isReadyForSubmit())
    }

    func phoneNumberChanged(_ value: String) {
        let phoneMask = PhoneMask()

        if phoneMask.validatePart(value) {
            phoneNumber = value
            view?.setPhoneNumber(value)
        } else {
            let formattedValue = phoneMask.apply(to: value)
            phoneNumber = formattedValue
            view?.setPhoneNumber(formattedValue)
        }

        view?.setSubmitButtonEnabled(isReadyForSubmit())
    }

    func submitButtonTapped() {
        saveDataInCache()

        let communicationData = Assembler.shared.resolver.resolve(CommunicationData.self)!
        let addresses = InetAddress.createAll(hosts: selectedGuardService?.hosts ?? [], port: driverPort)
        communicationData.setAddresses(addresses)

        view?.openPasswordScreen()
    }

    private func loadCachedData() {
        if let guardService = interactor.getUserGuardService() {
            selectedCity = guardService.city
            view?.setCity(guardService.city)

            selectedGuardService = guardService
            view?.setGuardService(guardService.name)
        }

        if let phone = interactor.getUserPhone() {
            let maskedPhone = PhoneMask().apply(to: phone)
            phoneNumber = maskedPhone
            view?.setPhoneNumber(maskedPhone)
        }
    }

    private func loadCompaniesData() {
        interactor.getGuardServices()
            .subscribe(
                onNext: { [weak self] guardServices in
                    self?.guardServices = guardServices
                    self?.updateCachedData()
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

    private func updateCachedData() {
        let cities = getCities()
        view?.setCities(cities)

        guard
            let city = selectedCity,
            let index = cities.firstIndex(of: city)
        else {
            selectedCity = nil
            selectedGuardService = nil

            view?.setCity("")
            view?.setGuardService("")
            view?.setGuardServices([""])
            view?.selectCityPickerRow(0)
            view?.selectGuardServicePickerRow(0)

            return
        }

        view?.selectCityPickerRow(index)

        let guardServicesInCity = getGuardServicesNames(by: city)
        view?.setGuardServices(guardServicesInCity)

        guard
            let guardService = selectedGuardService,
            let companyIndex = guardServicesInCity.firstIndex(of: guardService.name)
        else {
            selectedGuardService = nil

            view?.setGuardService("")
            view?.selectGuardServicePickerRow(0)

            return
        }

        view?.selectGuardServicePickerRow(companyIndex)
    }

    private func getCities() -> [String] {
        var cities = guardServices
            .map { $0.city }
            .distinct { $0 == $1 }
            .sorted()

        cities.insert("", at: 0)
        return cities
    }

    private func getGuardServicesNames(by city: String) -> [String] {
        var guardServicesInCity = guardServices
            .filter { $0.city == city }
            .map { $0.name }
            .sorted()

        guardServicesInCity.insert("", at: 0)
        return guardServicesInCity
    }

    private func saveDataInCache() {
        if let guardService = selectedGuardService {
            interactor.saveUserGuardService(guardService)
        }

        if let phone = phoneNumber {
            interactor.saveUserPhone(phone)
        }
    }

    private func isReadyForSubmit() -> Bool {
        let isGuardServiceSelected = selectedGuardService != nil
        let phoneNumberIsValid = PhoneMask().validate(phoneNumber ?? "")

        return isGuardServiceSelected && phoneNumberIsValid
    }

    private func extractDigits(text: String) -> String {
        return text.filter { isDigit($0) }
    }

    private func isDigit(_ character: Character) -> Bool {
        return "0123456789".contains(character)
    }

}
