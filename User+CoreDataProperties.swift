//
//  User+CoreDataProperties.swift
//  RetrieveUsers
//
//  Created by Skyler Tanner on 8/25/16.
//  Copyright © 2016 SkyTanDevelopment. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var email: String?
    @NSManaged var thumbnailUrlString: String?

}
