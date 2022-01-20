//
//  CompaniesApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

protocol GuardServicesApi {
    func getGuardServices() -> Observable<[GuardService]>
    func getAddresses(cityName: String, guardServiceName: String) -> Observable<[String]>
}
