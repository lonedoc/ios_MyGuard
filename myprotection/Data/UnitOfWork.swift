//
//  UnitOfWork.swift
//  myprotection
//
//  Created by Rubeg NPO on 31.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import CoreData

class UnitOfWork {

    private let context: NSManagedObjectContext

    let eventRepository: EventRepository

    init(context: NSManagedObjectContext) {
        self.context = context
        self.eventRepository = EventRepositoryImpl(context: context)
    }

    func saveChanges() -> Result<Bool, Error> {
        do {
            try context.save()
            return .success(true)
        } catch {
            context.rollback()
            return .failure(error)
        }
    }

}
