//
//  WorkSheetViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/10/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class WorkSheetViewController: UIViewController {
    
    var currentQuote: Quote?
    
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var irrigationSegment: UISegmentedControl!
    @IBOutlet weak var sodKickerSegment: UISegmentedControl!
    @IBOutlet weak var locatorNeededSegment: UISegmentedControl!
    @IBOutlet weak var transitNeededSegment: UISegmentedControl!
    @IBOutlet weak var equipmentAccessSegment: UISegmentedControl!
    @IBOutlet weak var wasteSegment: UISegmentedControl!
    @IBOutlet weak var generalAccessSegment: UISegmentedControl!
    @IBOutlet weak var waterSegment: UISegmentedControl!
    @IBOutlet weak var handDigSegment: UISegmentedControl!
    @IBOutlet weak var turfTypeSegment: UISegmentedControl!
    @IBOutlet weak var equipmentNeededSegment: UISegmentedControl!
    @IBOutlet weak var gateSize: UITextField!
    @IBOutlet weak var sodAmount: UITextField!
    @IBOutlet weak var p_flex: UITextField!
    @IBOutlet weak var p_pop: UITextField!
    @IBOutlet weak var p_cb: UITextField!
    @IBOutlet weak var p_y: UITextField!
    @IBOutlet weak var p_t: UITextField!
    @IBOutlet weak var p_c: UITextField!
    @IBOutlet weak var p1Feet: UITextField!
    @IBOutlet weak var p1Diameter: UITextField!
    @IBOutlet weak var p2Feet: UITextField!
    @IBOutlet weak var p2Diameter: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let quote = currentQuote {
            if quote.worksheet == nil {
                initializeWorksheet()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayWorksheetSettings()
    }
    

    func initializeWorksheet() {
        guard let quote = currentQuote else { return }
        
        let worksheet = Worksheet(context: context)
        worksheet.irrigation = Int32(UISegmentedControl.noSegment)
        worksheet.waste = Int32(UISegmentedControl.noSegment)
        worksheet.water = Int32(UISegmentedControl.noSegment)
        worksheet.turfType = Int32(UISegmentedControl.noSegment)
        worksheet.equipmentAccess = Int32(UISegmentedControl.noSegment)
        worksheet.sodKicker = Int32(UISegmentedControl.noSegment)
        worksheet.locatorNeeded = Int32(UISegmentedControl.noSegment)
        worksheet.generalAccess = Int32(UISegmentedControl.noSegment)
        worksheet.handDig = Int32(UISegmentedControl.noSegment)
        worksheet.transitNeeded = Int32(UISegmentedControl.noSegment)
        worksheet.equipmentNeeded = Int32(UISegmentedControl.noSegment)
        
        quote.worksheet = worksheet
        coreData?.saveContext()
    }
    
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        guard let quote = currentQuote else { return }
        
        if let worksheet = quote.worksheet {
            switch sender.tag {
            case 0:
                worksheet.irrigation = Int32(irrigationSegment.selectedSegmentIndex)
            case 1:
                worksheet.waste = Int32(wasteSegment.selectedSegmentIndex)
            case 2:
                worksheet.water = Int32(waterSegment.selectedSegmentIndex)
            case 3:
                worksheet.turfType = Int32(turfTypeSegment.selectedSegmentIndex)
            case 4:
                worksheet.equipmentAccess = Int32(equipmentAccessSegment.selectedSegmentIndex)
            case 5:
                worksheet.sodKicker = Int32(sodKickerSegment.selectedSegmentIndex)
            case 6:
                worksheet.locatorNeeded = Int32(locatorNeededSegment.selectedSegmentIndex)
            case 7:
                worksheet.generalAccess = Int32(generalAccessSegment.selectedSegmentIndex)
            case 8:
                worksheet.handDig = Int32(handDigSegment.selectedSegmentIndex)
            case 9:
                worksheet.transitNeeded = Int32(transitNeededSegment.selectedSegmentIndex)
            case 10:
                worksheet.equipmentNeeded = Int32(equipmentNeededSegment.selectedSegmentIndex)
            default:
                break
            }
            coreData?.saveContext()
        }
    }
    
    func displayWorksheetSettings() {
        let noSegment = Int32(UISegmentedControl.noSegment)
        if let quote = currentQuote  {
            irrigationSegment.selectedSegmentIndex = Int(quote.worksheet?.irrigation ?? noSegment)
            wasteSegment.selectedSegmentIndex = Int(quote.worksheet?.waste ?? noSegment)
            waterSegment.selectedSegmentIndex = Int(quote.worksheet?.water ?? noSegment)
            turfTypeSegment.selectedSegmentIndex = Int(quote.worksheet?.turfType ?? noSegment)
            equipmentAccessSegment.selectedSegmentIndex = Int(quote.worksheet?.equipmentAccess ?? noSegment)
            sodKickerSegment.selectedSegmentIndex = Int(quote.worksheet?.sodKicker ?? noSegment)
            locatorNeededSegment.selectedSegmentIndex = Int(quote.worksheet?.locatorNeeded ?? noSegment)
            generalAccessSegment.selectedSegmentIndex = Int(quote.worksheet?.generalAccess ?? noSegment)
            handDigSegment.selectedSegmentIndex = Int(quote.worksheet?.handDig ?? noSegment)
            transitNeededSegment.selectedSegmentIndex = Int(quote.worksheet?.transitNeeded ?? noSegment)
            equipmentNeededSegment.selectedSegmentIndex = Int(quote.worksheet?.equipmentNeeded ?? noSegment)
            
            gateSize.text = quote.worksheet?.gateSize
            sodAmount.text = quote.worksheet?.sodAmount
            p_flex.text = quote.worksheet?.p_flex
            p_pop.text = quote.worksheet?.p_pop
            p_cb.text = quote.worksheet?.p_cb
            p_y.text = quote.worksheet?.p_y
            p_t.text = quote.worksheet?.p_t
            p_c.text = quote.worksheet?.p_c
            p1Feet.text = quote.worksheet?.p1Feet
            p1Diameter.text = quote.worksheet?.p1Diameter
            p2Feet.text = quote.worksheet?.p2Feet
            p2Diameter.text = quote.worksheet?.p2Diameter
        }
    }
    
    @IBAction func textBoxEdited(_ sender: UITextField) {
        guard let quote = currentQuote else {
            return
        }
        if let worksheet = quote.worksheet {
            worksheet.gateSize = gateSize.text
            worksheet.sodAmount = sodAmount.text
            worksheet.p_flex = p_flex.text
            worksheet.p_pop = p_pop.text
            worksheet.p_cb = p_cb.text
            worksheet.p_y = p_y.text
            worksheet.p_t = p_t.text
            worksheet.p_c = p_c.text
            worksheet.p1Feet = p1Feet.text
            worksheet.p1Diameter = p1Diameter.text
            worksheet.p2Feet = p2Feet.text
            worksheet.p2Diameter = p2Diameter.text
        
            coreData?.saveContext()
        }
    }
   

}
