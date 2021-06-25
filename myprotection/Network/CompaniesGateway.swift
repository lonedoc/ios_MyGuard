//
//  CitiesGateway.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.11.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift
import RubegProtocol_v2_0

protocol CompaniesGateway {
    func getCompanies(address: InetAddress) -> Observable<[Company]>
    func close()
}

class UdpCompaniesGateway: CompaniesGateway {

    private var companiesSubject: PublishSubject<[Company]>?

    private lazy var socket: RubegSocket = {
        let socket = RubegSocket(dropUnexpected: false)
        socket.delegate = self
        return socket
    }()

    func getCompanies(address: InetAddress) -> Observable<[Company]> {
        if !socket.opened {
            do {
                try socket.open()
            } catch let error {
                print(error.localizedDescription)
                return Observable<[Company]>.error(CommunicationError.socketError)
            }
        }

        let subject = companiesSubject ?? PublishSubject<[Company]>()
        companiesSubject = subject

        let query = "{\"$c$\": \"getcity\"}"

        #if DEBUG
            print("-> \(query)")
        #endif

        socket.send(message: query, token: nil, to: address) { success in
            if !success {
                self.companiesSubject = nil
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

extension UdpCompaniesGateway: RubegSocketDelegate {

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
            let subject = companiesSubject
            companiesSubject = nil
            subject?.onError(CommunicationError.parseError)

            return
        }

        let companies = companiesDTO.data.flatMap { city in
            city.companies.map { companyDTO in
                Company(city: city.name, name: companyDTO.name, ip: companyDTO.ip)
            }
        }

        companiesSubject?.onNext(companies)
    }

    func binaryMessageReceived(_ message: [Byte]) { }

}
