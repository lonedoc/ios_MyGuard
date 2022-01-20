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
    let port: Int32
    var token: String?

    init(addresses: [String], port: Int32, token: String? = nil) {
        addressRotator = Rotator<String>.create(items: addresses)
        self.port = port
        self.token = token
    }

    func setAddresses(_ addresses: [String]) {
        addressRotator = Rotator<String>.create(items: addresses)
    }

}
