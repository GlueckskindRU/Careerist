//
//  KeychainController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 22/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

class KeychainController: NSObject {
// MARK: - private properties
    private var service: String {
        var infoPlistWrapped: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            infoPlistWrapped = NSDictionary(contentsOfFile: path)
        }
        
        guard
            let infoPlist = infoPlistWrapped,
            let bundleName = infoPlist["CFBundleName"] as? String
            else { return "" }
        
        return bundleName
    }
    
// MARK: - private methods
    private func getQuery(login: String? = nil) -> [String: AnyObject] {
        var result = [String: AnyObject]()
        
        result[kSecClass as String] = kSecClassGenericPassword
        result[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        result[kSecAttrService as String] = service as AnyObject
        
        if let login = login {
            result[kSecAttrAccount as String] = login as AnyObject
        }
        
        return result
    }
    
// MARK: - public methods
    func keychainItemExists() -> Bool {
        var query = getQuery()
        
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return false
        }
        
        if queryResult as? [[String: AnyObject]] == nil {
            return false
        } else {
            return true
        }
    }
    
    func readPassword(for login: String?) -> String? {
        var query = getQuery(login: login)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard
            let item = queryResult as? [String: AnyObject],
            let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8) else {
                return nil
        }
        
        return password
    }
    
    func readCredentials() -> (login: String, password: String)? {
        var query = getQuery()
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String: AnyObject] else {
            return nil
        }
        
        guard
            let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8) else {
                return nil
        }
        
        guard let login = item[kSecAttrAccount as String] as? String else {
            return nil
        }
        
        return (login: login, password: password)
        
    }
    
    func save(login: String?, password: String) -> Bool {
        let passwordData = password.data(using: .utf8)
        
        if readPassword(for: login) != nil {
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = passwordData as AnyObject
            
            let query = getQuery(login: login)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            return status == noErr
        } else {
            var item = getQuery(login: login)
            item[kSecValueData as String] = passwordData as AnyObject
            let status = SecItemAdd(item as CFDictionary, nil)
            
            return status == noErr
        }
    }
    
    func readAllItems() -> [String: String]? {
        var query = getQuery()
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let items = queryResult as? [[String: AnyObject]] else {
            return nil
        }
        
        var passwordItems = [String: String]()
        
        for (index, item) in items.enumerated() {
            guard
                let passwordData = item[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: .utf8) else {
                    continue
            }
            
            if let account = item[kSecAttrAccount as String] as? String {
                passwordItems[account] = password
                continue
            }
            
            let accoount = "empty account \(index)"
            passwordItems[accoount] = password
        }
        
        return passwordItems
    }
    
    func deletePassword(account: String?) -> Bool {
        let item = getQuery(login: account)
        let status = SecItemDelete(item as CFDictionary)
        
        return status == noErr
    }
}
