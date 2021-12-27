//
//  CommunicationDataHolder.swift
//  myprotection
//
//  Created by Rubeg NPO on 02.06.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

class CommunicationData {

    private(set) var addressRotator: Rotator<String>

    var token: String?

    init(addresses: [String], token: String? = nil) {
        addressRotator = Rotator<String>.create(items: addresses)
        self.token = token
    }

    func setAddresses(_ addresses: [String]) {
        addressRotator = Rotator<String>.create(items: addresses)
    }

}
