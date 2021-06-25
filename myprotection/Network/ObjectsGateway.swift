//
//  ObjectsGateway.swift
//  myprotection
//
//  Created by Rubeg NPO on 17.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

protocol ObjectsGateway {
    func getObjects(address: InetAddress, token: String) -> Observable<[Facility]>
    func getObjectData(address: InetAddress, token: String, objectId: String) -> Observable<Facility>
    func getEvents(address: InetAddress, token: String, objectId: String, position: Int?) -> Observable<[Event]>
    func setStatus(address: InetAddress, token: String, objectId: String, status: Int) -> Observable<Bool>
    func setName(address: InetAddress, token: String, objectId: String, name: String) -> Observable<Bool>
    func startAlarm(address: InetAddress, token: String, objectId: String) -> Observable<Bool>
    func close()
}

extension ObjectsGateway {

    func getEvents(address: InetAddress, token: String, objectId: String) -> Observable<[Event]> {
        getEvents(address: address, token: token, objectId: objectId, position: nil)
    }

}

class UdpObjectsGateway: ObjectsGateway {

    private var objectsSubject: PublishSubject<[Facility]>?
    private var objectDataSubject: PublishSubject<Facility>?
    private var eventsSubject: PublishSubject<[Event]>?
    private var statusSubject: PublishSubject<Bool>?
    private var nameSubject: PublishSubject<Bool>?
    private var alarmSubject: PublishSubject<Bool>?

    private var objectId: String?

    private lazy var socket: RubegSocket = {
        let socket = RubegSocket(dropUnexpected: false)
        socket.delegate = self
        return socket
    }()

    func getObjects(address: InetAddress, token: String) -> Observable<[Facility]> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                return Observable<[Facility]>.error(CommunicationError.socketError)
            }
        }

        let subject = objectsSubject ?? PublishSubject<[Facility]>()
        objectsSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"getobject\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { success in
            if !success {
                self.objectsSubject = nil
                subject.onError(CommunicationError.serverError)
            }
        }

        return subject
    }

    func getObjectData(
        address: InetAddress, token: String, objectId: String
    ) -> Observable<Facility> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                return Observable<Facility>.error(CommunicationError.socketError)
            }
        }

        let subject = objectDataSubject ?? PublishSubject<Facility>()
        objectDataSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"objectdata\",\"n_abs\":\"\(objectId)\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { success in
            if !success {
                self.objectDataSubject = nil
                subject.onError(CommunicationError.serverError)
            }
        }

        return subject
    }

    func getEvents(
        address: InetAddress,
        token: String,
        objectId: String,
        position: Int? = nil
    ) -> Observable<[Event]> {
        self.objectId = objectId

        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                self.objectId = nil
                return Observable<[Event]>.error(CommunicationError.socketError)
            }
        }

        let subject = eventsSubject ?? PublishSubject<[Event]>()
        eventsSubject = subject

        let positionPart: String
        if let position = position {
            positionPart = ",\"pos\":\(position)"
        } else {
            positionPart = ""
        }

        let query = "{\"$c$\":\"newlk\",\"com\":\"getevents\",\"obj\":\"\(objectId)\"\(positionPart)}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { success in
            if !success {
                self.eventsSubject = nil
                self.objectId = nil
                subject.onError(CommunicationError.serverError)
            }
        }

        return subject
    }

    func setStatus(address: InetAddress, token: String, objectId: String, status: Int) -> Observable<Bool> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                self.objectId = nil
                return Observable<Bool>.error(CommunicationError.socketError)
            }
        }

        let subject = statusSubject ?? PublishSubject<Bool>()
        statusSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"guard\",\"obj\":\"\(objectId)\",\"status\":\"\(status)\"}"

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
    
    func setName(address: InetAddress, token: String, objectId: String, name: String) -> Observable<Bool> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                self.objectId = nil
                return Observable<Bool>.error(CommunicationError.socketError)
            }
        }

        let subject = nameSubject ?? PublishSubject<Bool>()
        nameSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"lkpspput\",\"obj\":\"\(objectId)\",\"newdesc\":\"\(name)\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { success in
            if !success {
                self.nameSubject = nil
                subject.onError(CommunicationError.serverError)
            }
        }

        return subject
    }

    func startAlarm(address: InetAddress, token: String, objectId: String) -> Observable<Bool> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                self.objectId = nil
                return Observable<Bool>.error(CommunicationError.socketError)
            }
        }

        let subject = alarmSubject ?? PublishSubject<Bool>()
        alarmSubject = subject

        let query = "{\"$c$\":\"newlk\",\"com\":\"alarmtk\",\"obj\":\"\(objectId)\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: token, to: address) { success in
            if !success {
                self.alarmSubject = nil
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

extension UdpObjectsGateway: RubegSocketDelegate {

    func stringMessageReceived(_ message: String) {
        #if DEBUG
            print("<- \(message)")
        #endif

        guard let sourceData = message.data(using: .utf8) else {
            return
        }

        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: sourceData, options: [])
        else {
            return
        }

        guard let jsonMap = jsonObject as? [String: Any] else {
            return
        }

        guard let client = jsonMap["$c$"] as? String else {
            return
        }

        if client != "newlk" {
            return
        }

        guard let command = jsonMap["com"] as? String else {
            return
        }

        switch command {
        case "getobject":
            guard let result = jsonMap["result"] as? String else {
                let subject = objectsSubject
                objectsSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            if result != "ok" {
                let subject = objectsSubject
                objectsSubject = nil
                subject?.onError(CommunicationError.internalServerError)
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
                let subject = objectsSubject
                objectsSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            let facilities = facilitiesDTO.map { Facility($0) }
            objectsSubject?.onNext(facilities)
            objectsSubject = nil
        case "getevents":
            guard
                let objectId = objectId,
                let data = jsonMap["data"] as? [[String: Any]],
                let jsonData = try? JSONSerialization.data(
                    withJSONObject: data,
                    options: JSONSerialization.WritingOptions()
                ),
                let json = String(data: jsonData, encoding: .utf8),
                let eventsDTO = try? EventDTO.deserializeList(from: json)
            else {
                let subject = eventsSubject
                eventsSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            let events = eventsDTO.map { Event($0, objectId: objectId) }
            eventsSubject?.onNext(events)
            eventsSubject = nil
        case "objectdata":
            guard
                let data = jsonMap["data"] as? [String: Any],
                let jsonData = try? JSONSerialization.data(
                    withJSONObject: data,
                    options: JSONSerialization.WritingOptions()
                ),
                let json = String(data: jsonData, encoding: .utf8),
                let facilityDTO = try? FacilityDTO.deserialize(from: json)
            else {
                let subject = objectDataSubject
                objectDataSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            objectDataSubject?.onNext(Facility(facilityDTO))
            objectDataSubject = nil
        case "lkpspput":
            guard let result = jsonMap["result"] as? String else {
                let subject = nameSubject
                nameSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            nameSubject?.onNext(result == "ok")
            nameSubject = nil
        case "alarmtk":
            guard let result = jsonMap["result"] as? String else {
                let subject = alarmSubject
                alarmSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            alarmSubject?.onNext(result == "start")
            alarmSubject = nil
        case "guard":
            guard let result = jsonMap["result"] as? String else {
                let subject = statusSubject
                statusSubject = nil
                subject?.onError(CommunicationError.parseError)
                return
            }

            statusSubject?.onNext(result == "start")
            statusSubject = nil
        default:
            return
        }
    }

    func binaryMessageReceived(_ message: [Byte]) {}

}
