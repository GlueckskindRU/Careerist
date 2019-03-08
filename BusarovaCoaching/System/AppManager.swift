//
//  AppManager.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 18/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class AppManager {
    weak var appDelegate: AppDelegate?
    private var currentUser: User?
    
    private let keychainController = KeychainController()
    
    class var shared: AppManager {
        return (UIApplication.shared.delegate as! AppDelegate).appManager
    }
    
// MARK: - public methods
    /// Initialises the AppManager as well, as the FirebaseController
    /// The functions is called from the AppDelegate
    ///
    /// - Parameter with: AppDelegate
    func getStarted(with appDelegate: AppDelegate, application: UIApplication) {
        self.appDelegate = appDelegate
        configureFireBase(application)
        
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
        checkToken()
    }
    
    /// Indicates if the current user has been already autorized
    ///
    /// - Returns: **true** if current user has been already authorized. And **false** if there is no authorized user
    func isAuhorized() -> Bool {
        return currentUser == nil ? false : true
    }
    
    /// Returns the current user
    ///
    /// - Returns: the current user or **nil**, if user is still not logged in.
    func getCurrentUser() -> User? {
        return currentUser
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
    
    /// Creates a new user after a successfull registration. Also creates neccesity records in auxiliaries tables in Firestore.
    ///
    /// - Parameter user: a new user to create
    /// - Parameter login: indicated by user email as a login
    /// - Parameter password: entered by user password
    /// - Parameter completion: completion closure Result( < User > ) -> Void
    func createUser(_ user: User, as login: String, with password: String, completion: @escaping (Result<User>) -> Void) {
        FirebaseController.shared.getDataController().saveData(user, with: user.id, in: DBTables.users) {
            (result: Result<User>) in
            
            switch result {
            case .success(let user):
                let articlesSchedule = SubscriptionArticleSchedule()
                let advicesSchedule = SubscriptionAdviceSchedule()
                
                FirebaseController.shared.getDataController().saveData(articlesSchedule, with: user.id, in: DBTables.articlesSchedule) {
                    (result: Result<SubscriptionArticleSchedule>) in
                    
                    switch result {
                    case .success(_):
                        FirebaseController.shared.getDataController().saveData(advicesSchedule, with: user.id, in: DBTables.advicesSchedule) {
                            (result: Result<SubscriptionAdviceSchedule>) in
                            
                            switch result {
                            case .success(_):
                                //Внимание! Потенциально только одна запись в keychain допускается
                                if !self.keychainController.keychainItemExists() {
                                    let keychainSaveResult = self.keychainController.save(login: login, password: password)
                                    if keychainSaveResult,
                                        let _ = self.keychainController.readPassword(for: login) {
                                        completion(Result.success(user))
                                    } else {
                                        completion(Result.failure(AppError.keychainSave))
                                    }
                                }
                            case .failure(let error):
                                completion(Result.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(Result.failure(error))
                    }
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func loadUserWithId(_ userId: String, as login: String, with password: String, completion: @escaping (Result<User>) -> Void) {
        FirebaseController.shared.getDataController().fetchData(with: userId, from: DBTables.users) {
            (result: Result<User>) in
            
            switch result {
            case .success(let user):
                self.loggedIn(as: user)
                
                if !self.keychainController.keychainItemExists() {
                    let keychainSaveResult = self.keychainController.save(login: login, password: password)
                    
                    guard keychainSaveResult,
                        let _ = self.keychainController.readPassword(for: password) else {
                            return completion(Result.failure(AppError.keychainSave))
                    }
                }
                    
                completion(Result.success(user))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
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
            switch table {
            case .articles:
                guard let ratingForCompetence = currentUser.rating.filter( { $0.competenceID == parentID } ).first else {
                    return false
                }
                
                return ratingForCompetence.earnedPoints == ratingForCompetence.totalPoints
            default:
                return false
            }
        }
    }
    
    /// Indicates if the current user has been already subscribed to the requested indicator of the
    /// characteristics competence
    ///
    /// - Parameter to: requested indicator of a competence
    /// - Returns: **true** if current user has already subscribed to requsted indicator of the characteristics competence. Also, if user has the **Admin** userrole, **true** will be always returned. **False** will be returned if not the indicator of the characteristics competence was requested, or there is no subscription to the requested indicator
    func isSubscribed(to indicator: CharacteristicsModel) -> Bool {
        guard let currentUser = currentUser else {
            return false
        }
        
        switch currentUser.userRole {
        case .admin:
            switch indicator.level{
            case .indicatorsOfCompetentions:
                return true
            default:
                return false
            }
        case .user:
            switch indicator.level {
            case .indicatorsOfCompetentions:
                if let setOfIndicators = currentUser.subscribedCharacteristics[indicator.parentID] {
                    return setOfIndicators.contains(indicator.id)
                } else {
                    return false
                }
            default:
                return false
            }
        }
    }
    
    /// Performs the subscription or unsubscription of the current user to the requested indicator
    /// of the characteristics competence
    ///
    /// - Parameter to: requested indicator
    /// - Parameter subscribe: indicates the action: **true** means subscription, **false** means unsubscription
    /// - Parameter completion: completion closure (Result < Bool >) -> Void. If current user has been
    /// already subscribed to the requested indicator **Result.success(false)** will be called.
    func performSubscriptionAction(to indicator: CharacteristicsModel, subscribe: Bool, completion: @escaping (Result<Bool>) -> Void) {
        guard var currentUser = currentUser else {
            return completion(Result.failure(AppError.notAuthorized))
        }
        
        if indicator.level != CharacteristicsLevel.indicatorsOfCompetentions {
            return completion(Result.failure(AppError.incorrectCharacteristicLevel))
        }
        
        if subscribe && isSubscribed(to: indicator) {
            return completion(Result.success(false))
        }
        
        if !subscribe && !isSubscribed(to: indicator) {
            return completion(Result.success(false))
        }
        
        if subscribe {
            if var setOfIndicators = currentUser.subscribedCharacteristics[indicator.parentID] {
                setOfIndicators.insert(indicator.id)
                currentUser.subscribedCharacteristics[indicator.parentID] = setOfIndicators
            } else {
                let setOfIndicators: Set<String> = [indicator.id]
                currentUser.subscribedCharacteristics[indicator.parentID] = setOfIndicators
            }
        } else {
            if var setOfIndicator = currentUser.subscribedCharacteristics[indicator.parentID] {
                setOfIndicator.remove(indicator.id)
                currentUser.subscribedCharacteristics[indicator.parentID] = setOfIndicator
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
    private func configureFireBase(_ application: UIApplication) {
        FirebaseApp.configure()
        FirebaseController.shared.setDataController(DataController())
        FirebaseController.shared.setStorageController(StorageController())
        
        remoteNotificationRegistration(application)
    }
    
    private func remoteNotificationRegistration(_ application: UIApplication) {
        Messaging.messaging().delegate = self as? MessagingDelegate
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    private func checkToken() {
        guard
            let currentUser = currentUser,
            let newToken = Messaging.messaging().fcmToken else {
                return
        }
        
        if currentUser.fcmToken != newToken {
            updateToken(with: newToken, for: currentUser)
        }
    }
    
    private func updateToken(with newToken: String, for user: User) {
        let newUser = User(id: user.id,
                           name: user.name,
                           email: user.email,
                           role: user.userRole,
                           isPaidUser: user.isPaidUser,
                           hasPaidTill: user.hasPaidTill,
                           subscribedCharacteristics: user.subscribedCharacteristics,
                           fcmToken: newToken,
                           rating: user.rating
                            )
        
        FirebaseController.shared.getDataController().saveData(newUser, with: newUser.id, in: DBTables.users) {
            (result: Result<User>) in
            
            switch result {
            case .success(let user):
                self.currentUser = user
            case .failure(let error):
                print(error.getError())
            }
        }
    }
}
