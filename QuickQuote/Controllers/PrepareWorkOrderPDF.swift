//
//  PrepareWorkOrderPDF.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/13/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class PrepareWorkOrderPDF : UIView{

   var pdfPages = [UIView]()
    
    func getPDFPath(for quote: Quote) -> String {
        return preparePDF(quote: quote)
    }
    
    func preparePDF(quote: Quote) -> String {
        var fileName: String?
        fileName = quote.quoteNumber
        
        makeFirstPage(quote: quote)
        
        
        return arrayToPDF(views: pdfPages, fileName: fileName ?? "Quote")
    }
    
    func makeFirstPage(quote: Quote) {
        let firstPage = WorkOrderPage1()
        firstPage.workOrderNumber.text = quote.quoteNumber
        firstPage.dateCreated.text = quote.dateCreated?.dateToLong()
        firstPage.customerName.text = quote.customer?.name
        firstPage.customerAddress.text = quote.customer?.address
        firstPage.customerAddress2.text = getCityStateZip()
        firstPage.customerPhone.text = quote.customer?.phone
        firstPage.customerEmail.text = quote.customer?.email
        firstPage.workOrderNotes.text = quote.noteForWorkOrder
        
        if quote.materials!.count > 0 {
            
            for material in Array(quote.materials!) as! [Material] {
                let label = UILabel()
                label.textAlignment = .center
                label.text = material.name
                firstPage.materialsStackView.addArrangedSubview(label)
            }
        }
        
        
        pdfPages.append(firstPage.contentView)
    }
    
    func getCityStateZip() -> String {
        return ""
    }

}
