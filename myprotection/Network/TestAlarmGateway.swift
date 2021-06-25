//
//  TestAlarmGateway.swift
//  myprotection
//
//  Created by Rubeg NPO on 26.05.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

protocol TestAlarmGateway {
    func enterTestMode(address: InetAddress, token: String, objectId: String) -> Observable<Int>
    func getStatus(address: InetAddress, token: String, objectId: String) -> Observable<TestStatus>
    func resetAlarmButtons(address: InetAddress, token: String, objectId: String) -> Observable<Bool>
    func exitTestMode(address: InetAddress, token: String, objectId: String) -> Observable<Bool>
    func close()
}

class UdpTestAlarmGateway: TestAlarmGateway {

    private var testModeSubject: PublishSubject<Int>?
    private var statusSubject: PublishSubject<TestStatus>?
    private var resetSubject: PublishSubject<Bool>?
    private var endTestModeSubject: PublishSubject<Bool>?

    private lazy var socket: RubegSocket = {
        let socket = RubegSocket(dropUnexpected: false)
        socket.delegate = self
        return socket
    }()

    func enterTestMode(address: InetAddress, token: String, objectId: String) -> Observable<Int> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                return Observable<Int>.error(CommunicationError.socketError)
            }
        }

        let subject = testModeSubject ?? PublishSubject<Int>()
        testModeSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"checktk\",\"obj\":\"\(objectId)\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { success in
            if !success {
                self.testModeSubject = nil
                subject.onError(CommunicationError.serverError)
            }
        }

        return subject
    }

    func getStatus(
        address: InetAddress,
        token: String,
        objectId: String
    ) -> Observable<TestStatus> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                return Observable<TestStatus>.error(CommunicationError.socketError)
            }
        }

        let subject = statusSubject ?? PublishSubject<TestStatus>()
        statusSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"checktkstatus\",\"obj\":\"\(objectId)\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { success in
            if !success {
                self.statusSubject = nil
                subject.onError(CommunicationError.serverError)
            }
        }

        return subject
    }

    func resetAlarmButtons(
        address: InetAddress,
        token: String,
        objectId: String
    ) -> Observable<Bool> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                return Observable<Bool>.error(CommunicationError.socketError)
            }
        }

        let subject = resetSubject ?? PublishSubject<Bool>()
        resetSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"checktkreset\",\"obj\":\"\(objectId)\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { success in
            if !success {
                self.resetSubject = nil
                subject.onError(CommunicationError.serverError)
            }
        }

        return subject
    }

    func exitTestMode(address: InetAddress, token: String, objectId: String) -> Observable<Bool> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                return Observable<Bool>.error(CommunicationError.socketError)
            }
        }

        let subject = endTestModeSubject ?? PublishSubject<Bool>()
        endTestModeSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"checktkend\",\"obj\":\"\(objectId)\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { success in
            if !success {
                self.endTestModeSubject = nil
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

// MARK: - RubegSocketDelegate

extension UdpTestAlarmGateway: RubegSocketDelegate {

    func stringMessageReceived(_ message: String) {
        #if DEBUG
            print("<- \(message)")
        #endif

        guard
            let sourceData = message.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: sourceData, options: []),
            let jsonMap = jsonObject as? [String: Any]
        else {
            return
        }

        guard
            let client = jsonMap["$c$"] as? String,
            client == "newlk"
        else {
            return
        }

        guard let command = jsonMap["com"] as? String else {
            return
        }

        switch command {
        case "checktk":
            guard let result = jsonMap["result"] as? String else {
                let subject = testModeSubject
                testModeSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            if result != "ok" {
                let subject = testModeSubject
                testModeSubject = nil
                subject?.onError(CommunicationError.internalServerError)
                return
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"

            guard
                let timeStr = jsonMap["time"] as? String,
                let date = formatter.date(from: timeStr)
            else {
                let subject = testModeSubject
                testModeSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            let hours = Calendar.current.component(.hour, from: date)
            let minutes = Calendar.current.component(.minute, from: date)
            let seconds = Calendar.current.component(.second, from: date)

            testModeSubject?.onNext(seconds + minutes * 60 + hours * 3600)
            testModeSubject = nil
        case "checktkstatus":
            guard let result = jsonMap["result"] as? String else {
                let subject = statusSubject
                statusSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            if result != "ok" {
                let subject = statusSubject
                statusSubject = nil
                subject?.onError(CommunicationError.internalServerError)
                return
            }

            guard
                let alarmButtonPressedInt = jsonMap["s"] as? Int,
                let reinstalledInt = jsonMap["p"] as? Int
            else {
                let subject = statusSubject
                statusSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            let alarmButtonPressed = alarmButtonPressedInt == 1
            let reinstalled = reinstalledInt == 1
            let status = TestStatus(alarmButtonPressed: alarmButtonPressed, reinstalled: reinstalled)

            statusSubject?.onNext(status)
            statusSubject = nil
        case "checktkreset":
            guard let result = jsonMap["result"] as? String else {
                let subject = resetSubject
                resetSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            resetSubject?.onNext(result == "ok")
            resetSubject = nil
        case "checktkend":
            guard let result = jsonMap["result"] as? String else {
                let subject = endTestModeSubject
                endTestModeSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            endTestModeSubject?.onNext(result == "ok")
            endTestModeSubject = nil
        default:
            return
        }
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
