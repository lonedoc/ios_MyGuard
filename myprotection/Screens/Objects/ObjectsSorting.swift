//
//  ObjectsSorting.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

enum ObjectsSorting: Int, CaseIterable {
    case byNameAscending     = 0
    case byNameDescending    = 1
    case byAddressAscending  = 2
    case byAddressDescending = 3
    case byStatus            = 4
}
