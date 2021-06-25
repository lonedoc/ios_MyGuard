//
//  BiometricAuth.swift
//  myprotection
//
//  Created by Rubeg NPO on 30.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometryType {
    case none, touchID, faceID
}

protocol Biometry {
    func isAvailable() -> Bool
    func biometryType() -> BiometryType
    func authenticate(completion: @escaping (Bool, String?) -> Void)
}

class BiometricAuth: Biometry {

    private let context = LAContext()
    private let loginReason = "Authentication is required to access the data".localized

    func isAvailable() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    func biometryType() -> BiometryType {
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)

        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            return .none
        }
    }

    func authenticate(completion: @escaping (Bool, String?) -> Void) {
        guard isAvailable() else {
            completion(false, "Biometric authentication is unavailable".localized)
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: loginReason
        ) { (success, error) in
            if success {
                completion(true, nil)
            } else {
                let message = self.getErrorMessage(by: error)
                completion(false, message)
            }
        }
    }

    private func getErrorMessage(by error: Error?) -> String? {
        switch error {
        case LAError.userCancel?:
            return nil
        case LAError.userFallback?:
            return nil
        case LAError.authenticationFailed?:
            return "Authentication failed".localized
        case LAError.biometryNotAvailable?:
            return "Biometric authentication is unavailable".localized
        case LAError.biometryNotEnrolled?:
            return "Biometry is not configured".localized
        case LAError.biometryLockout?:
            return "Biometry is locked out".localized
        default:
            return "Biometry is not configured".localized
        }
    }

}
