//
//  LoginGateway.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.12.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

struct LoginResult {
    let user: User
    let factory: Factory
    let token: String
    let stat: Int
}

protocol LoginGateway {
    func register(
        address: InetAddress,
        phone: String,
        password: String,
        fcmToken: String,
        device: String
    ) -> Observable<LoginResult>
    func unregister(address: InetAddress, token: String) -> Observable<Bool>
    func close()
}

class UdpLoginGateway: LoginGateway {

    private var loginSubject: PublishSubject<LoginResult>?
    private var logoutSubject: PublishSubject<Bool>?

    private lazy var socket: RubegSocket = {
        let socket = RubegSocket(dropUnexpected: false)
        socket.delegate = self
        return socket
    }()

    func register(
        address: InetAddress,
        phone: String,
        password: String,
        fcmToken: String,
        device: String
    ) -> Observable<LoginResult> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                return Observable<LoginResult>.error(CommunicationError.socketError)
            }
        }

        let subject = loginSubject ?? PublishSubject<LoginResult>()
        loginSubject = subject

        var queryDict = [String: Any]()
        queryDict["$c$"] = "reglk"
        queryDict["id"] = "FCC2C586-A78D-48F7-AC3A-FC85F0AE29EF"
        queryDict["phone"] = phone
        queryDict["password"] = password
        queryDict["idgoogle"] = fcmToken
        queryDict["os"] = "iOS"
        queryDict["name"] = device

        let jsonData = try? JSONSerialization.data(
            withJSONObject: queryDict,
            options: JSONSerialization.WritingOptions()
        )

        let query = String(data: jsonData!, encoding: .utf8)

        #if DEBUG
            print("-> \(query!)")
        #endif

        socket.send(message: query!, token: nil, to: address) { success in
            if !success {
                self.loginSubject = nil
                subject.onError(CommunicationError.serverError)
            }
        }

        return subject
    }

    func unregister(address: InetAddress, token: String) -> Observable<Bool> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                return Observable<Bool>.error(CommunicationError.socketError)
            }
        }

        let subject = logoutSubject ?? PublishSubject<Bool>()
        logoutSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"deleteuser\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { success in
            if !success {
                self.logoutSubject = nil
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

//        {"$c$":"reglkok","usern_abs":25,"guid":"60E39E9A-263E-4944-97B4-BEEB0141B58D","name":"Тест","factory":"Rubezh NPO","factorytel":"9140000000","stat":7}
//        {"$c$":"passwordtimelimit"}
//        {"$c$":"regerror","data":"wrongpassword"}

extension UdpLoginGateway: RubegSocketDelegate {

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

        switch command {
        case "reglkok":
            guard
                let userId = jsonMap["usern_abs"] as? Int,
                let guid = jsonMap["guid"] as? String,
                let name = jsonMap["name"] as? String,
                let factoryName = jsonMap["factory"] as? String,
                let factorytel = jsonMap["factorytel"] as? String,
                let stat = jsonMap["stat"] as? Int
            else {
                let subject = loginSubject
                loginSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            let user = User(id: userId, name: name)
            let factory = Factory(name: factoryName, phone: factorytel)

            let result = LoginResult(
                user: user,
                factory: factory,
                token: guid,
                stat: stat
            )

            loginSubject?.onNext(result)

            break
        case "regerror":
            let subject = loginSubject
            loginSubject = nil
            subject?.onError(CommunicationError.authError)
        case "newlk":
            guard
                let com = jsonMap["com"] as? String,
                let result = jsonMap["result"] as? String
            else {
                return
            }

            if com != "deleteuser" {
                return
            }

            if result == "ok" {
                logoutSubject?.onNext(true)
            } else if result == "guidnotfound" {
                logoutSubject?.onNext(false)
            } else {
                let subject = logoutSubject
                logoutSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }
        default:
            return
        }
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
