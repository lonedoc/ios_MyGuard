//
//  UdpApplicationsApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.05.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

private let attemptsCount = 3

class UdpApplicationsApi: UdpApiBase, ApplicationsApi {

    private var applicationsSubject: PublishSubject<[String]>?
    private var sendApplicationSubject: PublishSubject<Bool>?

    override var socketDelegate: RubegSocketDelegate {
        return self
    }

    override init(communicationData: CommunicationData) {
        super.init(communicationData: communicationData)
    }

    func getApplications() -> Observable<[String]> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = applicationsSubject ?? PublishSubject<[String]>()
        applicationsSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"get.catalog\",\"name\":\"zaytext.sp8\"}"

        makeRequest(
            query: query,
            publishError: publishApplicationsError(_:),
            attemptsCount
        )

        return subject
    }

    func sendApplication(facilityId: String, text: String, timestamp: Int64) -> Observable<Bool> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = sendApplicationSubject ?? PublishSubject<Bool>()
        sendApplicationSubject = subject

        let query = "\"$c$\":\"newlk\",\"com\":\"application\",\"obj\":\"\(facilityId)\",\"text\":\"\(text)\",\"datetime\":\(timestamp)"

        makeRequest(
            query: query,
            publishError: publishSendApplicationError(_:),
            attemptsCount
        )

        return subject
    }

    private func publishApplicationsError(_ error: Error) {
        let subject = applicationsSubject
        applicationsSubject = nil
        subject?.onError(error)
    }

    private func publishSendApplicationError(_ error: Error) {
        let subject = sendApplicationSubject
        sendApplicationSubject = nil
        subject?.onError(error)
    }

    private func reset() {
        applicationsSubject = nil
        sendApplicationSubject = nil
        socket.close()
    }

}

extension UdpApplicationsApi: RubegSocketDelegate {

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
        case "get.catalog":
            guard let result = jsonMap["result"] as? String else {
                publishApplicationsError(CommunicationError.parseError)
                return
            }

            if result != "ok" {
                publishApplicationsError(CommunicationError.internalServerError)
                return
            }

            guard let applicationsData = jsonMap["data"] as? [[String: Any]] else {
                publishApplicationsError(CommunicationError.parseError)
                return
            }

            let applications = applicationsData.compactMap { obj in obj["desc"] as? String }
            applicationsSubject?.onNext(applications)
        case "application":
            guard let result = jsonMap["result"] as? String else {
                publishApplicationsError(CommunicationError.parseError)
                return
            }

            sendApplicationSubject?.onNext(result == "ok")
        default:
            return
        }
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
