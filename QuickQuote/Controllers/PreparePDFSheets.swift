//
//  preparePDFSheets.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/19/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class PreparePDFSheets: UIView {
    
    var pdfPages = [UIView]()
    
    func getPDFPath(for quote: Quote) -> String {
        return preparePDF(quote: quote)
    }
    
    func preparePDF(quote: Quote) -> String {
        var fileName: String?
        fileName = quote.quoteNumber
        
        makeCoverSheet(quote: quote)
        makeQuoteSheet(quote: quote)
        makeSignSheet(quote: quote)
        
        return arrayToPDF(views: pdfPages, fileName: fileName ?? "Quote")
    }
    
    func makeCoverSheet(quote: Quote) {
        let newPDFCoverSheet = CoverSheet()
        newPDFCoverSheet.quoteDate.text = (quote.dateCreated?.dateToLong())?.uppercased()
        newPDFCoverSheet.customerName.text = (quote.customer?.name)?.uppercased()
        newPDFCoverSheet.quoteNumber.text = quote.quoteNumber
        newPDFCoverSheet.employeeName.text = "ADAM LYON"
        newPDFCoverSheet.employeeContact.text = "919-555-1212"
        //newPDFCoverSheet.quoteDate.sizeToFit()
        //newPDFCoverSheet.quoteDate.setNeedsLayout()
        //newPDFCoverSheet.quoteDate.layoutIfNeeded()
        
        pdfPages.append(newPDFCoverSheet.contentView)
    }
    
    //    func makeQuoteSheet(quote: Quote) {
    //        if let tasks = Array(quote.tasks!) as? [Task] {
    //            print("got the tasks")
    //            for index in 0..<tasks.count {
    //                print("inside first loop")
    //                if index % 4 == 0 {
    //                    print("starting new sheet")
    //                    let newQuoteSheet = QuoteSheet()
    //                    newQuoteSheet.stackView2Height.constant = 0
    //                    newQuoteSheet.stackView3Height.constant = 0
    //                    newQuoteSheet.stackView4Height.constant = 0
    //
    //                    let tasks = tasks.sorted(by:
    //                    { ($0.dateCreated!).compare($1.dateCreated!) == .orderedAscending })
    //                    for (thisIndex, task) in (Array(tasks) ).enumerated() where thisIndex >= index && thisIndex < index + 4 {
    //                        print("thisIndex = ", thisIndex)
    //                        print("index = ", index)
    //                        switch thisIndex {
    //                        case index + 0:
    //                            print("Assigning first task to variables")
    //                            //newQuoteSheet.stackView1.isHidden = false
    //                            newQuoteSheet.task1Title.text = task.title
    //                            newQuoteSheet.task1Cost.text = task.cost
    //                            newQuoteSheet.task1Description.text = task.taskDescription
    //                        case index + 1:
    //                            print("Assigning second task to variables")
    //                            //newQuoteSheet.stackView2.isHidden = false
    //                            newQuoteSheet.stackView2Height.constant = 150
    //                            newQuoteSheet.task2Title.text = task.title
    //                            newQuoteSheet.task2Cost.text = task.cost
    //                            newQuoteSheet.task2Description.text = task.taskDescription
    //                        case index + 2:
    //                            print("Assigning third task to variables")
    //                            //newQuoteSheet.stackView3.isHidden = false
    //                            newQuoteSheet.stackView3Height.constant = 150
    //                            newQuoteSheet.task3Title.text = task.title
    //                            newQuoteSheet.task3Cost.text = task.cost
    //                            newQuoteSheet.task3Description.text = task.taskDescription
    //                        case index + 3:
    //                            print("Assigning fourth task to variables")
    //                            //newQuoteSheet.stackView4.isHidden = false
    //                            newQuoteSheet.stackView4Height.constant = 150
    //                            newQuoteSheet.task4Title.text = task.title
    //                            newQuoteSheet.task4Cost.text = task.cost
    //                            newQuoteSheet.task4Description.text = task.taskDescription
    //                        default:
    //                            break
    //                        }
    //                    }
    //                    print("creating PDF for quote page")
    //                    pdfPages.append(newQuoteSheet.contentView)
    //                }
    //            }
    //        }
    //
    //    }
    
    func makeQuoteSheet(quote: Quote) {
        if let totalTasks = quote.tasks?.count {
            for index in 0..<totalTasks {
                if index % 4 == 0 {
                    print("loop")
                    let newQuoteSheet = QuoteSheet()
                    newQuoteSheet.stackView2.isHidden = true
                    newQuoteSheet.stackView3.isHidden = true
                    newQuoteSheet.stackView4.isHidden = true
                    
                    let tasks = (Array(quote.tasks!) as? [Task])!.sorted(by: { ($0.dateCreated!).compare($1.dateCreated!) == .orderedAscending })
                    
                    for (thisIndex, task) in (Array(tasks) ).enumerated() where thisIndex >= index && thisIndex < index + 4 {
                        switch thisIndex {
                        case index + 0:
                            print("Assigning first task to variables")
                            //newQuoteSheet.stackView1.isHidden = false
                            newQuoteSheet.task1Title.text = task.title
                            newQuoteSheet.task1Cost.text = task.cost
                            newQuoteSheet.task1Description.text = task.taskDescription
                        case index + 1:
                            print("Assigning second task to variables")
                            newQuoteSheet.stackView2.isHidden = false
                            newQuoteSheet.stackView2Height.constant = 150
                            newQuoteSheet.task2Title.text = task.title
                            newQuoteSheet.task2Cost.text = task.cost
                            newQuoteSheet.task2Description.text = task.taskDescription
                        case index + 2:
                            print("Assigning third task to variables")
                            newQuoteSheet.stackView3.isHidden = false
                            newQuoteSheet.stackView3Height.constant = 150
                            newQuoteSheet.task3Title.text = task.title
                            newQuoteSheet.task3Cost.text = task.cost
                            newQuoteSheet.task3Description.text = task.taskDescription
                        case index + 3:
                            print("Assigning fourth task to variables")
                            newQuoteSheet.stackView4.isHidden = false
                            newQuoteSheet.stackView4Height.constant = 150
                            newQuoteSheet.task4Title.text = task.title
                            newQuoteSheet.task4Cost.text = task.cost
                            newQuoteSheet.task4Description.text = task.taskDescription
                        default:
                            break
                        }
                    }
                    
                    pdfPages.append(newQuoteSheet.contentView)
                }
            }
        }
        
        
        
    }
    
    func makePhotoSheet(quote: Quote) {
        
    }
    
    func makeSignSheet(quote: Quote) {
        let newSignSheet = SignSheet()
        newSignSheet.quoteNumber.text = quote.quoteNumber
        newSignSheet.expirationDate.text = calcExpirationDate(quote: quote)
        pdfPages.append(newSignSheet.contentView)
    }
    
    func calcExpirationDate(quote: Quote) -> String {
        if let currentDate = quote.dateCreated {
            let today = currentDate
            let expirationDate = Calendar.current.date(byAdding: .day, value: 45, to: today)
            return dateToLongString(expirationDate!)
        }
        return ""
    }
    
    func dateToLongString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    func arrayToPDF(views: [UIView], fileName: String) -> String {
        let pdfData = NSMutableData()
        let pdfPageFrame = self.bounds
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        let context = UIGraphicsGetCurrentContext()
        for view in views {
            UIGraphicsBeginPDFPage()
            view.layer.render(in: context!)
        }
        UIGraphicsEndPDFContext()
        return saveViewPdf(data: pdfData, fileName: fileName)
    }

}

extension UIView {
    
//    // Export pdf from Save pdf in drectory and return pdf file path
//    func exportAsPdfFromView(fileName: String) -> String {
//        let pdfPageFrame = self.bounds
//        let pdfData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
//        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
//        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
//        self.layer.render(in: pdfContext)
//        UIGraphicsEndPDFContext()
//        return self.saveViewPdf(data: pdfData, fileName: fileName)
//
//    }
    
    // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData, fileName: String) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("\(fileName).pdf")
        if data.write(to: pdfPath, atomically: true) {
            print("file://\(pdfPath.path)")
            return pdfPath.path
        } else {
            return ""
        }
    }
}




