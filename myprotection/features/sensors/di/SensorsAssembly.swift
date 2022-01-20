//
//  SensorsAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

class SensorsAssembly: Assembly {

    func assemble(container: Container) {
        container.register(SensorsApi.self) { resolver in
            let communicationData = resolver.resolve(CommunicationData.self)!
            return UdpSensorsApi(communicationData: communicationData)
        }

        container.register(SensorsInteractor.self) { resolver in
            let sensorsApi = resolver.resolve(SensorsApi.self)!
            return SensorsInteractor(sensorsApi: sensorsApi)
        }

        container.register(SensorsPresenter.self) { (resolver, facilityId: String) in
            let interactor = resolver.resolve(SensorsInteractor.self)!
            return SensorsPresenterImpl(facilityid: facilityId, interactor: interactor)
        }
    }

}
