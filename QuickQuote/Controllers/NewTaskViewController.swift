//
//  NewTaskViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/27/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

protocol NewTaskDelegate {
    func newTaskVCDismissed()
}
class NewTaskViewController: UIViewController {
    
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    var currentQuote: Quote?
    var delegate: NewTaskDelegate?
    
    @IBOutlet weak var newTaskView: UIView!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var taskCost: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTaskView.layer.cornerRadius = 10.0
        taskTitle.becomeFirstResponder()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.currentTitle == "CANCEL" {
            dismiss(animated: true, completion: nil)
        } else {
            saveTask()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func saveTask() {
        print("saving task...")
        let quote = currentQuote
        print("quote = ", quote)
        print("context = ", context)
        let newTask = Task(context: context)
        newTask.title = taskTitle.text
        newTask.taskDescription = taskDescription.text
        newTask.cost = taskCost.text
        quote?.addToTasks(newTask)
        coreData?.saveContext()
        print("task saved")
    }
    
}
