//
//  TestAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 22.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

class TestAssembly: Assembly {

    func assemble(container: Container) {
        container.register(TestApi.self) { resolver in
            let communicationData = resolver.resolve(CommunicationData.self)!
            return UdpTestApi(communicationData: communicationData)
        }

        container.register(TestInteractor.self) { resolver in
            let testApi = resolver.resolve(TestApi.self)!
            return TestInteractor(testApi: testApi)
        }

        container.register(TestPresenter.self) { (resolver, facilityId: String) in
            let interactor = resolver.resolve(TestInteractor.self)!
            return TestPresenterImpl(facilityId: facilityId, interactor: interactor)
        }
    }

}
