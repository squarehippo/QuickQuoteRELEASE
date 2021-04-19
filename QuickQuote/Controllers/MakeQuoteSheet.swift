//
//  MakeQuoteSheet.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/18/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class MakeQuoteSheet: UIView {
    
    var sheetArray = [UIView]()
    var taskLineCount = 0
    let maxSheetLineCount = 50
    let titleAndFooterHeight = 5
    var tempTaskArray = [Task]()
    
    
    func makeSheet(quote: Quote, source: String) -> [UIView] {
        let tasks = (Array(quote.tasks!) as? [Task])!.sorted(by: { ($0.dateCreated!).compare($1.dateCreated!) == .orderedAscending })
        
        //Loop though all tasks
        for task in tasks {
            let newTaskView = TaskView()
            
            //Get the total height if the new label were to be added
            newTaskView.taskDescription.text = task.taskDescription //Calculate the height if added
            let currentLabelHeight = newTaskView.taskDescription.numberOfLabelLines + titleAndFooterHeight
            taskLineCount += currentLabelHeight
            
            //If that total is less than the size of the screen, add task to a task array
            if taskLineCount < maxSheetLineCount {
                tempTaskArray.append(task)
                
                //If this is the last task, then create a new sheet from tasks in the tempTaskArray, regardless of taskLineCount
                if task == tasks[tasks.endIndex - 1]{
                    createTaskSheet(task: tempTaskArray, source: source, quote: quote)
                }
            } else {
                
                //Otherwise, add a new sheet and populate the stack using the task array
                createTaskSheet(task: tempTaskArray, source: source, quote: quote)
                
                //Still need to handle current task - wipe array and add current task.
                tempTaskArray.removeAll()
                tempTaskArray.append(task)
                taskLineCount = 0
                
                if task == tasks[tasks.endIndex - 1]{
                    createTaskSheet(task: tempTaskArray, source: source, quote: quote)
                }
            }
        }
        return sheetArray
    }
    
    private func createTaskSheet(task: [Task], source: String, quote: Quote) {
        //Create sheet
        let taskSheet = TaskSheet(frame: CGRect(x: 0, y: 0, width: 612, height: 792))
        taskSheet.quoteNumber.text = quote.quoteNumber
        
        //Loop through all tasks
        for currentTask in tempTaskArray {
            let taskView = TaskView()
            
            //set labels
            taskView.taskTitle.text = currentTask.title
            taskView.taskDescription.text = currentTask.taskDescription
            if source == TaskType.workOrder.rawValue {
                taskView.taskCost.text = ""
            } else {
                if let cost = currentTask.cost {
                    if cost.isNumeric {
                        taskView.taskCost.text = "\(cost.currencyFormatting())"
                    } else {
                        taskView.taskCost.text = cost
                    }
                }
            }
            taskView.setNeedsLayout()
            taskView.layoutIfNeeded()
            taskSheet.mainStack.translatesAutoresizingMaskIntoConstraints = false
            //add label to stack
            taskSheet.mainStack.addArrangedSubview(taskView)
        }
        
        //Once all labels have been added to the stack, add the new sheet to a sheet array
        //print("adding sheet")
        taskSheet.sizeToFit()
        taskSheet.setNeedsLayout()
        taskSheet.layoutIfNeeded()
        sheetArray.append(taskSheet)
    }
    
}


extension UILabel {
    var numberOfLabelLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
