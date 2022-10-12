//
//  CacheManager.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 02/07/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name

protocol UserDefaultsHelper {
    func set(fcmToken: String)
    func getFcmToken() -> String?
    func set(phone: String)
    func getPhone() -> String?
    func set(password: String)
    func getPassword() -> String?
    func set(user: User)
    func getUser() -> User?
    func set(guardService: GuardService)
    func getGuardService() -> GuardService?
    func set(token: String)
    func getToken() -> String?
    func set(passcode: String)
    func getPasscode() -> String?
    func reset()
    func reset(key: UserDefaultsKey)
}

enum UserDefaultsKey: String, CaseIterable {
    case fcmToken
    case city
    case company
    case ip
    case phone
    case password
    case userId
    case userName
    case guardServiceName
    case guardServicePhone
    case token
    case passcode
}

class UserDefaultsHelperImpl: UserDefaultsHelper {

    func set(fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: UserDefaultsKey.fcmToken.rawValue)
    }

    func getFcmToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.fcmToken.rawValue)
    }

    func set(guardService: GuardService) {
        UserDefaults.standard.set(guardService.city, forKey: UserDefaultsKey.city.rawValue)
        UserDefaults.standard.set(guardService.name, forKey: UserDefaultsKey.company.rawValue)
        UserDefaults.standard.set(guardService.hosts, forKey: UserDefaultsKey.ip.rawValue)
        UserDefaults.standard.set(guardService.displayedName, forKey: UserDefaultsKey.guardServiceName.rawValue)
        UserDefaults.standard.set(guardService.phoneNumber, forKey: UserDefaultsKey.guardServicePhone.rawValue)
    }

    func getGuardService() -> GuardService? {
        guard
            let city = UserDefaults.standard.string(forKey: UserDefaultsKey.city.rawValue),
            let company = UserDefaults.standard.string(forKey: UserDefaultsKey.company.rawValue),
            let hosts = UserDefaults.standard.stringArray(forKey: UserDefaultsKey.ip.rawValue)
        else {
            return nil
        }

        let displayedName = UserDefaults.standard.string(forKey: UserDefaultsKey.guardServiceName.rawValue)
        let phoneNumber = UserDefaults.standard.string(forKey: UserDefaultsKey.guardServicePhone.rawValue)

        return GuardService(
            city: city,
            name: company,
            hosts: hosts,
            displayedName: displayedName,
            phoneNumber: phoneNumber
        )
    }

    func set(phone: String) {
        UserDefaults.standard.set(phone, forKey: UserDefaultsKey.phone.rawValue)
    }

    func getPhone() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.phone.rawValue)
    }

    func set(password: String) {
        UserDefaults.standard.set(password, forKey: UserDefaultsKey.password.rawValue)
    }

    func getPassword() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.password.rawValue)
    }

    func set(user: User) {
        UserDefaults.standard.set(user.id, forKey: UserDefaultsKey.userId.rawValue)
        UserDefaults.standard.set(user.name, forKey: UserDefaultsKey.userName.rawValue)
    }

    func getUser() -> User? {
        if UserDefaults.standard.object(forKey: UserDefaultsKey.userId.rawValue) == nil {
            return nil
        }

        guard let name = UserDefaults.standard.string(forKey: UserDefaultsKey.userName.rawValue) else {
            return nil
        }

        let id = UserDefaults.standard.integer(forKey: UserDefaultsKey.userId.rawValue)

        return User(id: id, name: name)
    }

    func set(token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKey.token.rawValue)
    }

    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.token.rawValue)
    }

    func set(passcode: String) {
        UserDefaults.standard.set(passcode, forKey: UserDefaultsKey.passcode.rawValue)
    }

    func getPasscode() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.passcode.rawValue)
    }

    func reset() {
        UserDefaultsKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }

    func reset(key: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

}
