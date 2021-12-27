//
//  Rotator.swift
//  myprotection
//
//  Created by Rubeg NPO on 17.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

class Rotator<ItemType> {

    static func create<ItemType>(items: [ItemType]) -> Rotator<ItemType> {
        return ArrayRotator(items: items)
    }

    fileprivate init() {}

    var current: ItemType? {
        fatalError("Unimplemented abstract property")
    }

    func next() -> ItemType? {
        fatalError("Unimplemented abstract method")
    }

    func map<NewType>(transform: @escaping (ItemType) -> NewType) -> Rotator<NewType> {
        return MappingRotator(rotator: self, transform: transform)
    }

}

private class ArrayRotator<ItemType>: Rotator<ItemType> {

    private let items: [ItemType]
    @Atomic private var index = 0

    init(items: [ItemType]) {
        self.items = items
        super.init()
    }

    override var current: ItemType? {
        if items.count == 0 {
            return nil
        }

        return items[index]
    }

    override func next() -> ItemType? {
        if items.count == 0 {
            return nil
        }

        index = (index + 1) % items.count
        return items[index]
    }

}

private class MappingRotator<ItemType, SourceItemType>: Rotator<ItemType> {

    private let rotator: Rotator<SourceItemType>
    private let transform: (SourceItemType) -> ItemType

    init(rotator: Rotator<SourceItemType>, transform: @escaping (SourceItemType) -> ItemType) {
        self.rotator = rotator
        self.transform = transform
    }

    override var current: ItemType? {
        if let item = rotator.current {
            return transform(item)
        }

        return nil
    }

    override func next() -> ItemType? {
        if let item = rotator.next() {
            return transform(item)
        }

        return nil
    }

}
