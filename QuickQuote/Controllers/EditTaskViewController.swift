//
//  EditTaskViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/30/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController {
    
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    var currentQuote: Quote?
    var currentTask: Task?
    
    @IBOutlet weak var editTaskView: UIView!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var taskCost: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTitle.becomeFirstResponder()
        loadTaskInfo()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.currentTitle == "Cancel" {
            dismiss(animated: true, completion: nil)
        } else {
            updateTask()
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .onDismissNewTask, object: self, userInfo: nil)
        }
    }
    
    func loadTaskInfo() {
        taskTitle.text = currentTask?.title
        taskDescription.text = currentTask?.taskDescription
        taskCost.text = currentTask?.cost
    }
    
    func updateTask() {
        currentTask?.title = taskTitle.text
        currentTask?.taskDescription = taskDescription.text
        currentTask?.cost = taskCost.text
        coreData?.saveContext()
    }
}

