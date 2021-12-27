//
//  EventMO+CoreDataProperties.swift
//  myprotection
//
//  Created by Rubeg NPO on 31.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//
//

import Foundation
import CoreData

extension EventMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventMO> {
        return NSFetchRequest<EventMO>(entityName: "Event")
    }

    @NSManaged public var eventDescription: String
    @NSManaged public var number: Int32
    @NSManaged public var objectId: String
    @NSManaged public var timestamp: Date?
    @NSManaged public var type: Int32
    @NSManaged public var zoneDescription: String

}

extension EventMO: DomainModel {

    func toDomainModel() -> Event {
        return Event(
            facilityId: objectId,
            number: Int(number),
            timestamp: timestamp,
            type: Int(type),
            description: eventDescription,
            zone: zoneDescription
        )
    }

}
