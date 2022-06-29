//
//  Assembler.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

extension Assembler {

    static let shared: Assembler = assemble()

    private static func assemble() -> Assembler {
        let container = Container()

        return Assembler(
            [
                CommonAssembly(),
                LoginAssembly(),
                PasswordAssembly(),
                PasscodeAssembly(),
                FacilitiesAssembly(),
                FacilityAssembly(),
                EventsAssembly(),
                SensorsAssembly(),
                TestAssembly(),
                AccountAssembly(),
                ApplicationsAssembly()
            ],
            container: container
        )
    }

}
