//
//  LoginApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 23.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

protocol PasswordApi {
    func resetPassword(phone: String) -> Observable<Bool>
}
