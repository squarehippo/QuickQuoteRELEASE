//
//  AppDelegate.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/14/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "QuickQuote")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext(completion: (_ success: Bool) -> Void) {
           if persistentContainer.viewContext.hasChanges {
               for object in persistentContainer.viewContext.updatedObjects {
                   if let signatureObject = object as? SignatureManagedObject {
                       signatureObject.sign()
                   }
               }
               
               for object in persistentContainer.viewContext.insertedObjects {
                   if let signatureObject = object as? SignatureManagedObject {
                       signatureObject.sign()
                   }
               }
               do {
                   try persistentContainer.viewContext.save()
                   completion(true)
               } catch {
                    fatalError("Error saving main managed context \(error)")
               }
           }
       }
       
       func saveContext() {
           if persistentContainer.viewContext.hasChanges {
               for object in persistentContainer.viewContext.updatedObjects {
                   if let signatureObject = object as? SignatureManagedObject {
                       signatureObject.sign()
                   }
               }
               
               for object in persistentContainer.viewContext.insertedObjects {
                   if let signatureObject = object as? SignatureManagedObject {
                       signatureObject.sign()
                   }
               }
               do {
                   try persistentContainer.viewContext.save()
               } catch {
                   fatalError("Error saving main managed context \(error)")
               }
           }
       }
    
    
    
    
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//
//
//
    
}

