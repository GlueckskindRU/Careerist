//
//  AppDelegate.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import FirebaseMessaging
//import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let notificationId = "gcm.notification.id"
    var appManager = AppManager()
    var coreDataManager = CoreDataManager(modelName: "CoreData")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 11.0, *) {
            if let initialTabBarController = window?.rootViewController as? UITabBarController {
                for controller in initialTabBarController.viewControllers ?? [UINavigationController()] {
                    if let navController = controller as? UINavigationController {
                        navController.navigationBar.prefersLargeTitles = true
                    }
                }
            }
            
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)]
        }
        
        appManager.getStarted(with: self, application: application)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
//        print(String(describing: userInfo))
//        guard
//            let updateType = (userInfo["updateType"] as? NSString)?.uppercased,
//            let informationType = (userInfo["informationType"] as? NSString)?.uppercased,
//             else {
//                return
//        }
        
        guard
            let currentUser = appManager.getCurrentUser(),
            let initialTabBarController = window?.rootViewController as? UITabBarController,
            let cabinetNavigationController = initialTabBarController.viewControllers?[TabsSequence.cabinet.rawValue] as? UINavigationController else {
                return
        }
        
        let queue = DispatchQueue(label: "AppDelegate.refreshNotificationQueue", qos: .userInitiated)
        
        let notificationController = NotificationsController(coreDataManager: coreDataManager, currentUser: currentUser, queue: queue)

        notificationController.fetchAllWaitingPushes {
            DispatchQueue.main.async {
                initialTabBarController.selectedIndex = TabsSequence.cabinet.rawValue
                cabinetNavigationController.popViewController(animated: true)
            }
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

