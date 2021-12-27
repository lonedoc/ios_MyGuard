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

    private static var instance: Assembler = assemble()

    static var shared: Assembler {
        return instance
    }

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
                TestAssembly()
            ],
            container: container
        )
    }

}
