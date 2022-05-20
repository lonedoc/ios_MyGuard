//
//  ApplicationsAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.05.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

class ApplicationsAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ApplicationsApi.self) { resolver in
            let communicationData = resolver.resolve(CommunicationData.self)!
            return UdpApplicationsApi(communicationData: communicationData)
        }

        container.register(ApplicationsInteractor.self) { resolver in
            let applicationsApi = resolver.resolve(ApplicationsApi.self)!
            return ApplicationsInteractor(applicationsApi: applicationsApi)
        }

        container.register(ApplicationsPresenter.self) { (resolver, facilityId: String) in
            let interactor = resolver.resolve(ApplicationsInteractor.self)!
            return ApplicationsPresenterImpl(facilityId: facilityId, interactor: interactor)
        }
    }

}
