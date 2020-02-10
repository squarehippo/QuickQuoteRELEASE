//
//  UIView+PDF.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/13/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//
import UIKit

extension UIView {
    
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
