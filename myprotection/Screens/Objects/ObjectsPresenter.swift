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

extension ObjectsPresenter: ObjectsContract.Presenter {

    func attach(view: ObjectsContract.View) {
        self.view = view
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
            let newSorting = ObjectsSorting(rawValue: sortingValue),
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
        view?.openObjectScreen(facility: facility, communicationData: communicationData)
    }

}

// MARK: -

private let attemptsCount = 2
private let pollingInterval = 15

class ObjectsPresenter {

    private var view: ObjectsContract.View?
    private var objectsGateway: ObjectsGateway

    private let communicationData: CommunicationData

    private var facilities = [Facility]()
    private var sorting: ObjectsSorting = .byStatus
    private var comparator: ObjectsComparator = StatusFirstObjectsComparator()

    private var disposeBag = DisposeBag()

    private var timer: Timer?

    init(objectsGateway: ObjectsGateway, communicationData: CommunicationData) {
        self.objectsGateway = objectsGateway
        self.communicationData = communicationData
    }

    private func startPolling() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 15,
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
        guard let token = communicationData.token else {
            return
        }

        makeFacilitiesRequest(
            address: communicationData.address,
            token: token,
            userInitiated: userInitiated,
            attempts: userInitiated ? attemptsCount : 1
        )
    }

    private func makeFacilitiesRequest(
        address: InetAddress,
        token: String,
        userInitiated: Bool = false,
        attempts: Int
    ) {
        objectsGateway.getObjects(address: address, token: token)
            .subscribe(
                onNext: { [weak self, objectsGateway] data in
                    self?.updateFacilities(data)
                    objectsGateway.close()
                },
                onError: { [weak self] error in
                    self?.communicationData.invalidateAddress()

                    if !userInitiated {
                        self?.objectsGateway.close()
                        return
                    }

                    if attempts - 1 > 0 {
                        self?.makeFacilitiesRequest(
                            address: address,
                            token: token,
                            userInitiated: userInitiated,
                            attempts: attempts - 1
                        )
                        return
                    }

                    defer { self?.objectsGateway.close() }

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
                    ObjectsSorting.byNameAscending.rawValue,
                    ObjectsSorting.byNameDescending.rawValue
                ]
            ),
            SortingOption(
                title: "By address".localized,
                values: [
                    ObjectsSorting.byAddressAscending.rawValue,
                    ObjectsSorting.byAddressDescending.rawValue
                ]
            ),
            SortingOption(
                title: "By status".localized,
                values: [ObjectsSorting.byStatus.rawValue]
            )
        ]
    }

    private func getComparator(by sorting: ObjectsSorting) -> ObjectsComparator {
        switch sorting {
        case .byStatus:
            return StatusFirstObjectsComparator()
        case .byNameAscending:
            return NameFirstObjectsComparator(ascending: true)
        case .byNameDescending:
            return NameFirstObjectsComparator(ascending: false)
        case .byAddressAscending:
            return AddressFirstObjectsComparator(ascending: true)
        case .byAddressDescending:
            return AddressFirstObjectsComparator(ascending: false)
        }
    }

}
