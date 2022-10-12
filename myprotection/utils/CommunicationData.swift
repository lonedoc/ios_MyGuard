//
//  CommunicationDataHolder.swift
//  myprotection
//
//  Created by Rubeg NPO on 02.06.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import RubegProtocol_v2_0

class CommunicationData {

    private(set) var addressRotator: Rotator<InetAddress>
    var token: String?

    init(hosts: [String], port: Int32, token: String? = nil) {
        let addresses = InetAddress.createAll(hosts: hosts, port: port)
        addressRotator = Rotator<InetAddress>.create(items: addresses)
        self.token = token
    }

    init(addresses: [InetAddress], token: String? = nil) {
        addressRotator = Rotator<InetAddress>.create(items: addresses)
        self.token = token
    }

    func setAddresses(_ addresses: [InetAddress]) {
        addressRotator = Rotator<InetAddress>.create(items: addresses)
    }

}
