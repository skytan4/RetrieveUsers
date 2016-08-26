//
//  ViewController.swift
//  RetrieveUsers
//
//  Created by Skyler Tanner on 8/25/16.
//  Copyright © 2016 SkyTanDevelopment. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userCountTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let userCellIdentifier = "userCell"
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), forControlEvents: .ValueChanged)
        
        return refreshControl
    }()
    var users: [User]? = UserController.sharedController.users

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
        tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        userCountTextField.resignFirstResponder()
        getUsers(10)
    }
    
    func getUsers(numberOfUsers: Int) {
        //Remove the current objects in core data to be replaced so they can be replaced with the new ones.
        UserController.sharedController.deleteUsers(UserController.sharedController.users)
        
        // Get new users in the background queue
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            NetworkController.getUsers(numberOfUsers) { (resultUsers, error) in
                self.users = resultUsers
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = .BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        userCountTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        userCountTextField.resignFirstResponder()
        if Int(userCountTextField.text!) < 5000 {
             getUsers(Int(userCountTextField.text!) ?? 10)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a number less than 5000", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let usersArray = users, cell = tableView.dequeueReusableCellWithIdentifier(userCellIdentifier, forIndexPath: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        let user = usersArray[indexPath.row]
        if let firstName = user.firstName, lastName = user.lastName {
            cell.nameLabel.text = firstName + " " + lastName
        }
        cell.emailLabel.text = user.email
        cell.phoneLabel.text = user.phoneNumber
        if let thumbnailData = user.thumbnailData {
            cell.thumbnailImageView.image = UIImage(data: thumbnailData)
        }
        
        return cell
    }
}
