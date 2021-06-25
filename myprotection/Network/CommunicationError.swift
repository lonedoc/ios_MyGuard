//
//  CommunicationError.swift
//  myprotection
//
//  Created by Rubeg NPO on 11.12.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation

enum CommunicationErrorType {
    case socketError
    case serverError
    case internalServerError
    case parseError
    case authError
}

class CommunicationError: LocalizedError {

    static let socketError = CommunicationError(message: "could not open socket", type: .socketError)
    static let serverError = CommunicationError(message: "server not responding", type: .serverError)
    static let internalServerError = CommunicationError(message: "internal server error", type: .internalServerError)
    static let parseError = CommunicationError(message: "could not parse data", type: .parseError)
    static let authError = CommunicationError(message: "access denied", type: .authError)

    private let message: String

    public let type: CommunicationErrorType

    init(message: String, type: CommunicationErrorType) {
        self.message = message
        self.type = type
    }

    var errorDescription: String? {
        return message
    }

}
