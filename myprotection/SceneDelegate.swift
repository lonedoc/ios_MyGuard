//
//  SceneDelegate.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import Swinject

private let nano: UInt64 = 1_000_000_000
private let autoLogoutinterval: UInt64 = 300 // seconds

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var enterBackgroundTime: DispatchTime?

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
        let userDefaultsHelper = Assembler.shared.resolver.resolve(UserDefaultsHelper.self)!

        if isRegistered(userDefaultsHelper) {
            let viewController = PasscodeViewController()
            return NavigationController(rootViewController: viewController)
        } else {
            return LoginViewController()
        }
    }

    private func isRegistered(_ userDefaultsHelper: UserDefaultsHelper) -> Bool {
        return
            userDefaultsHelper.getGuardService() != nil &&
            userDefaultsHelper.getPhone()        != nil &&
            userDefaultsHelper.getUser()         != nil &&
            userDefaultsHelper.getToken()        != nil &&
            userDefaultsHelper.getPasscode()     != nil
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        enterBackgroundTime = .now()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let startTime = enterBackgroundTime else {
            return
        }

        let endTime = DispatchTime.now()

        let distanceNano = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let distanceSec = distanceNano / nano

        if distanceSec > autoLogoutinterval {
            window?.rootViewController = getRootViewController()
            window?.makeKeyAndVisible()
        }

        enterBackgroundTime = nil
    }

}
