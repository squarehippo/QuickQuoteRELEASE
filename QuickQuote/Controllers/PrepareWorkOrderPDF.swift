//
//  PrepareWorkOrderPDF.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/13/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

enum Irrigation: String, CustomStringConvertible, CaseIterable {
    case yes, no
    var description: String {
        return self.rawValue.capitalized
    }
}

enum Waste: String, CustomStringConvertible, CaseIterable {
    case septic
    case city = "city sewer"
    var description: String {
        return self.rawValue.capitalized
    }
}

enum Water: String, CustomStringConvertible, CaseIterable {
    case well
    case city = "city water"
    var description: String {
        return self.rawValue.capitalized
    }
}

enum Turf: String, CustomStringConvertible, CaseIterable {
    case fescue, bermuda, zoysia, other
    var description: String {
        return self.rawValue.capitalized
    }
}

enum EquipAccess: String, CustomStringConvertible, CaseIterable {
    case yes, no
    var description: String {
        return self.rawValue.capitalized
    }
}

enum EquipNeeded: String, CustomStringConvertible, CaseIterable {
    case none = "None"
    case sm36 = "small mini 36"
    case bm55 = "big mini 55"
    case either = "either mini"
    case ms44 = "mini skid 44"
    case bob = "bobcat 56"
    var description: String {
        return self.rawValue.capitalized
    }
}

enum Sod: String, CustomStringConvertible, CaseIterable {
    case yes, no
    var description: String {
        return self.rawValue.capitalized
    }
}

enum Locator: String, CustomStringConvertible, CaseIterable {
    case yes, no
    var description: String {
        return self.rawValue.capitalized
    }
}

enum Access: String, CustomStringConvertible, CaseIterable {
    case bad, average, great
    var description: String {
        return self.rawValue.capitalized
    }
}

enum HandDig: String, CustomStringConvertible, CaseIterable {
    case none, some, most, all
    var description: String {
        return self.rawValue.capitalized
    }
}

enum Transit: String, CustomStringConvertible, CaseIterable {
    case yes, no
    var description: String {
        return self.rawValue.capitalized
    }
}

class PrepareWorkOrderPDF : UIView {
    
    var pdfPages = [UIView]()
    //var testView: TestSheet?
    
    
    func getPDFPath(for quote: Quote) -> String {
        return preparePDF(quote: quote)
    }
    
    func preparePDF(quote: Quote) -> String {
        var fileName: String?
        fileName = quote.quoteNumber
        
        makeFirstPage(quote: quote)
        addWorksheet(quote: quote)
        
        let newPhotoSheet = MakePhotoSheet()
        for sheet in newPhotoSheet.makeSheet(quote: quote) {
            pdfPages.append(sheet)
        }
        
        let newQuoteSheet = MakeQuoteSheet()
        for sheet in newQuoteSheet.makeSheet(quote: quote, source: "work") {
            pdfPages.append(sheet)
        }
        
        
        return arrayToPDF(views: pdfPages, fileName: fileName ?? "Quote")
    }
    
    func makeFirstPage(quote: Quote) {
        let firstPage = WorkOrderPage1() 
        firstPage.workOrderNumber.text = quote.quoteNumber
        firstPage.dateCreated.text = quote.dateCreated?.dateToLong()
        firstPage.customerName.text = quote.customer?.name
        firstPage.customerAddress.text = quote.customer?.address
        firstPage.customerAddress2.text = cityStateZipToString(quote: quote)
        firstPage.customerPhone.text = quote.customer?.phone
        firstPage.customerEmail.text = quote.customer?.email
        firstPage.workOrderNotes.text = quote.noteForWorkOrder
        
        
        
        if let materialArray = quote.materials {
            var labelYPosition = 0
            if materialArray.count > 0 {
                let materials = (Array(materialArray) as? [Material])!.sorted(by: { ($0.dateCreated!).compare($1.dateCreated!) == .orderedAscending })
                for material in materials {
                    if let newMaterial = material.name {
                        let label = UILabel(frame: CGRect(x: 0, y: labelYPosition, width: 200, height: 16))
                        label.textColor = .black
                        label.font.withSize(16)
                        label.numberOfLines = 0
                        label.lineBreakMode = .byWordWrapping
                        label.textAlignment = .left
                        label.text = "\u{2022} \(newMaterial)"
                        label.sizeToFit()
                        labelYPosition += Int(label.bounds.size.height) + 10
                        firstPage.materialView.addSubview(label)
                    }
                }
            }
        }
        pdfPages.append(firstPage)
    }
    
    func getCityStateZip() -> String {
        return ""
    }
    
    func cityStateZipToString(quote: Quote) -> String {
        if let city = quote.customer?.city,
            let state = quote.customer?.state,
            let zip = quote.customer?.zip {
            return "\(city), \(state) \(zip)"
        }
        return ""
    }
    
    func addWorksheet(quote: Quote) {
    
        let page = WorksheetPage()

        page.workorderNumber.text = quote.quoteNumber
        
        let irrigationIndex = quote.worksheet?.irrigation
        if let index = irrigationIndex {
            if index >= 0 {
                let selectedIrrigationTitle = Irrigation.allCases[Int("\(index)") ?? 0]
                page.irrigation.text = selectedIrrigationTitle.rawValue.capitalized
            } else {
                page.irrigation.text = " "
            }
        }
        
        let wasteIndex = quote.worksheet?.waste
        if let index = wasteIndex {
            if index >= 0 {
                let selectedWasteTitle = Waste.allCases[Int("\(index)") ?? 0]
                page.waste.text = selectedWasteTitle.rawValue.capitalized
            } else {
                page.waste.text = " "
            }
        }
        
        let waterIndex = quote.worksheet?.water
        if let index = waterIndex {
            if index >= 0 {
                let selectedWaterTitle = Water.allCases[Int("\(index)") ?? 0]
                page.water.text = selectedWaterTitle.rawValue.capitalized
            } else {
                page.water.text = " "
            }
        }
        
        let turfIndex = quote.worksheet?.turfType
        if let index = turfIndex {
            if index >= 0 {
                let selectedTurfTitle = Turf.allCases[Int("\(index)") ?? 0]
                page.turf.text = selectedTurfTitle.rawValue.capitalized
            } else {
                page.turf.text = " "
            }
        }
        
        let equipAccessIndex = quote.worksheet?.equipmentAccess
        if let index = equipAccessIndex {
            if index >= 0 {
                let selectedEquipAccessTitle = EquipAccess.allCases[Int("\(index)") ?? 0]
                page.equipmentAccess.text = selectedEquipAccessTitle.rawValue.capitalized
            } else {
                page.equipmentAccess.text = " "
            }
        }
        
        let equipNeededIndex = quote.worksheet?.equipmentNeeded
        if let index = equipNeededIndex {
            if index >= 0 {
                let selectedEquipNeededTitle = EquipNeeded.allCases[Int("\(index)") ?? 0]
                page.equipmentNeeded.text = selectedEquipNeededTitle.rawValue.capitalized
            } else {
                page.equipmentNeeded.text = " "
            }
        }
        
        let sodIndex = quote.worksheet?.sodKicker
        if let index = sodIndex {
            if index >= 0 {
                let selectedSodTitle = Sod.allCases[Int("\(index)") ?? 0]
                page.sodKicker.text = selectedSodTitle.rawValue.capitalized
            } else {
                page.sodKicker.text = " "
            }
        }
        
        let locatorIndex = quote.worksheet?.locatorNeeded
        if let index = locatorIndex {
            if index >= 0 {
                let selectedLocatorTitle = Locator.allCases[Int("\(index)") ?? 0]
                page.locator.text = selectedLocatorTitle.rawValue.capitalized
            } else {
                page.sodKicker.text = " "
            }
        }
        
        let AccessIndex = quote.worksheet?.generalAccess
        if let index = AccessIndex {
            if index >= 0 {
                let selectedAccessTitle = Access.allCases[Int("\(index)") ?? 0]
                page.generalAccess.text = selectedAccessTitle.rawValue.capitalized
            } else {
                page.generalAccess.text = " "
            }
        }
        
        let HandDigIndex = quote.worksheet?.handDig
        if let index = HandDigIndex {
            if index >= 0 {
                let selectedHandDigTitle = HandDig.allCases[Int("\(index)") ?? 0]
                page.handDig.text = selectedHandDigTitle.rawValue.capitalized
            } else {
                page.handDig.text = " "
            }
        }
        
        let TransitIndex = quote.worksheet?.transitNeeded
        if let index = TransitIndex {
            if index >= 0 {
                let selectedTransitTitle = Transit.allCases[Int("\(index)") ?? 0]
                page.transitNeeded.text = selectedTransitTitle.rawValue.capitalized
            } else {
                page.transitNeeded.text = " "
            }
        }
        
        page.gateSize.text = quote.worksheet?.gateSize
        page.sodAmount.text = quote.worksheet?.sodAmount
        page.flexGrates.text = quote.worksheet?.p_flex
        page.popUps.text = quote.worksheet?.p_pop
        page.CBs.text = quote.worksheet?.p_cb
        page.Ys.text = quote.worksheet?.p_y
        page.Ts.text = quote.worksheet?.p_t
        page.Cs.text = quote.worksheet?.p_c
        page.pipe1Feet.text = quote.worksheet?.p1Feet
        page.pipe1Diameter.text = quote.worksheet?.p1Diameter
        page.pipe2Feet.text = quote.worksheet?.p2Feet
        page.pipe2Diameter.text = quote.worksheet?.p2Diameter
        
        pdfPages.append(page)
    }
    
}

