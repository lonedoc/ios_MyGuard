//
//  TestApi.swift
//  myprotection
//
//  Created by Rubeg NPO on 22.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

protocol TestApi {
    func startTestMode(facilityId: String) -> Observable<Int>
    func stopTestMode(facilityId: String) -> Observable<Bool>
    func resetAlarmButtons(facilityId: String) -> Observable<Bool>
    func getStatus(facilityId: String) -> Observable<TestStatus>
}
