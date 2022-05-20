//
//  ApplicationsApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.05.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

protocol ApplicationsApi {
    func getApplications() -> Observable<[String]>
    func sendApplication(facilityId: String, text: String, timestamp: Int64) -> Observable<Bool>
}
