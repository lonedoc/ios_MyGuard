//
//  ContainerExtensions.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 09.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject
import CoreData

extension Container {

    static let shared: Container = {
        let container = Container()

        // MARK: - Common

        container.register(AppDataRepository.self) { _ in UserDefaultsAppDataRepository() }
        container.register(CompaniesGateway.self) { _ in UdpCompaniesGateway() }
        container.register(PasswordGateway.self) { _ in UdpPasswordGateway() }
        container.register(LoginGateway.self) { _ in UdpLoginGateway() }
        container.register(Biometry.self) { _ in BiometricAuth() }
        container.register(ObjectsGateway.self) { _ in UdpObjectsGateway() }
        container.register(TestAlarmGateway.self) { _ in UdpTestAlarmGateway() }
        container.register(CoreDataContextProvider.self) { _ in CoreDataContextProvider() }.inObjectScope(.container)

        container.register(UnitOfWork.self) { (_, context: NSManagedObjectContext) in
            return UnitOfWork(context: context)
        }.inObjectScope(.container)

        // MARK: - Login

        container.register(LoginContract.Presenter.self) { resolver in
            let appDataRepository = resolver.resolve(AppDataRepository.self)!
            let companiesGateway = resolver.resolve(CompaniesGateway.self)!

            return LoginPresenter(
                appDataRepository: appDataRepository,
                companiesGateway: companiesGateway
            )
        }

        container.register(LoginContract.View.self) { resolver in
            let presenter = resolver.resolve(LoginContract.Presenter.self)!
            return LoginViewController(with: presenter)
        }

        // MARK: - Password

        container.register(PasswordContract.Presenter.self) { resolver in
            let appDataRepository = resolver.resolve(AppDataRepository.self)!
            let passwordGateway = resolver.resolve(PasswordGateway.self)!
            let loginGateway = resolver.resolve(LoginGateway.self)!

            return PasswordPresenter(
                appDataRepository: appDataRepository,
                passwordGateway: passwordGateway,
                loginGateway: loginGateway
            )
        }

        container.register(PasswordContract.View.self) { resolver in
            let presenter = resolver.resolve(PasswordContract.Presenter.self)!
            return PasswordViewController(with: presenter)
        }

        // MARK: - Passcode

        container.register(PasscodeContract.Presenter.self) { resolver in
            let appDataRepository = resolver.resolve(AppDataRepository.self)!
            let biometry = resolver.resolve(Biometry.self)!
            let loginGateway = resolver.resolve(LoginGateway.self)!

            return PasscodePresenter(
                appDataRepository: appDataRepository,
                biometry: biometry,
                loginGateway: loginGateway
            )
        }

        container.register(PasscodeContract.View.self) { resolver in
            let presenter = resolver.resolve(PasscodeContract.Presenter.self)!
            return PasscodeViewController(with: presenter)
        }

        // MARK: - Objects

        container.register(ObjectsContract.Presenter.self) { (resolver, communicationData: CommunicationData) in
            let objectsGateway = resolver.resolve(ObjectsGateway.self)!

            return ObjectsPresenter(
                objectsGateway: objectsGateway,
                communicationData: communicationData
            )
        }

        container.register(ObjectsContract.View.self) { (resolver, communicationData: CommunicationData) in
            let presenter = resolver.resolve(
                ObjectsContract.Presenter.self,
                argument: communicationData
            )!

            return ObjectsViewController(with: presenter)
        }

        // MARK: - Object

        container.register(ObjectContract.Presenter.self)
            { (resolver, facility: Facility, cd: CommunicationData) in
                let objectsGateway = resolver.resolve(ObjectsGateway.self)!

                return ObjectPresenter(
                    facility: facility,
                    communicationData: cd,
                    objectsGateway: objectsGateway
                )
            }

        container.register(ObjectContract.View.self)
            { (resolver, facility: Facility, communicationData: CommunicationData) in
                let presenter = resolver.resolve(
                    ObjectContract.Presenter.self,
                    arguments: facility, communicationData
                )!

                return ObjectViewController(with: presenter)
            }

        // MARK: - Events

        container.register(EventsContract.Presenter.self)
            { (resolver, objectId: String, cd: CommunicationData, unitOfWork: UnitOfWork?) in
                let objectsGateway = resolver.resolve(ObjectsGateway.self)!

                return EventsPresenter(
                    objectId: objectId,
                    communicationData: cd,
                    objectsGateway: objectsGateway,
                    unitOfWork: unitOfWork
                )
            }

        container.register(EventsContract.View.self)
            { (resolver, objectId: String, cd: CommunicationData, unitOfWork: UnitOfWork?) in
                let presenter = resolver.resolve(
                    EventsContract.Presenter.self,
                    arguments: objectId, cd, unitOfWork
                )!
            
                return EventsViewController(with: presenter)
            }

        // MARK: - Test alarm

        container.register(TestContract.Presenter.self)
            { (resolver, objectId: String, cd: CommunicationData) in
                let testAlarmGateway = resolver.resolve(TestAlarmGateway.self)!

                return TestPresenter(
                    objectId: objectId,
                    communicationData: cd,
                    testAlarmGateway: testAlarmGateway
                )
            }

        container.register(TestContract.View.self)
            { (resolver, objectId: String, cd: CommunicationData) in
                let presenter = resolver.resolve(
                    TestContract.Presenter.self,
                    arguments: objectId, cd
                )!

                return TestViewController(with: presenter)
            }

        return container
    }()

}
