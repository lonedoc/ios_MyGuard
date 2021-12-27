//
//  HttpCompaniesApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Alamofire

private let ipAddresses = ["94.177.183.4", "91.189.160.38"]

class HttpCompaniesApi: CompaniesApi {

    private var addresses: Rotator<String> = {
        do {
            return try Rotator<String>.create(items: ipAddresses)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }()

    private var success: (([Company]) -> Void)?
    private var failure: ((Error) -> Void)?

    func getCompanies(
        success: @escaping ([Company]) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        self.success = success
        self.failure = failure

        makeRequest()
    }

    private func makeRequest(_ attempts: Int = 5) {
        if attempts < 1 {
            handleError(CommunicationError.serverError)
        }

        let address = addresses.current
        let url = "http://\(address)/getcity"

        AF.request(url, method: .get).responseString { [weak self] response in
            switch response.result {
            case .success(let data):
                if let companies = self?.decodeResponse(data) {
                    self?.handleData(companies)
                } else {
                    self?.handleError(CommunicationError.parseError)
                }
            case .failure(_):
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
    }

    private func decodeResponse(_ data: String) -> [Company]? {
        let coder = Coder()

        guard
            let bytes = coder.decode(data),
            let json = String(bytes: bytes, encoding: .utf8),
            let companiesDTO = try? CompaniesDTO.parse(json: json)
        else {
            return nil
        }

        let companies = companiesDTO.data.flatMap { city in
            city.companies.map { companyDTO in
                Company(city: city.name, name: companyDTO.name, ip: companyDTO.ip)
            }
        }

        return companies
    }

}
