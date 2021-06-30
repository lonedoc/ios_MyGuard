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

extension LoginPresenter: LoginContract.Presenter {

    func attach(view: LoginContract.View) {
        self.view = view
    }

    func viewDidLoad() {
        DispatchQueue.global(qos: .background).async {
            self.loadCachedData()
            self.loadCompaniesData(attempts: 5)

            self.view?.setSubmitButtonEnabled(self.isReadyForSubmit())
        }
    }

    func didSelect(city: String) {
        view?.setCity(city)
        view?.setCompany("")

        selectedCity = city
        selectedCompany = nil

        let companiesInCity = getCompanyNames(by: city)
        view?.setCompanies(companiesInCity)
        view?.selectCompanyPickerRow(0)

        view?.setSubmitButtonEnabled(isReadyForSubmit())
    }

    func didSelect(company: String) {
        view?.setCompany(company)
        selectedCompany = companies.first { $0.city == selectedCity && $0.name == company }
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
        view?.openPasswordScreen(ipAddresses: selectedCompany?.ip ?? [], phone: phoneNumber ?? "")
    }

    func didHitRetryButton() {
        currentIpIndex += 1
    }

}

// MARK: -

private let ipAddresses = ["94.177.183.4", "194.125.255.105"]
private let port: Int32 = 8300

class LoginPresenter {

    private weak var view: LoginContract.View?
    private let appDataRepository: AppDataRepository
    private let companiesGateway: CompaniesGateway

    private let communicationData: CommunicationData

    private var companies: [Company] = []
    private var selectedCity: String?
    private var selectedCompany: Company?
    private var phoneNumber: String?

    private var currentIpIndex = 0
    private let disposeBag = DisposeBag()

    init(appDataRepository: AppDataRepository, companiesGateway: CompaniesGateway) {
        self.appDataRepository = appDataRepository
        self.companiesGateway = companiesGateway

        let addresses = ipAddresses.compactMap { try? InetAddress.create(ip: $0, port: port) }

        // swiftlint:disable:next identifier_name
        guard let cd = try? CommunicationData(addresses: addresses, token: nil) else {
            fatalError("Could not get ip addresses")
        }

        communicationData = cd
    }

    private func loadCachedData() {
        if let company = appDataRepository.getCompany() {
            selectedCity = company.city
            view?.setCity(company.city)

            selectedCompany = company
            view?.setCompany(company.name)
        }

        if let phone = appDataRepository.getPhone() {
            let maskedPhone = PhoneMask().apply(to: phone)
            phoneNumber = maskedPhone
            view?.setPhoneNumber(maskedPhone)
        }
    }

    private func loadCompaniesData(attempts: Int = 5) {
        if attempts == 0 {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Service is not available".localized
            )
            return
        }

        fetchCompaniesData(address: communicationData.address, attempts: attempts)
    }

    private func fetchCompaniesData(address: InetAddress, attempts: Int) {
        companiesGateway.getCompanies(address: address)
            .subscribe(
                onNext: { [weak self] companiesData in
                    self?.companiesGateway.close()
                    self?.companies = companiesData
                    self?.updateCachedData()
                },
                onError: { [weak self] error in
                    defer { self?.companiesGateway.close() }

                    if let error = error as? CommunicationError, error.type == .serverError {
                        self?.communicationData.invalidateAddress()
                        self?.loadCompaniesData(attempts: attempts - 1)
                        return
                    }

                    guard let errorMessage = self?.getErrorMessage(by: error) else {
                        return
                    }

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage
                    )
                }
            )
            .disposed(by: disposeBag)
    }

    private func getErrorMessage(by error: Error) -> String {
        guard let error = error as? CommunicationError else {
            return "Unknown error".localized
        }

        switch error.type {
        case .socketError:
            return "Unknown error".localized // TODO: Make specific error message
        case .serverError:
            return "Server not responding".localized
        case .internalServerError:
            return "The operation could not be performed".localized
        case .parseError:
            return "Unable to read server response".localized
        case .authError:
            return "Wrong password".localized
        }
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
            let companyIndex = (companiesInCity.firstIndex { $0 == company.name })
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
            appDataRepository.set(company: company)
        }

        if let phone = phoneNumber {
            appDataRepository.set(phone: phone)
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
