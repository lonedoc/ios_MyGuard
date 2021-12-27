//
//  UdpCompaniesApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RubegProtocol_v2_0

private let ipAddresses = ["94.177.183.4", "91.189.160.38"]
private let port: Int32 = 8300

class UdpCompaniesApi: CompaniesApi {

    private lazy var socket: RubegSocket = {
        let socket = RubegSocket(dropUnexpected: false)
        socket.delegate = self
        return socket
    }()

    private var addresses: Rotator<InetAddress> = {
        //swiftlint:disable:next identifier_name
        let addresses = ipAddresses.compactMap { ip in
            InetAddress.create(ip: ip, port: port)
        }

        return Rotator<String>.create(items: addresses)
    }()

    private var success: (([Company]) -> Void)?
    private var failure: ((Error) -> Void)?

    func getCompanies(
        success: @escaping ([Company]) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        self.success = success
        self.failure = failure

        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                #if DEBUG
                    print(error.localizedDescription)
                #endif

                handleError(CommunicationError.socketError)
            }
        }

        makeRequest()
    }

    private func makeRequest(_ attempts: Int = 5) {
        if attempts < 1 {
            handleError(CommunicationError.serverError)
        }

        guard let address = addresses.current else {
            handleError(CommunicationError.socketError) // TODO: Replace with dedicated error
            return
        }

        let query = "{\"$c$\": \"getcity\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: nil, to: address) { [weak self] success in
            if !success {
                _ = self?.addresses.next()
                self?.makeRequest(attempts - 1)
            }
        }
    }

    private func handleData(_ data: [Company]) {
        success?(data)
        reset()
    }

    private func handleError(_ error: Error) {
        failure?(error)
        reset()
    }

    private func reset() {
        success = nil
        failure = nil

        socket.close()
    }

}

// MARK: - RubegSocketDelegate

extension UdpCompaniesApi: RubegSocketDelegate {

    func stringMessageReceived(_ message: String) {
        #if DEBUG
            print("<- \(message)")
        #endif

        guard let response = parseResponse(source: message) else {
            return
        }

        if response.command != "city" {
            return
        }

        guard let companiesDTO = try? CompaniesDTO.parse(json: response.data) else {
            handleError(CommunicationError.parseError)
            return
        }

        let companies = companiesDTO.data.flatMap { city in
            city.companies.map { companyDTO in
                Company(city: city.name, name: companyDTO.name, ip: companyDTO.ip)
            }
        }

        handleData(companies)
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
