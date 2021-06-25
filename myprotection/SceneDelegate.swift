//
//  SceneDelegate.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import Swinject

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        configureWindow(scene: scene)
    }

    private func configureWindow(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = getRootViewController()
        window?.makeKeyAndVisible()
    }

    private func getRootViewController() -> UIViewController {
        let appDataRepository = Container.shared.resolve(AppDataRepository.self)!

        if isRegistered(appDataRepository) {
            let viewController = Container.shared.resolve(PasscodeContract.View.self)!
            return NavigationController(rootViewController: viewController)
        } else {
            return Container.shared.resolve(LoginContract.View.self)!
        }
    }

    private func isRegistered(_ repository: AppDataRepository) -> Bool {
        return
            repository.getCompany()  != nil &&
            repository.getPhone()    != nil &&
            repository.getUser()     != nil &&
            repository.getFactory()  != nil &&
            repository.getToken()    != nil &&
            repository.getPasscode() != nil
    }

}
