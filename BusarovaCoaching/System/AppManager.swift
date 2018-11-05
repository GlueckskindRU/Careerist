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
    
    /// Indicates if the current user has been already subscribed to the requested indicator of the
    /// characteristics competence
    ///
    /// - Parameter to: requested characteristic
    /// - Returns: **true** if current user has already subscribed to requsted indicator of the characteristics competence. Also, if user has the **Admin** userrole, **true** will be always returned. **False** will be returned if not the indicator of the characteristics competence was requested, or there is no subscription to the requested indicator
    func isSubscribed(to characteristic: CharacteristicsModel) -> Bool {
        guard let currentUser = currentUser else {
            return false
        }
        
        switch currentUser.userRole {
        case .admin:
            switch characteristic.level{
            case .indicatorsOfCompetentions:
                return true
            default:
                return false
            }
        case .user:
            switch characteristic.level {
            case .indicatorsOfCompetentions:
                return currentUser.subscribedCharacteristics.contains(characteristic.id)
            default:
                return false
            }
        }
    }
    
    /// Performs the subscription or unsubscription of the current user to the requested indicator
    /// of the characteristics competence
    ///
    /// - Parameter to: requested characteristic
    /// - Parameter subscribe: indicates the action: **true** means subscription, **false** means unsubscription
    /// - Parameter completion: completion closure (Result < Bool >) -> Void. If current user has been
    /// already subscribed to the requested indicator **Result.success(false)** will be called.
    func performSubscriptionAction(to characteristic: CharacteristicsModel, subscribe: Bool, completion: @escaping (Result<Bool>) -> Void) {
        guard var currentUser = currentUser else {
            return completion(Result.failure(AppError.notAuthorized))
        }
        
        if characteristic.level != CharacteristicsLevel.indicatorsOfCompetentions {
            return completion(Result.failure(AppError.incorrectCharacteristicLevel))
        }
        
        if subscribe && isSubscribed(to: characteristic) {
            return completion(Result.success(false))
        }
        
        if !subscribe && !isSubscribed(to: characteristic) {
            return completion(Result.success(false))
        }
        
        if subscribe {
            currentUser.subscribedCharacteristics.append(characteristic.id)
        } else {
            if let unsubscribedIndex = currentUser.subscribedCharacteristics.firstIndex(of: characteristic.id) {
                currentUser.subscribedCharacteristics.remove(at: unsubscribedIndex)
            } else {
                return completion(Result.success(false))
            }
        }
        
        FirebaseController.shared.getDataController().saveData(currentUser, with: currentUser.id, in: DBTables.users) {
            (result: Result<User>) in
            
            switch result {
            case .success(let user):
                self.currentUser = user
                completion(Result.success(true))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
// MARK: - private methods
    private func configureFireBase() {
        FirebaseApp.configure()
        FirebaseController.shared.setDataController(DataController())
        FirebaseController.shared.setStorageController(StorageController())
    }
}
