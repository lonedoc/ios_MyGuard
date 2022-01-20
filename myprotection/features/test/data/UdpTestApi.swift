//
//  UdpTestApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 22.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

class UdpTestApi: UdpApiBase, TestApi {

    private var startTestSubject: PublishSubject<Int>?
    private var stopTestSubject: PublishSubject<Bool>?
    private var resetAlarmButtonsSubject: PublishSubject<Bool>?
    private var statusSubject: PublishSubject<TestStatus>?

    override var socketDelegate: RubegSocketDelegate {
        return self
    }

    override init(communicationData: CommunicationData) {
        let currentAddress = communicationData.addressRotator.current
        let port = communicationData.port
        let token = communicationData.token

        // swiftlint:disable:next identifier_name
        let cd = CommunicationData(
            addresses: currentAddress != nil ? [currentAddress!] : [],
            port: port,
            token: token
        )

        super.init(communicationData: cd)
    }

    func startTestMode(facilityId: String) -> Observable<Int> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = startTestSubject ?? PublishSubject<Int>()
        startTestSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"checktk\",\"obj\":\"\(facilityId)\"}"

        makeRequest(query: query, publishError: publishStartTestError(_:))

        return subject
    }

    func stopTestMode(facilityId: String) -> Observable<Bool> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = stopTestSubject ?? PublishSubject<Bool>()
        stopTestSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"checktkend\",\"obj\":\"\(facilityId)\"}"

        makeRequest(query: query, publishError: publishStopTestError(_:))

        return subject
    }

    func resetAlarmButtons(facilityId: String) -> Observable<Bool> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = resetAlarmButtonsSubject ?? PublishSubject<Bool>()
        resetAlarmButtonsSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"checktkreset\",\"obj\":\"\(facilityId)\"}"

        makeRequest(query: query, publishError: publishResetAlarmButtonsError(_:))

        return subject
    }

    func getStatus(facilityId: String) -> Observable<TestStatus> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = statusSubject ?? PublishSubject<TestStatus>()
        statusSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"checktkstatus\",\"obj\":\"\(facilityId)\"}"

        makeRequest(
            query: query,
            publishError: publishStatusError(_:),
            1
        )

        return subject
    }

    private func publishStartTestError(_ error: Error) {
        let subject = startTestSubject
        startTestSubject = nil
        subject?.onError(error)
    }

    private func publishStopTestError(_ error: Error) {
        let subject = stopTestSubject
        stopTestSubject = nil
        subject?.onError(error)
    }

    private func publishResetAlarmButtonsError(_ error: Error) {
        let subject = resetAlarmButtonsSubject
        resetAlarmButtonsSubject = nil
        subject?.onError(error)
    }

    private func publishStatusError(_ error: Error) {
        let subject = statusSubject
        statusSubject = nil
        subject?.onError(error)
    }

    private func reset() {
        startTestSubject = nil
        stopTestSubject = nil
        resetAlarmButtonsSubject = nil
        statusSubject = nil
        socket.close()
    }

}

// MARK: - RubegSocketDelegate

extension UdpTestApi: RubegSocketDelegate {

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func stringMessageReceived(_ message: String) {
        #if DEBUG
            print("<- \(message)")
        #endif

        guard
            let sourceData = message.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: sourceData, options: []),
            let jsonMap = jsonObject as? [String: Any],
            let command = jsonMap["com"] as? String
        else {
            return
        }

        switch command {
        case "checktk":
            defer { reset() }

            guard let result = jsonMap["result"] as? String else {
                publishStartTestError(CommunicationError.parseError)
                return
            }

            if result != "ok" {
                publishStartTestError(CommunicationError.internalServerError)
                return
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"

            guard
                let timeStr = jsonMap["time"] as? String,
                let date = formatter.date(from: timeStr)
            else {
                publishStartTestError(CommunicationError.parseError)
                return
            }

            let hours = Calendar.current.component(.hour, from: date)
            let minutes = Calendar.current.component(.minute, from: date)
            let seconds = Calendar.current.component(.second, from: date)

            startTestSubject?.onNext(seconds + minutes * 60 + hours * 3600)
        case "checktkend":
            defer { reset() }

            guard let result = jsonMap["result"] as? String else {
                publishStopTestError(CommunicationError.parseError)
                return
            }

            stopTestSubject?.onNext(result == "ok")
        case "checktkreset":
            defer { reset() }

            guard let result = jsonMap["result"] as? String else {
                publishResetAlarmButtonsError(CommunicationError.parseError)
                return
            }

            resetAlarmButtonsSubject?.onNext(result == "ok")
        case "checktkstatus":
            defer { reset() }

            guard let result = jsonMap["result"] as? String else {
                publishStatusError(CommunicationError.parseError)
                return
            }

            if result != "ok" {
                publishStatusError(CommunicationError.internalServerError)
                return
            }

            guard
                let alarmButtonPressedInt = jsonMap["s"] as? Int,
                let reinstalledInt = jsonMap["p"] as? Int
            else {
                publishStatusError(CommunicationError.parseError)
                return
            }

            let alarmButtonPressed = alarmButtonPressedInt == 1
            let reinstalled = reinstalledInt == 1

            let status = TestStatus(
                alarmButtonPressed: alarmButtonPressed,
                reinstalled: reinstalled
            )

            statusSubject?.onNext(status)
        default:
            return
        }
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
