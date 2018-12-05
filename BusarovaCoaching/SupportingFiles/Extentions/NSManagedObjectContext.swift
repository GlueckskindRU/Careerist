//
//  NSManagedObjectContext.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 28/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    typealias PerformChangesClosure = () -> Void
    
    func performChanges(block: @escaping PerformChangesClosure) {
        perform {
            block()
        }
    }
    
    func saveOrRollBack(completion: @escaping () -> ()) {
        perform {
            defer { completion() }
            
            if !self.hasChanges {
                return
            }
            
            do {
                try self.save()
            } catch {
                self.rollback()
            }
        }
    }
    
    func performMergeChangesFromContextDidSaveNotification(notification: Notification) {
        perform {
            self.mergeChanges(fromContextDidSave: notification)
        }
    }
}
