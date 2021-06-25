//
//  CommunicationDataHolder.swift
//  myprotection
//
//  Created by Rubeg NPO on 02.06.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RubegProtocol_v2_0

private enum InitializingError: Error {
    case emptyAddressList
}

class CommunicationData {

    private let addresses: [InetAddress]
    @Atomic private var addressIndex: Int = 0

    @Atomic var token: String?

    var address: InetAddress {
        return addresses[addressIndex % addresses.count]
    }

    init(addresses: [InetAddress], token: String? = nil) throws {
        if addresses.count == 0 {
            throw InitializingError.emptyAddressList
        }

        self.addresses = addresses
        self.token = token
    }

    func invalidateAddress() {
        addressIndex += 1
    }

}
