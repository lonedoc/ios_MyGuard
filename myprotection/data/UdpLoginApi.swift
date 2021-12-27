//
//  UdpLoginApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

class UdpLoginApi: UdpApiBase, LoginApi {

    private var loginSubject: PublishSubject<LoginResponse>?
    private var logoutSubject: PublishSubject<Bool>?

    override var socketDelegate: RubegSocketDelegate {
        return self
    }

    override init(communicationData: CommunicationData) {
        super.init(communicationData: communicationData)
    }

    func logIn(
        credentials: Credentials,
        fcmToken: String,
        device: String
    ) -> Observable<LoginResponse> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = loginSubject ?? PublishSubject<LoginResponse>()
        loginSubject = subject

        let query = getLoginQuery(
            credentials: credentials,
            fcmToken: fcmToken,
            device: device
        )

        makeRequest(query: query, publishError: publishLoginError(_:))

        return subject
    }

    func logOut() -> Observable<Bool> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = logoutSubject ?? PublishSubject<Bool>()
        logoutSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"deleteuser\"}"

        makeRequest(query: query, publishError: publishLogoutError(_:))

        return subject
    }

    private func getLoginQuery(
        credentials: Credentials,
        fcmToken: String,
        device: String
    ) -> String {
        var queryDict = [String: Any]()
        queryDict["$c$"] = "reglk"
        queryDict["id"] = "FCC2C586-A78D-48F7-AC3A-FC85F0AE29EF"
        queryDict["phone"] = credentials.phone
        queryDict["password"] = credentials.password
        queryDict["idgoogle"] = fcmToken
        queryDict["os"] = "iOS"
        queryDict["name"] = device

        let jsonData = try? JSONSerialization.data(
            withJSONObject: queryDict,
            options: JSONSerialization.WritingOptions()
        )

        return String(data: jsonData!, encoding: .utf8)!
    }

    private func publishLoginError(_ error: Error) {
        let subject = loginSubject
        loginSubject = nil
        subject?.onError(error)
    }

    private func publishLogoutError(_ error: Error) {
        let subject = logoutSubject
        logoutSubject = nil
        subject?.onError(error)
    }

    private func reset() {
        loginSubject = nil
        logoutSubject = nil
        socket.close()
    }

}

// MARK: - RubegSocketDelegate

extension UdpLoginApi: RubegSocketDelegate {

    // swiftlint:disable:next function_body_length
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
        case "reglkok":
            defer { reset() }

            guard
                let userId = jsonMap["usern_abs"] as? Int,
                let guid = jsonMap["guid"] as? String,
                let name = jsonMap["name"] as? String,
                let serviceName = jsonMap["factory"] as? String,
                let servicePhone = jsonMap["factorytel"] as? String,
                let stat = jsonMap["stat"] as? Int
            else {
                publishLoginError(CommunicationError.parseError)
                return
            }

            let user = User(id: userId, name: name)
            let guardService = GuardService(name: serviceName, phone: servicePhone)

            let result = LoginResponse(
                user: user,
                guardService: guardService,
                token: guid,
                stat: stat
            )

            loginSubject?.onNext(result)
        case "regerror":
            publishLoginError(CommunicationError.authError)
            reset()
        case "newlk":
            guard
                let com = jsonMap["com"] as? String,
                let result = jsonMap["result"] as? String,
                com == "deleteuser"
            else {
                return
            }

            if result == "ok" {
                logoutSubject?.onNext(true)
            } else if result == "guidnotfound" {
                logoutSubject?.onNext(false)
            } else {
                publishLogoutError(CommunicationError.parseError)
            }

            reset()
        default:
            return
        }
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
