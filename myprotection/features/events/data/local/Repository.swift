//
//  Repository.swift
//  myprotection
//
//  Created by Rubeg NPO on 31.03.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype Entity
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error>
    func create() -> Result<Entity, Error>
    func delete(entity: Entity) -> Result<Bool, Error>
}
