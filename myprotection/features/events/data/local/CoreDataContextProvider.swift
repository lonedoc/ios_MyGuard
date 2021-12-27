//
//  CoreDataContextProvider.swift
//  myprotection
//
//  Created by Rubeg NPO on 31.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import CoreData

class CoreDataContextProvider {

    private var persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    init() {
        persistentContainer = NSPersistentContainer(name: "DataModel")
    }

    func loadStores(completionHandler: @escaping ((Error?) -> Void)) {
        persistentContainer.loadPersistentStores { _, error in
            completionHandler(error)
        }
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

}
