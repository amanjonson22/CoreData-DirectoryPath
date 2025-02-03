//
//  persistence.swift
//  teste 3
//
//  Created by AMANDA CAROLINE DA SILVA RODRIGUES on 03/02/25.
//

import Foundation
import CoreData

struct PersistenceController {
    static let persistencia = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ImageTest")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL (fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unsolved error \(error), \(error.userInfo)")
            }
        })
    }
}

