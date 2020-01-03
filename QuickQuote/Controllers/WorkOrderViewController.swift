//
//  WorkOrderViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/10/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class WorkOrderViewController: UIViewController {
    
    var currentQuote: Quote?
    
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var containerView2: UIView!
    @IBOutlet weak var containerView3: UIView!
    
    @IBOutlet weak var segmentedControlForVCs: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(containerView1)
        containerView1.isHidden = false
        containerView2.isHidden = true
        containerView3.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workOrderNotes" {
            if let destinationVC = segue.destination as? NotesViewController {
                destinationVC.currentQuote = currentQuote
                destinationVC.context = context
            }
        }
        if segue.identifier == "materialsList" {
            if let destinationVC = segue.destination as? MaterialsListViewController {
                destinationVC.currentQuote = currentQuote
                destinationVC.context = context
            }
        }
        if segue.identifier == "worksheet" {
            if let destinationVC = segue.destination as? WorkSheetViewController {
                destinationVC.currentQuote = currentQuote
                destinationVC.context = context
            }
        }
    }
    
    @IBAction func didChangeIndex(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            containerView1.isHidden = false
            containerView2.isHidden = true
            containerView3.isHidden = true
        case 1:
            containerView1.isHidden = true
            containerView2.isHidden = false
            containerView3.isHidden = true
        case 2:
            containerView1.isHidden = true
            containerView2.isHidden = true
            containerView3.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
        let pdfPath = getPDF()
            let pdfURL = URL(fileURLWithPath: pdfPath)
            let uiavc = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                uiavc.popoverPresentationController?.barButtonItem = self.shareButton
            }
        present(uiavc, animated: true, completion: nil)
        currentQuote?.quoteStatus = "\(QuoteStatus.complete)"
        coreData?.saveContext()
        }
        
        func getPDF() -> String {
            let newPDF = PrepareWorkOrderPDF()
            if let quote = currentQuote {
               return newPDF.getPDFPath(for: quote)
            }
            return ""
        }
    

}
