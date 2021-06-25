//
//  EventRepository.swift
//  myprotection
//
//  Created by Rubeg NPO on 31.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import CoreData

protocol EventRepository {
    func getEvents(objectId: String) -> Result<[Event], Error>
    func getEvents(objectId: String, lowerBound: Int, upperBound: Int) -> Result<[Event], Error>
    func create(event: Event) -> Result<Bool, Error>
    func delete(event: Event) -> Result<Bool, Error>
}

class EventRepositoryImpl: EventRepository {

    private let repository: CoreDataRepository<EventMO>

    init(context: NSManagedObjectContext) {
        repository = CoreDataRepository(managedObjectContext: context)
    }

    func getEvents(objectId: String) -> Result<[Event], Error> {
        let predicate = NSPredicate(format: "objectId == %@", objectId as NSString)
        return getEvents(predicate: predicate)
    }

    func getEvents(objectId: String, lowerBound: Int, upperBound: Int) -> Result<[Event], Error> {
        let predicate = NSPredicate(
            format: "objectId == %@ && number >= %d && number < %d",
            objectId as NSString,
            Int32(lowerBound),
            Int32(upperBound)
        )
        return getEvents(predicate: predicate)
    }

    func create(event: Event) -> Result<Bool, Error> {
        let result = repository.create()
        switch result {
        case .success(let eventMO):
            eventMO.objectId = event.objectId
            eventMO.number = Int32(event.number)
            eventMO.timestamp = event.timestamp
            eventMO.type = Int32(event.type)
            eventMO.eventDescription = event.description
            eventMO.zoneDescription = event.zone

            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }

    func delete(event: Event) -> Result<Bool, Error> {
        let predicate = NSPredicate(
            format: "objectId == %@ && number == %@",
            event.objectId as NSString,
            Int32(event.number)
        )

        let result = repository.get(predicate: predicate, sortDescriptors: nil)

        switch result {
        case .success(let eventsMO):
            for eventMO in eventsMO {
                if case .failure(let error) = repository.delete(entity: eventMO) {
                    return .failure(error)
                }
            }
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func getEvents(predicate: NSPredicate) -> Result<[Event], Error> {
        let result = repository.get(predicate: predicate, sortDescriptors: nil)

        switch result {
        case .success(let eventsMO):
            let events = eventsMO.map { eventMO in
                return eventMO.toDomainModel()
            }
            return .success(events)
        case .failure(let error):
            return .failure(error)
        }
    }

}
