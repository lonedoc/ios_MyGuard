//
//  EventsApiImpl.swift
//  myprotection
//
//  Created by Rubeg NPO on 20.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

class UdpEventsApi: UdpApiBase, EventsApi {

    private var facilityId: String?
    private var eventsSubject: PublishSubject<[Event]>?

    override var socketDelegate: RubegSocketDelegate {
        return self
    }

    override init(communicationData: CommunicationData) {
        super.init(communicationData: communicationData)
    }

    func getEvents(facilityId: String, position: Int?, attempts: Int) -> Observable<[Event]> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        self.facilityId = facilityId

        let subject = eventsSubject ?? PublishSubject<[Event]>()
        eventsSubject = subject

        let query = getEventsQuery(facilityId: facilityId, position: position)

        makeRequest(
            query: query,
            publishError: publishEventsError(_:),
            attempts
        )

        return subject
    }

    private func getEventsQuery(facilityId: String, position: Int?) -> String {
        let positionPart: String
        if let position = position {
            positionPart = ",\"pos\":\(position)"
        } else {
            positionPart = ""
        }

        return "{\"$c$\":\"newlk\",\"com\":\"getevents\",\"obj\":\"\(facilityId)\"\(positionPart)}"
    }

    private func publishEventsError(_ error: Error) {
        let subject = eventsSubject
        eventsSubject = nil
        subject?.onError(error)
    }

    private func reset() {
        eventsSubject = nil
        socket.close()
    }

}

// MARK: - RubegSocketDelegate

extension UdpEventsApi: RubegSocketDelegate {

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
        case "getevents":
            defer { reset() }

            guard
                let facilityId = facilityId,
                let data = jsonMap["data"] as? [[String: Any]],
                let jsonData = try? JSONSerialization.data(
                    withJSONObject: data,
                    options: JSONSerialization.WritingOptions()
                ),
                let json = String(data: jsonData, encoding: .utf8),
                let eventsDTO = try? EventDTO.deserializeList(from: json)
            else {
                publishEventsError(CommunicationError.parseError)
                return
            }

            let events = eventsDTO.map { Event($0, facilityId: facilityId) }

            eventsSubject?.onNext(events)
        default:
            return
        }
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
