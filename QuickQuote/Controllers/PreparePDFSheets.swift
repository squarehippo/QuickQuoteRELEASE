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
        makePhotoSheet(quote: quote)
        makeSignSheet(quote: quote)
        
        return arrayToPDF(views: pdfPages, fileName: fileName ?? "Quote")
    }
    
    //MARK: - Make Sheets
    
    func makeCoverSheet(quote: Quote) {
        let newPDFCoverSheet = CoverSheet()
        newPDFCoverSheet.quoteDate.text = (quote.dateCreated?.dateToLong())?.uppercased()
        newPDFCoverSheet.customerName.text = (quote.customer?.name)?.uppercased()
        newPDFCoverSheet.quoteNumber.text = quote.quoteNumber
        newPDFCoverSheet.employeeName.text = quote.employee?.name
        newPDFCoverSheet.employeeContact.text = quote.employee?.phone
        
        pdfPages.append(newPDFCoverSheet.contentView)
    }
    
    func makeQuoteSheet(quote: Quote) {
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
        if let totalPhotos = quote.images?.count {
            for index in 0..<totalPhotos {
                if index % 4 == 0 {
                    let newPhotoSheet = PhotoSheet()
                    newPhotoSheet.quoteNumber.text = quote.quoteNumber
                    newPhotoSheet.photoStack2.isHidden = true
                    newPhotoSheet.photoStack2.isHidden = true
                    newPhotoSheet.photoStack4.isHidden = true
                    
                    let photos = (Array(quote.images!) as? [Image])!.sorted(by: { ($0.dateCreated!).compare($1.dateCreated!) == .orderedAscending })
                    
                    for (thisIndex, photo) in Array(photos).enumerated() where thisIndex >= index && thisIndex < index + 4 {
                        switch thisIndex {
                        case index + 0:
                            //newPhotoSheet.stackView1.isHidden = false
                            newPhotoSheet.photo1.image = UIImage(data: photo.imageData!)
                            newPhotoSheet.caption1.text = photo.caption
                        case index + 1:
                            newPhotoSheet.photoStack2.isHidden = false
                            //newPhotoSheet.photoStack2Height.constant = 150
                            newPhotoSheet.photo2.image = UIImage(data: photo.imageData!)
                            newPhotoSheet.caption2.text = photo.caption
                        case index + 2:
                            newPhotoSheet.photoStack3.isHidden = false
                            //newPhotoSheet.photoStack3Height.constant = 150
                            newPhotoSheet.photo3.image = UIImage(data: photo.imageData!)
                            newPhotoSheet.caption3.text = photo.caption
                        case index + 3:
                            newPhotoSheet.photoStack4.isHidden = false
                            //newPhotoSheet.photoStack4Height.constant = 150
                            newPhotoSheet.photo4.image = UIImage(data: photo.imageData!)
                            newPhotoSheet.caption4.text = photo.caption
                        default:
                            break
                        }
                    }
                    pdfPages.append(newPhotoSheet.contentView)
                }
            }
        }
    }
    
    func makeSignSheet(quote: Quote) {
        let newSignSheet = SignSheet()
        newSignSheet.quoteNumber.text = quote.quoteNumber
        newSignSheet.expirationDate.text = calcExpirationDate(quote: quote)
        pdfPages.append(newSignSheet.contentView)
    }
    
    //MARK: - Helper functions
    
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

}
