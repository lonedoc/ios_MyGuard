//
//  CoreDataRepository.swift
//  myprotection
//
//  Created by Rubeg NPO on 31.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import CoreData

class CoreDataRepository<T: NSManagedObject>: Repository {

    typealias Entity = T

    private let context: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        context = managedObjectContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func get(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) -> Result<[T], Error> {
        var result: Result<[T], Error>?

        context.performAndWait {
            let fetchRequest = Entity.fetchRequest()
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors

            do {
                if let fetchResult = try context.fetch(fetchRequest) as? [Entity] {
                    result = .success(fetchResult)
                } else {
                    result = .failure(CoreDataError.invalidManagedObjectType)
                }
            } catch {
                result = .failure(error)
            }
        }

        return result!
    }

    func create() -> Result<T, Error> {
        var result: Result<T, Error>?

        context.performAndWait {
            let className = String(describing: Entity.self)
            guard
                let managedObject = NSEntityDescription.insertNewObject(
                    forEntityName: className,
                    into: context
                ) as? Entity
            else {
                result = .failure(CoreDataError.invalidManagedObjectType)
                return
            }
            result = .success(managedObject)
        }

        return result!
    }

    func delete(entity: T) -> Result<Bool, Error> {
        var result: Result<Bool, Error>?

        context.performAndWait {
            context.delete(entity)
            result = .success(true)
        }

        return result!
    }

}
