//
//  CommonAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

private let driverPort: Int32 = 8301

class CommonAssembly: Assembly {

    func assemble(container: Container) {
        container.register(UserDefaultsHelper.self) { _ in UserDefaultsHelperImpl() }

        container
            .register(CommunicationData.self) { _ in CommunicationData(hosts: [], port: driverPort, token: nil) }
            .inObjectScope(.container)

        container.register(LoginApi.self) { resolver in
            let communicationData = resolver.resolve(CommunicationData.self)!
            return UdpLoginApi(communicationData: communicationData)
        }

        container.register(FacilitiesApi.self) { resolver in
            let communicationData = resolver.resolve(CommunicationData.self)!
            return UdpFacilitiesApi(communicationData: communicationData)
        }
    }

}
