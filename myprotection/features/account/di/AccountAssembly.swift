//
//  AccountAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 13.01.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

class AccountAssembly: Assembly {

    func assemble(container: Container) {
        container.register(AccountPresenter.self) { _ in
            AccountPresenterImpl()
        }
    }

}
