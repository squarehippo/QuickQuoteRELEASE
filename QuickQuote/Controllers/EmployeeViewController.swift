//
//  EmployeeViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/9/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class EmployeeViewController: UIViewController {
    
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    var employees = [Employee]()
    var employeeName: String?
    var employeeResult = [NSManagedObject]()
    var currentEmployee: NSManagedObject?
    
    var isUpdate = false
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var windowTitle: UILabel!
    
    @IBOutlet weak var saveButton: CancelButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if employeeName != nil {
            windowTitle.text = "Update Employee Infomation"
            isUpdate = true
        }
        if isUpdate {
            saveButton.setTitle("UPDATE", for: .normal)
            loadCurrentUser()
        } else {
            saveButton.setTitle("SAVE", for: .normal)
            loadUsers()
        }
    }
    
    func loadUsers() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employee")
        do {
            employees = try context.fetch(fetchRequest) as! [Employee]
        } catch let error as NSError {
            print(error)
        }
    }
    
    func loadCurrentUser() {
        getCurrentEmployee(currentName: employeeName!)
        let thisEmployee = currentEmployee as? Employee
        nameField.text = thisEmployee?.name
        emailField.text = thisEmployee?.email
        phoneField.text = thisEmployee?.phone
        usernameField.text = thisEmployee?.username
        passwordField.text = thisEmployee?.password
    }
    
    func getCurrentEmployee(currentName: String){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employee")
        let predicate1 = NSPredicate(format: "name = %@", currentName)
        fetchRequest.predicate = predicate1
        fetchRequest.fetchLimit = 1
        do {
            employeeResult = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
                
        if employeeResult.count > 0 {
            currentEmployee = employeeResult.first
        }
    }
    
    func saveNewUser(name: String, phone: String, email: String, username: String, password: String) {
        if isUpdate {
            let employee = currentEmployee as? Employee
            employee?.name = nameField.text
            employee?.email = emailField.text
            employee?.phone = phoneField.text
            employee?.username = usernameField.text
            employee?.password = passwordField.text
            UserDefaults.standard.set(nameField.text, forKey: "currentEmployee")
        } else {
            let employee = Employee(context: context)
            employee.name = name.trim()
            employee.phone = phone.trim()
            employee.email = email.trim()
            employee.username = username.trim()
            employee.password = password.trim()
            employees.append(employee)
        }
        NotificationCenter.default.post(name: .onDismissEmployee, object: self, userInfo: nil)
        coreData?.saveContext()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        var errors = [String]()
        if nameField.text == "" {
            nameField.backgroundColor = UIColor(red: 1, green: 0.8392, blue: 0.8392, alpha: 1.0)
            errors.append("name required")
        }
        if emailField.text == "" {
            emailField.backgroundColor = UIColor(red: 1, green: 0.8392, blue: 0.8392, alpha: 1.0)
            errors.append("email address required")
        }
        if phoneField.text == "" {
            phoneField.backgroundColor = UIColor(red: 1, green: 0.8392, blue: 0.8392, alpha: 1.0)
            errors.append("phone number required")
        }
        if usernameField.text == "" {
            usernameField.backgroundColor = UIColor(red: 1, green: 0.8392, blue: 0.8392, alpha: 1.0)
            errors.append("username required")
        }
        if passwordField.text == "" {
            passwordField.backgroundColor = UIColor(red: 1, green: 0.8392, blue: 0.8392, alpha: 1.0)
            errors.append("password required")
        }
        if !usernameIsUnique() {
            errors.append("username has already been taken")
        }
        
        if errors.count > 0 {
            var message: String?
            for error in errors {
                message = (message ?? "") + error + "\n"
            }
            let alert = UIAlertController(title: "Please correct the following:", message: message, preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(okayAction)
            present(alert, animated: true)
            return
        }
        
        
        
        saveNewUser(name: nameField.text!, phone: phoneField.text!, email: emailField.text!, username: usernameField.text!, password: passwordField.text!)
        NotificationCenter.default.post(name: .onDismissNewEmployee, object: self, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func usernameIsUnique() -> Bool {
        for employee in employees {
            if usernameField.text == employee.username {
                //This one is already here!
                return false
            }
        }
        return true
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        print("encoding now...")
        
        if let currentEmployee = currentEmployee {
            coder.encode(currentEmployee, forKey: "currentEmployee")
        }
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        print("decoding now...")
        super.decodeRestorableState(with: coder)
        currentEmployee = coder.decodeObject(forKey: "currentEmployee") as? NSManagedObject
    }
    

}
