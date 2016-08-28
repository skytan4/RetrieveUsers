//
//  User.swift
//  RetrieveUsers
//
//  Created by Skyler Tanner on 8/25/16.
//  Copyright © 2016 SkyTanDevelopment. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    
    convenience init(jsonDictionary: [String: AnyObject]) {
        
        //Add each object into core data
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: Stack.sharedStack.managedObjectContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: Stack.sharedStack.managedObjectContext)
        
        if let nameArray = jsonDictionary["name"] as? [String: AnyObject], pictureUrlArray = jsonDictionary["picture"] as? [String: AnyObject] {

            firstName = nameArray["first"] as? String
            lastName = nameArray["last"] as? String
            email = jsonDictionary["email"] as? String
            phoneNumber = jsonDictionary["phone"] as? String
            if let thumbnailUrlString = pictureUrlArray["thumbnail"] as? String, thumbnailUrl = NSURL(string: thumbnailUrlString) {
                thumbnailData = NSData(contentsOfURL: thumbnailUrl)
            }
               
        } else {
            
            // If we cannot get into the picture and or name dictionaries, we can still try to set the other properties but we need to know those dictionaries are no longer acccessible in the API 
            print("API Structure has changed")
            
            firstName = nil
            lastName = nil
            email = jsonDictionary["email"] as? String
            phoneNumber = jsonDictionary["phone"] as? String
            thumbnailData = nil
        }
    }
    
}
