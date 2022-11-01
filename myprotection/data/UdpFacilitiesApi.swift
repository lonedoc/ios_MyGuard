//
//  UdpObjectsApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

class UdpFacilitiesApi: UdpApiBase, FacilitiesApi {

    private var facilitiesSubject: PublishSubject<FacilitiesResponse>?
    private var facilitySubject: PublishSubject<Facility>?
    private var renamingResultSubject: PublishSubject<Bool>?
    private var statusSubject: PublishSubject<Bool>?
    private var alarmSubject: PublishSubject<Bool>?
    private var cancelAlarmSubject: PublishSubject<Bool>?

    override var socketDelegate: RubegSocketDelegate {
        return self
    }

    override init(communicationData: CommunicationData) {
        super.init(communicationData: communicationData)
    }

    func getFacilities(attempts: Int = 1) -> Observable<FacilitiesResponse> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = facilitiesSubject ?? PublishSubject<FacilitiesResponse>()
        facilitiesSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"getobject\"}"

        makeRequest(
            query: query,
            publishError: publishFacilitiesError(_:),
            attempts
        )

        return subject
    }

    func getFacility(facilityId: String) -> Observable<Facility> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = facilitySubject ?? PublishSubject<Facility>()
        facilitySubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"objectdata\",\"n_abs\":\"\(facilityId)\"}"

        makeRequest(query: query, publishError: publishFacilityError(_:), 1)

        return subject
    }

    func setName(facilityId: String, name: String) -> Observable<Bool> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = renamingResultSubject ?? PublishSubject<Bool>()
        renamingResultSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"lkpspput\",\"obj\":\"\(facilityId)\",\"newdesc\":\"\(name)\"}"

        makeRequest(query: query, publishError: publishRenamingError(_:))

        return subject
    }

    func setStatus(facilityId: String, statusCode: Int) -> Observable<Bool> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = statusSubject ?? PublishSubject<Bool>()
        statusSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"guard\",\"obj\":\"\(facilityId)\",\"status\":\"\(statusCode)\"}"

        makeRequest(query: query, publishError: publishStatusError(_:))

        return subject
    }

    func sendAlarm(facilityId: String) -> Observable<Bool> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = alarmSubject ?? PublishSubject<Bool>()
        alarmSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"alarmtk\",\"obj\":\"\(facilityId)\"}"

        makeRequest(query: query, publishError: publishAlarmError(_:))

        return subject
    }

    func cancelAlarm(facilityId: String, passcode: String) -> Observable<Bool> {
        let isSocketReady = prepareSocket()

        if !isSocketReady {
            return Observable.error(CommunicationError.socketError)
        }

        let subject = cancelAlarmSubject ?? PublishSubject<Bool>()
        cancelAlarmSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"cancelalarm\",\"obj\":\"\(facilityId)\",\"passcode\":\"\(passcode)\"}"

        makeRequest(query: query, publishError: publishCancelAlarmError(_:))

        return subject
    }

    private func publishFacilitiesError(_ error: Error) {
        let subject = facilitiesSubject
        facilitiesSubject = nil
        subject?.onError(error)
    }

    private func publishFacilityError(_ error: Error) {
        let subject = facilitySubject
        facilitySubject = nil
        subject?.onError(error)
    }

    private func publishRenamingError(_ error: Error) {
        let subject = renamingResultSubject
        renamingResultSubject = nil
        subject?.onError(error)
    }

    private func publishStatusError(_ error: Error) {
        let subject = statusSubject
        statusSubject = nil
        subject?.onError(error)
    }

    private func publishAlarmError(_ error: Error) {
        let subject = alarmSubject
        alarmSubject = nil
        subject?.onError(error)
    }

    private func publishCancelAlarmError(_ error: Error) {
        let subject = cancelAlarmSubject
        cancelAlarmSubject = nil
        subject?.onError(error)
    }

    private func reset() {
        facilitiesSubject = nil
        facilitySubject = nil
        renamingResultSubject = nil
        statusSubject = nil
        alarmSubject = nil
        cancelAlarmSubject = nil
        socket.close()
    }

}

// MARK: - RubegSocketDelegate

extension UdpFacilitiesApi: RubegSocketDelegate {

    // swiftlint:disable:next cyclomatic_complexity function_body_length
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
        case "getobject":
            defer { reset() }

            guard let result = jsonMap["result"] as? String else {
                publishFacilitiesError(CommunicationError.parseError)
                return
            }

            if result != "ok" {
                publishFacilitiesError(CommunicationError.internalServerError)
                return
            }

            guard
                let data = jsonMap["data"] as? [[String: Any]],
                let jsonData = try? JSONSerialization.data(
                    withJSONObject: data,
                    options: JSONSerialization.WritingOptions()
                ),
                let json = String(data: jsonData, encoding: .utf8),
                let facilitiesDTO = try? FacilityDTO.deserializeList(from: json)
            else {
                publishFacilitiesError(CommunicationError.parseError)
                return
            }

            let guardServicePhoneNumber = jsonMap["factorytel"] as? String
            let facilities = facilitiesDTO.map { Facility($0) }

            facilitiesSubject?.onNext((facilities, guardServicePhoneNumber))
        case "objectdata":
            defer { reset() }

            guard
                let data = jsonMap["data"] as? [String: Any],
                let jsonData = try? JSONSerialization.data(
                    withJSONObject: data,
                    options: JSONSerialization.WritingOptions()
                ),
                let json = String(data: jsonData, encoding: .utf8),
                let facilityDTO = try? FacilityDTO.deserialize(from: json)
            else {
                publishFacilityError(CommunicationError.parseError)
                return
            }

            let facility = Facility(facilityDTO)
            facilitySubject?.onNext(facility)
        case "lkpspput":
            defer { reset() }

            guard let result = jsonMap["result"] as? String else {
                publishRenamingError(CommunicationError.parseError)
                return
            }

            renamingResultSubject?.onNext(result == "ok")
        case "guard":
            defer { reset() }

            guard let result = jsonMap["result"] as? String else {
                publishStatusError(CommunicationError.parseError)
                return
            }

            statusSubject?.onNext(result == "start")
        case "alarmtk":
            defer { reset() }

            guard let result = jsonMap["result"] as? String else {
                publishAlarmError(CommunicationError.parseError)
                return
            }

            alarmSubject?.onNext(result == "ok")
        case "cancelalarm":
            defer { reset() }

            guard let result = jsonMap["result"] as? String else {
                publishCancelAlarmError(CommunicationError.parseError)
                return
            }

            cancelAlarmSubject?.onNext(result == "ok")
        default:
            return
        }
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
