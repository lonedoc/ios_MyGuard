//
//  EventsAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 22.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject
import CoreData

class EventsAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CoreDataContextProvider.self) { _ in
            CoreDataContextProvider()
        }.inObjectScope(.container)

        container.register(UnitOfWork.self) { (_, context: NSManagedObjectContext) in
            return UnitOfWork(context: context)
        }.inObjectScope(.container)

        container.register(EventsApi.self) { resolver in
            let communicationData = resolver.resolve(CommunicationData.self)!
            return UdpEventsApi(communicationData: communicationData)
        }

        container.register(EventsRepository.self) { (resolver, unitOfWork: UnitOfWork?) in
            let eventsApi = resolver.resolve(EventsApi.self)!
            return EventsRepositoryImpl(eventsApi: eventsApi, unitOfWork: unitOfWork)
        }

        container.register(EventsInteractor.self) { (resolver, unitOfWork: UnitOfWork?) in
            let repository = resolver.resolve(EventsRepository.self, argument: unitOfWork)!
            return EventsInteractor(repository: repository)
        }

        container.register(EventsPresenter.self) { (resolver, facilityId: String, unitOfWork: UnitOfWork?) in
            let interactor = resolver.resolve(EventsInteractor.self, argument: unitOfWork)!
            return EventsPresenterImpl(facilityId: facilityId, interactor: interactor)
        }
    }

}
