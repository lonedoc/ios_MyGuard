//
//  ObjectsPresenter.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RubegProtocol_v2_0
import RxSwift

private let driverPort: Int32 = 8301
private let attemptsCount = 2
private let pollingInterval: Double = 10

class FacilitiesPresenterImpl: FacilitiesPresenter {

    private var view: FacilitiesView?
    private let interactor: FacilitiesInteractor
    private let communicationData: CommunicationData

    private var facilities = [Facility]()
    private var sorting: FacilitiesSorting = .byStatus
    private var comparator: FacilitiesComparator = StatusFirstFacilitiesComparator()

    private var disposeBag = DisposeBag()

    private var timer: Timer?

    init(interactor: FacilitiesInteractor, communicationData: CommunicationData) {
        self.interactor = interactor
        self.communicationData = communicationData
    }

    func attach(view: FacilitiesView) {
        self.view = view
    }

    func viewDidLoad() {
        guard let cachedGuardService = interactor.getGuardService() else {
            return
        }

        interactor.getAddresses(cityName: cachedGuardService.city, guardServiceName: cachedGuardService.name)
            .subscribe(
                onNext: { [weak self] hosts in
                    if hosts.isEmpty {
                        return
                    }

                    let addresses = InetAddress.createAll(hosts: hosts, port: driverPort)

                    self?.communicationData.setAddresses(addresses)

                    let guardService = GuardService(
                        city: cachedGuardService.city,
                        name: cachedGuardService.name,
                        hosts: hosts,
                        displayedName: cachedGuardService.displayedName,
                        phoneNumber: cachedGuardService.phoneNumber
                    )

                    self?.interactor.saveGuardService(guardService)
                },
                onError: { _ in }
            )
            .disposed(by: disposeBag)
    }

    func viewWillAppear() {
        if facilities.count == 0 {
            view?.showPlaceholder()
        }

        fetchFacilities()
        startPolling()
    }

    func viewWillDisappear() {
        stopPolling()
    }

    func refresh() {
        fetchFacilities(userInitiated: true)

        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .seconds(1)) {
            self.view?.hideRefresher()
        }
    }

    func phoneButtonTapped() {
        callGuardService()
    }

    func phoneCallFailed() {
        view?.showAlertDialog(
            title: "Error".localized,
            message: "The number cannot be dialed".localized
        )
    }

    func sortingChanged(_ newSorting: FacilitiesSorting) {
        if sorting == newSorting {
            return
        }

        sorting = newSorting
        comparator = getComparator(by: sorting)
        facilities.sort(by: comparator.compare(_:_:))

        view?.updateData(facilities: facilities)
    }

    func facilitySelected(_ facility: Facility) {
        view?.openFacilityScreen(facility: facility)
    }

    private func startPolling() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: pollingInterval,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopPolling() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func tick() {
        fetchFacilities()
    }

    private func fetchFacilities(userInitiated: Bool = false) {
        interactor.getFacilities(userInitiated: userInitiated)
            .subscribe(
                onNext: { [weak self] response in
                    self?.update(facilities: response.facilities)

                    if let phoneNumber = response.guardServicePhoneNumber {
                        self?.update(guardServicePhoneNumber: phoneNumber)
                    }
                },
                onError: { [weak self] error in
                    if !userInitiated {
                        return
                    }

                    let errorMessage = getErrorMessage(by: error)

                    self?.view?.showAlertDialog(
                        title: "Error".localized,
                        message: errorMessage
                    )
                }
            )
            .disposed(by: disposeBag)
    }

    private func update(facilities: [Facility]) {
        let sorted = facilities.sorted(by: comparator.compare(_:_:))
        self.facilities = sorted

        view?.updateData(facilities: self.facilities)
        view?.hidePlaceholder()
        view?.hideRefresher()
    }

    private func update(guardServicePhoneNumber: String) {
        guard let cachedGuardService = interactor.getGuardService() else {
            return
        }

        let guardService = GuardService(
            city: cachedGuardService.city,
            name: cachedGuardService.name,
            hosts: cachedGuardService.hosts,
            displayedName: cachedGuardService.displayedName,
            phoneNumber: guardServicePhoneNumber
        )

        interactor.saveGuardService(guardService)
    }

    private func getComparator(by sorting: FacilitiesSorting) -> FacilitiesComparator {
        switch sorting {
        case .byStatus:
            return StatusFirstFacilitiesComparator()
        case .byNameAscending:
            return NameFirstFacilitiesComparator(ascending: true)
        case .byNameDescending:
            return NameFirstFacilitiesComparator(ascending: false)
        case .byAddressAscending:
            return AddressFirstFacilitiesComparator(ascending: true)
        case .byAddressDescending:
            return AddressFirstFacilitiesComparator(ascending: false)
        }
    }

    private func callGuardService() {
        guard let phoneNumber = interactor.getGuardService()?.phoneNumber else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "Phone number not found".localized
            )
            return
        }

        guard let url = URL(string: "tel://+7\(phoneNumber)") else {
            view?.showAlertDialog(
                title: "Error".localized,
                message: "The phone number cannot be called".localized
            )
            return
        }

        view?.call(url)
    }

}
