//
//  DomainModel.swift
//  myprotection
//
//  Created by Rubeg NPO on 31.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol DomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}
