//
//  UdpSensorsApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 27.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

class UdpSensorsApi: UdpApiBase, SensorsApi {

    private var sensorsSubject: PublishSubject<[Sensor]>?

    override var socketDelegate: RubegSocketDelegate {
        return self
    }

    override init(communicationData: CommunicationData) {
        super.init(communicationData: communicationData)
    }

    func getSensors(facilityId: String) -> Observable<[Sensor]> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = sensorsSubject ?? PublishSubject<[Sensor]>()
        sensorsSubject = subject

        let query = "" // TODO

        makeRequest(query: query, publishError: publishSensorsError(_:))

        return subject
    }

    private func publishSensorsError(_ error: Error) {
        let subject = sensorsSubject
        sensorsSubject = nil
        subject?.onError(error)
    }

    private func reset() {
        sensorsSubject = nil
        socket.close()
    }

}

// MARK: - RubegSocketDelegate

extension UdpSensorsApi: RubegSocketDelegate {

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

        // TODO
    }

    func binaryMessageReceived(_ message: [Byte]) { }
}
