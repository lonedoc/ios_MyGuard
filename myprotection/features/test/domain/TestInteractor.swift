//
//  TestInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 22.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

class TestInteractor {

    private let testApi: TestApi

    init(testApi: TestApi) {
        self.testApi = testApi
    }

    func startTest(facilityId: String) -> Observable<Int> {
        return testApi.startTestMode(facilityId: facilityId)
    }

    func stopTest(facilityId: String) -> Observable<Bool> {
        return testApi.stopTestMode(facilityId: facilityId)
    }

    func resetAlarmButtons(facilityId: String) -> Observable<Bool> {
        return testApi.resetAlarmButtons(facilityId: facilityId)
    }

    func getStatus(facilityId: String) -> Observable<TestStatus> {
        return testApi.getStatus(facilityId: facilityId)
    }

}
