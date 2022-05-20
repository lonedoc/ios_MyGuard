//
//  ApplicationsInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.05.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

class ApplicationsInteractor {

    private let applicationsApi: ApplicationsApi

    init(applicationsApi: ApplicationsApi) {
        self.applicationsApi = applicationsApi
    }

    func getPredefinedApplications() -> Observable<[String]> {
        return applicationsApi.getApplications()
    }

    func sendApplication(facilityId: String, text: String, timestamp: Date) -> Observable<Bool> {
        let timestampEpoch = Int64(timestamp.timeIntervalSince1970)
        return applicationsApi.sendApplication(facilityId: facilityId, text: text, timestamp: timestampEpoch)
    }

}
