//
//  PasswordGateway.swift
//  myprotection
//
//  Created by Rubeg NPO on 17.12.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

protocol PasswordGateway {
    func requestPassword(address: InetAddress, phone: String) -> Observable<Bool>
    func close()
}

class UdpPasswordGateway: PasswordGateway {

    private var passwordSubject: PublishSubject<Bool>?

    private lazy var socket: RubegSocket = {
        let socket = RubegSocket()
        socket.delegate = self
        return socket
    }()

    func requestPassword(address: InetAddress, phone: String) -> Observable<Bool> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                return Observable<Bool>.error(CommunicationError.socketError)
            }
        }

        let subject = passwordSubject ?? PublishSubject<Bool>()
        passwordSubject = subject

        let query = "{\"$c$\": \"getpasswordlk\", \"phone\": \"\(phone)\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: nil, to: address) { success in
            if !success {
                self.passwordSubject = nil
                subject.onError(CommunicationError.serverError)
            }
        }

        return subject
    }

    func close() {
        if socket.opened {
            socket.close()
        }
    }

}

// MARK: RubegSocketDelegate

// manysendfromday

extension UdpPasswordGateway: RubegSocketDelegate {

    func stringMessageReceived(_ message: String) {
        #if DEBUG
            print("<- \(message)")
        #endif

        guard let sourceData = message.data(using: .utf8) else {
            return
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: sourceData, options: []) else {
            return
        }

        guard let jsonMap = jsonObject as? [String: Any] else {
            return
        }

        guard let command = jsonMap["$c$"] as? String else {
            return
        }

        if command != "getpasswordlk" {
            return
        }

        guard let resultString = jsonMap["result"] as? String else {
            let subject = passwordSubject
            passwordSubject = nil
            subject?.onError(CommunicationError.parseError)
            return
        }

        let result = resultString == "ok"

        passwordSubject?.onNext(result)
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
