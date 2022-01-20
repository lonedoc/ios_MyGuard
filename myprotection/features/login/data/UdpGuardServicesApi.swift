//
//  UdpCompaniesApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

private let ipAddresses = ["94.177.183.4", "91.189.160.38"]
private let port: Int32 = 8300

class UdpGuardServicesApi: UdpApiBase, GuardServicesApi {

    private var guardServicesSubject: PublishSubject<[GuardService]>?
    private var addressesSubject: PublishSubject<[String]>?

    override var socketDelegate: RubegSocketDelegate {
        return self
    }

    init() {
        let communicationData = CommunicationData(addresses: ipAddresses, port: port)
        super.init(communicationData: communicationData)
    }

    func getGuardServices() -> Observable<[GuardService]> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = guardServicesSubject ?? PublishSubject<[GuardService]>()
        guardServicesSubject = subject

        let query = "{\"$c$\":\"getcity\"}"

        makeRequest(query: query, subject: subject, 5)

        return subject
    }

    func getAddresses(cityName: String, guardServiceName: String) -> Observable<[String]> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = addressesSubject ?? PublishSubject<[String]>()
        addressesSubject = subject

        let query = "{\"$c$\":\"getip\",\"city\":\"\(cityName)\",\"pr\":\"\(guardServiceName)\"}"

        makeRequest(query: query, subject: subject, 5)

        return subject
    }

}

// MARK: - RubegSocketDelegate

extension UdpGuardServicesApi: RubegSocketDelegate {

    func stringMessageReceived(_ message: String) {
        #if DEBUG
            print("<- \(message)")
        #endif

        guard let response = parseResponse(source: message) else {
            return
        }

        switch(response.command) {
        case "city":
            guard let guardServicesDTO = try? GuardServicesDTO.parse(json: response.data) else {
                let subject = guardServicesSubject
                guardServicesSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            let guardServices = guardServicesDTO.data.flatMap { city in
                city.guardServices.map { guardServiceDTO in
                    GuardService(city: city.name, name: guardServiceDTO.name, ip: guardServiceDTO.ip)
                }
            }

            guardServicesSubject?.onNext(guardServices)
            guardServicesSubject = nil
            socket.close()
        case "getip":
            guard let addresses = try? JSONDecoder().decode([String].self, from: response.data.data(using: .utf8)!) else {
                let subject = addressesSubject
                addressesSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            addressesSubject?.onNext(addresses)
            addressesSubject = nil
            socket.close()
        default:
            return
        }
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
