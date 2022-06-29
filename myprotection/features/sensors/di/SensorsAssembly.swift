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
        container.register(SensorsPresenter.self) { (_: Resolver, facilityId: String) in
            return SensorsPresenterImpl(facilityid: facilityId)
        }
    }

}
