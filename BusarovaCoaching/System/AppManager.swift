//
//  AppManager.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 18/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import Firebase

class AppManager {
    weak var appDelegate: AppDelegate?
    private var currentUser: User?
    
    class var shared: AppManager {
        return (UIApplication.shared.delegate as! AppDelegate).appManager
    }
    
// MARK: - public methods
    /// Initialises the AppManager as well, as the FirebaseController
    /// The functions is called from the AppDelegate
    ///
    /// - Parameter with: AppDelegate
    func getStarted(with appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        configureFireBase()
        
        let keychainController = KeychainController()
        
        if keychainController.keychainItemExists() {
            let authVC = AuthorizationViewController()
            appDelegate.window = UIWindow()
            appDelegate.window?.rootViewController = authVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    /// Stores logged in user
    ///
    /// - Parameter as: logged in user
    func loggedIn(as user: User) {
        currentUser = user
        print("logged in as \(user)")
    }
    
    /// Indicates if the current user has been already autorized
    ///
    /// - Returns: **true** if current user has been already authorized. And **false** if there is no authorized user
    func isAuhorized() -> Bool {
        return currentUser == nil ? false : true
    }
    
    /// Starts the initial comtroller according to the Main.storyboard
    func presentInitialController() {
        guard let appDelegate = appDelegate else {
            return
        }
        
        appDelegate.window = UIWindow()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialController = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifiers.initialController.rawValue)
        appDelegate.window?.rootViewController = initialController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    /// Indicates if the current user has grants to open the requested document
    ///
    /// - Parameter to: collection in the firebase
    /// - Parameter with: identifier of the parent of the requested document
    /// - Returns: **true** if current user has permissions, and **false** if there is no authorized user, or he/she doesn't have required permissions.
    /// - Todo: Implement the functionality for the user role. At the moment, for user the function always returns **false**
    func currentUserHasPermission(to table: DBTables, with parentID: String) -> Bool {
        guard let currentUser = currentUser else {
            return false
        }
        
        switch currentUser.userRole {
        case .admin:
            return true
        case .user:
            return false
        }
    }
    
// MARK: - private methods
    private func configureFireBase() {
        FirebaseApp.configure()
        FirebaseController.shared.setDataController(DataController())
        FirebaseController.shared.setStorageController(StorageController())
    }
}
