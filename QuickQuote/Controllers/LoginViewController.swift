//
//  LoginViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/9/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    let coreData = CoreDataStack.shared
    let context = CoreDataStack.shared.persistentContainer.viewContext
    var employees: [NSManagedObject] = []
    var currentEmployee: [NSManagedObject] = []
    var employeeDictionary: Dictionary = [String:String]()

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginView: GenericView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissNewEmployee), name: .onDismissNewEmployee, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentUserList()
    }
    
    @objc func onDismissNewEmployee() {
        getCurrentUserList()
    }
    
    func getCurrentUserList() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employee")
        do {
            employees = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        
        if employees.count <= 0 {
            let employee = Employee(context: context)
            employee.name = "Administrator"
            employee.email = "admin@email.com"
            employee.phone = "919-555-1212"
            employee.username = "admin"
            employee.password = "pass"
            coreData.saveContext()
            
            employeeDictionary["admin"] = "pass"
            
            
        } else {
            for employee in employees as! [Employee] {
                if let username = employee.username, let password = employee.password {
                    employeeDictionary[username.trim()] = password.trim()
                }
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        var foundUser = false
        for employee in employeeDictionary {
            if username.text == employee.key && password.text == employee.value {
                let name = getUserName(userName: employee.key)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set(name , forKey: "currentEmployee")
                dismiss(animated: true, completion: nil)
                foundUser = true
                
                NotificationCenter.default.post(name: .onDismissLogin, object: self, userInfo: nil)
            }
        }
        if !foundUser {
            loginView.shakeLogin()
            password.text = ""
            username.becomeFirstResponder()
        }
    }
    
    func getUserName(userName: String) -> String {
        var userFullName = ""
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employee")
        let predicate1 = NSPredicate(format: "username = %@", userName)
        fetchRequest.predicate = predicate1
        fetchRequest.fetchLimit = 1
        do {
            currentEmployee = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        
        if currentEmployee.count > 0 {
            let fullName = currentEmployee.first as? Employee
            if let name = fullName?.name {
                userFullName = name
            }
        } else {
            userFullName = "error"
        }
        return userFullName.trim()
    }
}
