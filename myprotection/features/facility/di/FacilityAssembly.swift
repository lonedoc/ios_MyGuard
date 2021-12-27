//
//  ObjectAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 22.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

class FacilityAssembly: Assembly {

    func assemble(container: Container) {
        container.register(FacilityInteractor.self) { resolver in
            let facilitiesApi = resolver.resolve(FacilitiesApi.self)!
            return FacilityInteractor(facilitiesApi: facilitiesApi)
        }

        container.register(FacilityPresenter.self) { (resolver, facility: Facility) in
            let interactor = resolver.resolve(FacilityInteractor.self)!
            return FacilityPresenterImpl(facility: facility, interactor: interactor)
        }
    }

}
