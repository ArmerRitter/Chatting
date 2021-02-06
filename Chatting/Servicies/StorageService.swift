//
//  StorageService.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import CoreData


class StorageManager {
    
    let shared = StorageManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "Chat")
        
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
    }()
    
    func saveContext () {
       let context = persistentContainer.viewContext
        
       if context.hasChanges {
         do {
            try context.save()
         } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
         }
       }
    }
    
    private func fetchRecordsForEntity(_ entity: String) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        // Helpers
        var result = [NSManagedObject]()

        do {
            // Execute Fetch Request
            let records = try persistentContainer.viewContext.fetch(fetchRequest)

            if let records = records as? [NSManagedObject] {
                result = records
            }

        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }

        return result
    }
    
    func loadMaser() -> User? {
        let defaults = UserDefaults.standard
        
        if let savedMasterUser = defaults.object(forKey: "MASTER_USER") as? Data {
            let decoder = JSONDecoder()
            if let loadedMasterUser = try? decoder.decode(User.self, from: savedMasterUser) {
              return loadedMasterUser
            }
        }
        return nil
    }
    
    func createUserEntity(user: User) {
        
       
        
    }
    
    func createDialog(dialog: Dialog) {
        
        let manageContext = persistentContainer.viewContext
        
        let entityUser = NSEntityDescription.insertNewObject(forEntityName: "UserCoreData", into: manageContext) as! UserCoreData
        entityUser.id = dialog.user.id
        entityUser.username = dialog.user.username
        
        let masterUser = loadMaser()
        
        let entityDialog = NSEntityDescription.insertNewObject(forEntityName: "DialogCoreData", into: manageContext) as! DialogCoreData
        entityDialog.masterUsername = masterUser?.username
        entityDialog.user = entityUser
       
        saveContext()
    }
}

