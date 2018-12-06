//
//  CoreDataManager.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 21/11/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import CoreData

class CoreDataManager {
    typealias NotificationClosure = (_ notification: Notification) -> Void
    fileprivate(set) var persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext!
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {

        self.persistentContainer = NSPersistentContainer(name: modelName)
        
        persistentContainer.loadPersistentStores { [weak self] (_, error) in
            
            guard error == nil else {
                fatalError("~~~~1~~~~Failed to load store: \(error!)")
            }
            
            self?.viewContext = self?.persistentContainer.viewContext
            self?.backgroundContext = self?.persistentContainer.newBackgroundContext()
            
            let notoficationClosure: NotificationClosure = { [weak self] (notification) in
                
                self?.viewContext.performMergeChangesFromContextDidSaveNotification(notification: notification)
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave,
                                                   object: self?.backgroundContext,
                                                   queue: nil,
                                                   using: notoficationClosure
                                                    )
            
            print("\(String(describing: self?.persistentContainer.persistentStoreCoordinator.persistentStores[0].url))")
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("~~~~2~~~~Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveChanges(completion: @escaping () -> Void) {
        backgroundContext.saveOrRollBack {
            completion()
        }
    }
    
    func createObject<T: NSManagedObject>(from entity: T.Type, into context: NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as! T
    }
    
    func delete(_ object: NSManagedObject, in context: NSManagedObjectContext, withSaving: Bool) {
        context.delete(object)
        if withSaving {
            save(context: context)
        }
    }
    
    func getEntity<T: NSManagedObject>(with id: String, in context: NSManagedObjectContext) -> T {
        let idPredicate = NSPredicate(format: "id == '\(id)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate])
        
        let resultArray = fetchData(in: context, for: T.self, predicate: compoundPredicate)
        let result: T
        
        if resultArray.isEmpty {
            result = createObject(from: T.self, into: context)
        } else {
            result = resultArray.first!
        }
        
        return result
    }
    
    func fetchData<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate? = nil, sortDescriptor: NSSortDescriptor? = nil) -> [T] {
        let context = getContext()
        let request: NSFetchRequest<T>
        
        var fetchResult = [T]()
        
        if #available(iOS 10.0, *) {
            request = entity.fetchRequest() as! NSFetchRequest<T>
        } else {
            request = NSFetchRequest(entityName: String(describing: entity))
        }
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        if let sortDescriptor = sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        
        do {
            fetchResult = try context.fetch(request)
        } catch {
            debugPrint("fetchData ~~~~3~~~~Could not fetch: \(error.localizedDescription)")
        }
        
        return fetchResult
    }
    
    func fetchData<T: NSManagedObject>(in context: NSManagedObjectContext, for entity: T.Type, predicate: NSCompoundPredicate? = nil, sortDescriptor: NSSortDescriptor? = nil) -> [T] {
        let request: NSFetchRequest<T>
        
        var fetchResult = [T]()
        
        if #available(iOS 10.0, *) {
            request = entity.fetchRequest() as! NSFetchRequest<T>
        } else {
            request = NSFetchRequest(entityName: String(describing: entity))
        }
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        if let sortDescriptor = sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        
        do {
            fetchResult = try context.fetch(request)
        } catch {
            debugPrint("fetchData ~~~~4~~~~Could not fetch: \(error.localizedDescription)")
        }
        
        return fetchResult
    }
}
