//
//  WorkOrderViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/10/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class WorkOrderViewController: UIViewController {
    
    var currentQuote: Quote?
    
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
            }
        }
        if segue.identifier == "materialsList" {
            if let destinationVC = segue.destination as? MaterialsListViewController {
                destinationVC.currentQuote = currentQuote
            }
        }
        if segue.identifier == "worksheet" {
            if let destinationVC = segue.destination as? WorkSheetViewController {
                destinationVC.currentQuote = currentQuote
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
    
    

}
