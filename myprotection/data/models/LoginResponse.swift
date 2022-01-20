//
//  LoginResponse.swift
//  myprotection
//
//  Created by Rubeg NPO on 26.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

struct LoginResponse {
    let user: User
    let guardServiceContact: GuardServiceContact
    let token: String
    let stat: Int
}
