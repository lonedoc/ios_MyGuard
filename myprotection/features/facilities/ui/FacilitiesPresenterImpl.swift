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

extension FacilitiesPresenterImpl: FacilitiesPresenter {

    func attach(view: FacilitiesView) {
        self.view = view
    }

    func viewDidLoad() {
        guard let cachedGuardService = interactor.getGuardService() else {
            return
        }

        interactor.getAddresses(cityName: cachedGuardService.city, guardServiceName: cachedGuardService.name)
            .subscribe(
                onNext: { [weak self] addresses in
                    self?.communicationData.setAddresses(addresses)

                    let guardService = GuardService(
                        city: cachedGuardService.city,
                        name: cachedGuardService.name,
                        ip: addresses,
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

    func sortButtonTapped() {
        let sortingOptions = getSortingOptions()
        view?.showSortingDialog(options: sortingOptions, defaultValue: sorting.rawValue)
    }

    func sortingChanged(_ sortingValue: Int) {
        guard
            let newSorting = FacilitiesSorting(rawValue: sortingValue),
            sorting != newSorting
        else {
            return
        }

        sorting = newSorting
        comparator = getComparator(by: sorting)
        facilities.sort(by: comparator.compare(_:_:))

        view?.updateData(facilities: facilities)
    }

    func objectSelected(_ facility: Facility) {
        view?.openObjectScreen(facility: facility)
    }

}

// MARK: -

private let attemptsCount = 2
private let pollingInterval: Double = 10

class FacilitiesPresenterImpl {

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
                onNext: { [weak self] data in
                    self?.updateFacilities(data)
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

    private func updateFacilities(_ data: [Facility]) {
        let sorted = data.sorted(by: comparator.compare(_:_:))
        facilities = sorted

        view?.updateData(facilities: facilities)
        view?.hidePlaceholder()
        view?.hideRefresher()
    }

    private func getSortingOptions() -> [SortingOption] {
        return [
            SortingOption(
                title: "By name".localized,
                values: [
                    FacilitiesSorting.byNameAscending.rawValue,
                    FacilitiesSorting.byNameDescending.rawValue
                ]
            ),
            SortingOption(
                title: "By address".localized,
                values: [
                    FacilitiesSorting.byAddressAscending.rawValue,
                    FacilitiesSorting.byAddressDescending.rawValue
                ]
            ),
            SortingOption(
                title: "By status".localized,
                values: [FacilitiesSorting.byStatus.rawValue]
            )
        ]
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

}
