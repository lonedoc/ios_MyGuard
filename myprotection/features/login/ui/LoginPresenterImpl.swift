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

extension LoginPresenterImpl: LoginPresenter {

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

    func didSelect(city: String) {
        view?.setCity(city)
        view?.setCompany("")

        selectedCity = city
        selectedCompany = nil

        let cities = getCities()
        let cityIndex = cities.firstIndex(of: city) ?? 0
        view?.selectCityPickerRow(cityIndex)

        let companiesInCity = getCompanyNames(by: city)
        view?.setCompanies(companiesInCity)
        view?.selectCompanyPickerRow(0)

        view?.setSubmitButtonEnabled(isReadyForSubmit())
    }

    func didSelect(company: String) {
        view?.setCompany(company)
        selectedCompany = companies.first { $0.city == selectedCity && $0.name == company }

        let companiesInCity = getCompanyNames(by: selectedCity ?? "")
        let companyIndex = companiesInCity.firstIndex(of: company) ?? 0
        view?.selectCompanyPickerRow(companyIndex)

        view?.setSubmitButtonEnabled(isReadyForSubmit())
    }

    func didChangePhone(value: String) {
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

    func didHitSubmitButton() {
        saveDataInCache()

        let communicationData = Assembler.shared.resolver.resolve(CommunicationData.self)!
        communicationData.setAddresses(selectedCompany?.ip ?? [])

        view?.openPasswordScreen()
    }

}

// MARK: -

class LoginPresenterImpl {

    private weak var view: LoginView?

    private let interactor: LoginInteractor
    private let disposeBag = DisposeBag()

    private var companies: [Company] = []
    private var selectedCity: String?
    private var selectedCompany: Company?
    private var phoneNumber: String?

    init(interactor: LoginInteractor) {
        self.interactor = interactor
    }

    private func loadCachedData() {
        if let company = interactor.getUserCompany() {
            selectedCity = company.city
            view?.setCity(company.city)

            selectedCompany = company
            view?.setCompany(company.name)
        }

        if let phone = interactor.getUserPhone() {
            let maskedPhone = PhoneMask().apply(to: phone)
            phoneNumber = maskedPhone
            view?.setPhoneNumber(maskedPhone)
        }
    }

    private func loadCompaniesData() {
        interactor.getCompanies(
            success: { [weak self] companies in
                self?.companies = companies
                self?.updateCachedData()
            },
            failure: { [weak self] error in
                let errorMessage = getErrorMessage(by: error)

                self?.view?.showAlertDialog(
                    title: "Error".localized,
                    message: errorMessage
                )
            }
        )
    }

    private func updateCachedData() {
        let cities = getCities()
        view?.setCities(cities)

        guard
            let city = selectedCity,
            let index = cities.firstIndex(of: city)
        else {
            selectedCity = nil
            selectedCompany = nil

            view?.setCity("")
            view?.setCompany("")
            view?.setCompanies([""])
            view?.selectCityPickerRow(0)
            view?.selectCompanyPickerRow(0)

            return
        }

        view?.selectCityPickerRow(index)

        let companiesInCity = getCompanyNames(by: city)
        view?.setCompanies(companiesInCity)

        guard
            let company = selectedCompany,
            let companyIndex = companiesInCity.firstIndex(of: company.name)
        else {
            selectedCompany = nil

            view?.setCompany("")
            view?.selectCompanyPickerRow(0)

            return
        }

        view?.selectCompanyPickerRow(companyIndex)
    }

    private func getCities() -> [String] {
        var cities = companies
            .map { $0.city }
            .distinct { $0 == $1 }
            .sorted()

        cities.insert("", at: 0)
        return cities
    }

    private func getCompanyNames(by city: String) -> [String] {
        var companiesInCity = companies
            .filter { $0.city == city }
            .map { $0.name }
            .sorted()

        companiesInCity.insert("", at: 0)
        return companiesInCity
    }

    private func saveDataInCache() {
        if let company = selectedCompany {
            interactor.saveUserCompany(company)
        }

        if let phone = phoneNumber {
            interactor.saveUserPhone(phone)
        }
    }

    private func isReadyForSubmit() -> Bool {
        let companyIsSelected = selectedCompany != nil
        let phoneNumberIsValid = PhoneMask().validate(phoneNumber ?? "")

        return companyIsSelected && phoneNumberIsValid
    }

    private func extractDigits(text: String) -> String {
        return text.filter { isDigit($0) }
    }

    private func isDigit(_ character: Character) -> Bool {
        return "0123456789".contains(character)
    }

}
