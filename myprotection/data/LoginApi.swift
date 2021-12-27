//
//  LoginApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginApi {

    func logIn(
        credentials: Credentials,
        fcmToken: String,
        device: String
    ) -> Observable<LoginResponse>

    func logOut() -> Observable<Bool>

}
