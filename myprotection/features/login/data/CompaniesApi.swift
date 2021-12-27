//
//  CompaniesApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol CompaniesApi {
    func getCompanies(
        success: @escaping ([Company]) -> Void,
        failure: @escaping (Error) -> Void
    )
}
