//
//  getErrorMessage.swift
//  myprotection
//
//  Created by Rubeg NPO on 05.07.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

func getErrorMessage(by error: Error) -> String {
    guard let error = error as? CommunicationError else {
        return "Unknown error".localized
    }

    switch error.type {
    case .socketError:
        return "Could not send request".localized
    case .serverError:
        return "Server not responding".localized
    case .internalServerError:
        return "The operation could not be performed".localized
    case .parseError:
        return "Unable to read server response".localized
    case .authError:
        return "Wrong password".localized
    case .userNotFoundError:
        return "Could not find user by provided phone number".localized
    }
}
