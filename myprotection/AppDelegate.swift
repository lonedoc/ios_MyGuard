//
//  AppDelegate.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import Swinject
import Firebase
import UserNotifications

private let nano: UInt64 = 1_000_000_000
private let autoLogoutInterval: UInt64 = 300 // seconds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var enterBackgroundTime: DispatchTime?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureWindow()
        configureFirebase(for: application)

        return true
    }

    private func configureWindow() {
        if #available(iOS 13.0, *) {
            // nothing here
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = getRootViewController()
            window?.makeKeyAndVisible()
        }
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

    private func configureFirebase(for application: UIApplication) {
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        enterBackgroundTime = .now()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let startTime = enterBackgroundTime else {
            return
        }

        let endTime = DispatchTime.now()

        let elapsedTimeNano = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let elapsedTimeSec = elapsedTimeNano / nano

        if elapsedTimeSec > autoLogoutInterval {
            window?.rootViewController = getRootViewController()
            window?.makeKeyAndVisible()
        }

        enterBackgroundTime = nil
    }

}

// MARK: - MessagingDelegate, UNUserNotificationCenterDelegate

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        #if DEBUG
            print("APNS Token: \(deviceToken)")
        #endif

        Messaging.messaging().apnsToken = deviceToken
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        #if DEBUG
            print("FCM Token: \(fcmToken ?? "")")
        #endif

        UserDefaultsAppDataRepository().set(fcmToken: fcmToken ?? "")
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        #if DEBUG
            print("User tapped the alert")
        #endif

        completionHandler()
    }

}
