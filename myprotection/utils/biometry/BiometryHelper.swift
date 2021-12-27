//
//  BiometryHelper.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol BiometryHelper {
    func isAvailable() -> Bool
    func biometryType() -> BiometryType
    func authenticate(completion: @escaping (Bool, String?) -> Void)
}
