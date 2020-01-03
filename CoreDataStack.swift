//
//  CoreDataStack.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/22/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack {
    
    static let shared = CoreDataStack()
//    private init() {}
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "QuickQuote")
//
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    func saveContext(completion: (_ success: Bool) -> Void) {
//        if persistentContainer.viewContext.hasChanges {
//            for object in persistentContainer.viewContext.updatedObjects {
//                if let signatureObject = object as? SignatureManagedObject {
//                    signatureObject.sign()
//                }
//            }
//
//            for object in persistentContainer.viewContext.insertedObjects {
//                if let signatureObject = object as? SignatureManagedObject {
//                    signatureObject.sign()
//                }
//            }
//            do {
//                try persistentContainer.viewContext.save()
//                completion(true)
//            } catch {
//                 fatalError("Error saving main managed context \(error)")
//            }
//        }
//    }
//
//    func saveContext() {
//        if persistentContainer.viewContext.hasChanges {
//            for object in persistentContainer.viewContext.updatedObjects {
//                if let signatureObject = object as? SignatureManagedObject {
//                    signatureObject.sign()
//                }
//            }
//
//            for object in persistentContainer.viewContext.insertedObjects {
//                if let signatureObject = object as? SignatureManagedObject {
//                    signatureObject.sign()
//                }
//            }
//            do {
//                try persistentContainer.viewContext.save()
//            } catch {
//                fatalError("Error saving main managed context \(error)")
//            }
//        }
//    }
}
