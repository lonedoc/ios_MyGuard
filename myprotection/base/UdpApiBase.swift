//
//  UdpApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 26.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RubegProtocol_v2_0

class UdpApiBase {

    lazy var socket: RubegSocket = {
        let socket = RubegSocket(dropUnexpected: false)
        socket.delegate = socketDelegate
        return socket
    }()

    var socketDelegate: RubegSocketDelegate {
        fatalError("Abstract property \"delegate\" of type RubegSocketDelegate must be implemented")
    }

    let addresses: Rotator<InetAddress>
    let token: String?

    init(communicationData: CommunicationData) {
        // swiftlint:disable:next identifier_name
        addresses = communicationData.addressRotator.map { ip in
            InetAddress.create(ip: ip, port: 8301)
        }

        token = communicationData.token
    }

    func prepareSocket() -> Bool {
        if !socket.opened { // TODO: Rename to isOpen
            do {
                try socket.open()
            } catch let error {
                #if DEBUG
                    print(error.localizedDescription)
                #endif

                return false
            }
        }

        return true
    }

    func makeRequest(
        query: String,
        publishError: @escaping (Error) -> Void,
        _ attempts: Int = 3
    ) {
        if attempts < 1 {
            publishError(CommunicationError.serverError)
            return
        }

        guard let address = addresses.current else {
            publishError(CommunicationError.socketError) // TODO: Replace with dedicated error
            return
        }

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { [weak self] success in
            if !success {
                _ = self?.addresses.next()

                self?.makeRequest(
                    query: query,
                    publishError: publishError,
                    attempts - 1
                )
            }
        }
    }

    func parseResponse(source: String) -> Response? {
        guard
            let sourceData = source.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: sourceData, options: []),
            let jsonMap = jsonObject as? [String: Any],
            let command = jsonMap["$c$"] as? String
        else {
            return nil
        }

        guard
            let jsonData = jsonMap["data"],
            let data = try? JSONSerialization.data(withJSONObject: jsonData, options: []),
            let dataStr = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return (command, dataStr)
    }

}
