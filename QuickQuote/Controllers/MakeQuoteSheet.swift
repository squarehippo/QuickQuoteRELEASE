//
//  MakeQuoteSheet.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/18/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class MakeQuoteSheet {
    
    var sheetArray = [UIView]()
    
    func makeSheet(quote: Quote, source: String) -> [UIView] {
        if let totalTasks = quote.tasks?.count {
            for index in 0..<totalTasks {
                if index % 4 == 0 {
                    let newQuoteSheet = QuoteSheet()
                    newQuoteSheet.quoteNumber.text = quote.quoteNumber
                    newQuoteSheet.stackView2.isHidden = true
                    newQuoteSheet.stackView3.isHidden = true
                    newQuoteSheet.stackView4.isHidden = true
                    
                    let tasks = (Array(quote.tasks!) as? [Task])!.sorted(by: { ($0.dateCreated!).compare($1.dateCreated!) == .orderedAscending })
                    
                    for (thisIndex, task) in Array(tasks).enumerated() where thisIndex >= index && thisIndex < index + 4 {
                        switch thisIndex {
                        case index + 0:
                            //newQuoteSheet.stackView1.isHidden = false
                            newQuoteSheet.task1Title.text = task.title
                            let cost = source == "work" ? "" : task.cost?.currencyFormatting()
                            newQuoteSheet.task1Cost.text = cost
                            newQuoteSheet.task1Description.text = task.taskDescription
                        case index + 1:
                            newQuoteSheet.stackView2.isHidden = false
                            newQuoteSheet.stackView2Height.constant = 150
                            newQuoteSheet.task2Title.text = task.title
                            let cost = source == "work" ? "" : task.cost?.currencyFormatting()
                            newQuoteSheet.task2Cost.text = cost
                            newQuoteSheet.task2Description.text = task.taskDescription
                        case index + 2:
                            newQuoteSheet.stackView3.isHidden = false
                            newQuoteSheet.stackView3Height.constant = 150
                            newQuoteSheet.task3Title.text = task.title
                            let cost = source == "work" ? "" : task.cost?.currencyFormatting()
                            newQuoteSheet.task3Cost.text = cost
                            newQuoteSheet.task3Description.text = task.taskDescription
                        case index + 3:
                            newQuoteSheet.stackView4.isHidden = false
                            newQuoteSheet.stackView4Height.constant = 150
                            newQuoteSheet.task4Title.text = task.title
                            let cost = source == "work" ? "" : task.cost?.currencyFormatting()
                            newQuoteSheet.task4Cost.text = cost
                            newQuoteSheet.task4Description.text = task.taskDescription
                        default:
                            break
                        }
                    }
                    sheetArray.append(newQuoteSheet.contentView)
                }
            }
        }
        return sheetArray
    }

}

