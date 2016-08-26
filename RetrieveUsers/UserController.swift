//
//  UserController.swift
//  RetrieveUsers
//
//  Created by Skyler Tanner on 8/25/16.
//  Copyright © 2016 SkyTanDevelopment. All rights reserved.
//

import Foundation
import CoreData

class UserController {
    
    var users: [User] {
        
        let request = NSFetchRequest(entityName: "User")
        
        if let users = try? Stack.sharedStack.managedObjectContext.executeFetchRequest(request) as! [User] {
            return users
        } else { return [] }
    }
    
    static let sharedController = UserController()
    
    func saveUsers() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func deleteUsers(usersToDelete: [User]?) {
        guard let usersToDelete = usersToDelete else { return }
        
        for user in usersToDelete {
            Stack.sharedStack.managedObjectContext.deleteObject(user)
        }
    }
    
}