//
//  NetworkController.swift
//  RetrieveUsers
//
//  Created by Skyler Tanner on 8/25/16.
//  Copyright © 2016 SkyTanDevelopment. All rights reserved.
//

import Foundation

class NetworkController {
    
    static func getUsers(numberOfUsers: Int, callback: (resultUsers: [User]?, NSError?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        
        let usersURL = NSURL(string:"http://api.randomuser.me/?results=\(numberOfUsers)")
        
        if let usersURL = usersURL {
            let dataTask = session.dataTaskWithURL(usersURL) { (data, response, error) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let data = data else {
                    callback(resultUsers: [], error)
                    print("Error getting data")
                    return
                }
                
                let jsonObject: AnyObject
                
                do{
                    jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                } catch(let error as NSError) {
                    callback(resultUsers: [], error)
                    return
                }
//                print(jsonObject)
                let usersArray = jsonObject["results"] as? [[String: AnyObject]]
                if let userObjects = usersArray {
                    
                    var users: [User] = []
                    
                    for userDictionary in userObjects {
                        
                        let user = User(jsonDictionary: userDictionary)
                        users.append(user)
                        
                    }
                    callback(resultUsers: users, nil)
                }
//                print(jsonObject)
            }
            dataTask.resume()
        }
    }
}