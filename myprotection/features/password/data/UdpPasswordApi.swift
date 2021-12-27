//
//  UdpLoginApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

class UdpPasswordApi: UdpApiBase, PasswordApi {

    private var passwordSubject: PublishSubject<Bool>?

    override var socketDelegate: RubegSocketDelegate {
        return self
    }

    override init(communicationData: CommunicationData) {
        super.init(communicationData: communicationData)
    }

    func resetPassword(phone: String) -> Observable<Bool> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = passwordSubject ?? PublishSubject<Bool>()
        passwordSubject = subject

        let query = getQuery(phone: phone)

        makeRequest(query: query, publishError: publishError(_:))

        return subject
    }

    private func getQuery(phone: String) -> String {
        return "{\"$c$\": \"getpasswordlk\", \"phone\": \"\(phone)\"}"
    }

    private func publishError(_ error: Error) {
        let subject = passwordSubject
        passwordSubject = nil
        subject?.onError(error)
    }

    private func reset() {
        passwordSubject = nil
        socket.close()
    }

}

// MARK: - RubegSocketDelegate

extension UdpPasswordApi: RubegSocketDelegate {

    func stringMessageReceived(_ message: String) {
        #if DEBUG
            print("<- \(message)")
        #endif

        guard
            let sourceData = message.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: sourceData, options: []),
            let jsonMap = jsonObject as? [String: Any],
            let command = jsonMap["$c$"] as? String
        else {
            return
        }

        switch command {
        case "sendpassword":
            passwordSubject?.onNext(true)
            reset()
        case "getpasswordlk":
            defer { reset() }

            guard let resultString = jsonMap["result"] as? String else {
                publishError(CommunicationError.parseError)
                return
            }

            if resultString == "usernotfound" {
                publishError(CommunicationError.userNotFoundError)
                return
            }

            passwordSubject?.onNext(resultString == "ok")
        default:
            break
        }
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
