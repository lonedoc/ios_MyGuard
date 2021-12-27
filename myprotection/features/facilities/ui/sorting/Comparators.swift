//
//  Comparators.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol FacilitiesComparator {
    func compare(_ lhs: Facility, _ rhs: Facility) -> Bool
}

extension FacilitiesComparator {

    fileprivate func compareByName(_ lhs: Facility, _ rhs: Facility, reverse: Bool) -> Bool? {
        let lhsName = lhs.name.lowercased()
        let rhsName = rhs.name.lowercased()

        if lhsName == rhsName {
            return nil
        }

        return reverse ? lhsName > rhsName : lhsName < rhsName
    }

    fileprivate func compareByAddress(_ lhs: Facility, _ rhs: Facility, reverse: Bool) -> Bool? {
        let lhsAddress = lhs.address.lowercased()
        let rhsAddress = rhs.address.lowercased()

        if lhsAddress == rhsAddress {
            return nil
        }

        return reverse ? lhsAddress > rhsAddress : lhsAddress < rhsAddress
    }

    fileprivate func compareByStatus(_ lhs: Facility, _ rhs: Facility) -> Bool? {
        if lhs.statusCode == rhs.statusCode {
            return nil
        }

        return lhs.statusCode > rhs.statusCode
    }

}

class NameFirstFacilitiesComparator: FacilitiesComparator {

    private var reverse: Bool

    init(ascending: Bool = true) {
        reverse = !ascending
    }

    func compare(_ lhs: Facility, _ rhs: Facility) -> Bool {
        return
            compareByName(lhs, rhs, reverse: reverse) ??
            compareByStatus(lhs, rhs) ??
            compareByAddress(lhs, rhs, reverse: reverse) ??
            false
    }

}

class AddressFirstFacilitiesComparator: FacilitiesComparator {

    private var reverse: Bool

    init(ascending: Bool = true) {
        reverse = !ascending
    }

    func compare(_ lhs: Facility, _ rhs: Facility) -> Bool {
        return
            compareByAddress(lhs, rhs, reverse: reverse) ??
            compareByStatus(lhs, rhs) ??
            compareByName(lhs, rhs, reverse: reverse) ??
            false
    }

}

class StatusFirstFacilitiesComparator: FacilitiesComparator {

    func compare(_ lhs: Facility, _ rhs: Facility) -> Bool {
        return
            compareByStatus(lhs, rhs) ??
            compareByName(lhs, rhs, reverse: false) ??
            compareByAddress(lhs, rhs, reverse: false) ??
            false
    }

}
