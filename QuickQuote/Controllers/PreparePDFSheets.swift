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
    var maxPhotosPerPage = 3
    
    func getPDFPath(for quote: Quote) -> String {
        return preparePDF(quote: quote)
    }
    
    func preparePDF(quote: Quote) -> String {
        var fileName: String?
        fileName = quote.quoteNumber
        
        makeCoverSheet(quote: quote)
        
        let newQuoteSheet = MakeQuoteSheet()
        for sheet in newQuoteSheet.makeSheet(quote: quote, source: TaskType.quote.rawValue) {
            pdfPages.append(sheet)
        }
        
        let newPhotoSheet = MakePhotoSheet()
        for sheet in newPhotoSheet.makeSheet(quote: quote) {
            pdfPages.append(sheet)
        }
        
        makeSignSheet(quote: quote)
        
        return arrayToPDF(views: pdfPages, fileName: fileName ?? "Quote")
    }
    
    //MARK: - Make Sheets
    
    func makeCoverSheet(quote: Quote) {
        let newPDFCoverSheet = CoverSheet()
        newPDFCoverSheet.quoteDate.text = (quote.dateCreated?.dateToLongString())?.uppercased()
        newPDFCoverSheet.customerName.text = (quote.customer?.name)?.uppercased()
        newPDFCoverSheet.customerAddress1.text = (quote.customer?.address)?.uppercased()
        newPDFCoverSheet.customerAddress2.text = quote.customer?.cityStateZipToString().uppercased()
        newPDFCoverSheet.quoteNumber.text = quote.quoteNumber
        newPDFCoverSheet.employeeName.text = quote.employee?.name?.uppercased()
        newPDFCoverSheet.employeePhone.text = quote.employee?.phone
        newPDFCoverSheet.employeeEmail.text = quote.employee?.email?.uppercased()
        
        pdfPages.append(newPDFCoverSheet.contentView)
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
