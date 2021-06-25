//
//  CacheManager.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 02/07/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation

protocol AppDataRepository {
    func set(fcmToken: String)
    func getFcmToken() -> String?
    func set(company: Company)
    func getCompany() -> Company?
    func set(phone: String)
    func getPhone() -> String?
    func set(password: String)
    func getPassword() -> String?
    func set(user: User)
    func getUser() -> User?
    func set(factory: Factory)
    func getFactory() -> Factory?
    func set(token: String)
    func getToken() -> String?
    func set(passcode: String)
    func getPasscode() -> String?
    func reset()
    func reset(key: AppDataKey)
}

enum AppDataKey: String, CaseIterable {
    case fcmToken     = "fcmToken"
    case city         = "city"
    case company      = "company"
    case ip           = "ip"
    case phone        = "phone"
    case password     = "password"
    case userId       = "userId"
    case userName     = "userName"
    case factoryName  = "factoryName"
    case factoryPhone = "factoryPhone"
    case token        = "token"
    case passcode     = "passcode"
}

class UserDefaultsAppDataRepository : AppDataRepository {

    func set(fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: AppDataKey.fcmToken.rawValue)
    }

    func getFcmToken() -> String? {
        return UserDefaults.standard.string(forKey: AppDataKey.fcmToken.rawValue)
    }

    func set(company: Company) {
        UserDefaults.standard.set(company.city, forKey: AppDataKey.city.rawValue)
        UserDefaults.standard.set(company.name, forKey: AppDataKey.company.rawValue)
        UserDefaults.standard.set(company.ip, forKey: AppDataKey.ip.rawValue)
    }

    func getCompany() -> Company? {
        guard
            let city = UserDefaults.standard.string(forKey: AppDataKey.city.rawValue),
            let company = UserDefaults.standard.string(forKey: AppDataKey.company.rawValue),
            let ip = UserDefaults.standard.stringArray(forKey: AppDataKey.ip.rawValue)
        else {
            return nil
        }

        return Company(city: city, name: company, ip: ip)
    }

    func set(phone: String) {
        UserDefaults.standard.set(phone, forKey: AppDataKey.phone.rawValue)
    }

    func getPhone() -> String? {
        return UserDefaults.standard.string(forKey: AppDataKey.phone.rawValue)
    }

    func set(password: String) {
        UserDefaults.standard.set(password, forKey: AppDataKey.password.rawValue)
    }

    func getPassword() -> String? {
        return UserDefaults.standard.string(forKey: AppDataKey.password.rawValue)
    }

    func set(user: User) {
        UserDefaults.standard.set(user.id, forKey: AppDataKey.userId.rawValue)
        UserDefaults.standard.set(user.name, forKey: AppDataKey.userName.rawValue)
    }

    func getUser() -> User? {
        if UserDefaults.standard.object(forKey: AppDataKey.userId.rawValue) == nil {
            return nil
        }

        guard let name = UserDefaults.standard.string(forKey: AppDataKey.userName.rawValue) else {
            return nil
        }

        let id = UserDefaults.standard.integer(forKey: AppDataKey.userId.rawValue)

        return User(id: id, name: name)
    }

    func set(factory: Factory) {
        UserDefaults.standard.set(factory.name, forKey: AppDataKey.factoryName.rawValue)
        UserDefaults.standard.set(factory.phone, forKey: AppDataKey.factoryPhone.rawValue)
    }

    func getFactory() -> Factory? {
        guard
            let factoryName = UserDefaults.standard.string(forKey: AppDataKey.factoryName.rawValue),
            let factoryPhone = UserDefaults.standard.string(forKey: AppDataKey.factoryPhone.rawValue)
        else {
            return nil
        }

        return Factory(name: factoryName, phone: factoryPhone)
    }

    func set(token: String) {
        UserDefaults.standard.set(token, forKey: AppDataKey.token.rawValue)
    }

    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: AppDataKey.token.rawValue)
    }

    func set(passcode: String) {
        UserDefaults.standard.set(passcode, forKey: AppDataKey.passcode.rawValue)
    }

    func getPasscode() -> String? {
        return UserDefaults.standard.string(forKey: AppDataKey.passcode.rawValue)
    }

    func reset() {
        AppDataKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
    
    func reset(key: AppDataKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

}
