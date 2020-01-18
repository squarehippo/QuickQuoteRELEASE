//
//  EditCustomerViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/22/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class EditCustomerViewController: UIViewController {
    
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    var currentCustomer: Customer?
    
    @IBOutlet weak var editCustomerView: UIView!
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerAddress: UITextField!
    @IBOutlet weak var customerZipCode: UITextField!
    @IBOutlet weak var customerPhone: UITextField!
    @IBOutlet weak var customerEmail: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCustomerInfo()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        updateCustomer()
        NotificationCenter.default.post(name: .onDismissCustomerEdit, object: self, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadCustomerInfo() {
        print("currentC = ", currentCustomer?.address as Any)
        customerName.text = currentCustomer?.name
        customerAddress.text = currentCustomer?.address
        customerZipCode.text = currentCustomer?.zip
        customerPhone.text = currentCustomer?.phone
        customerEmail.text = currentCustomer?.email
    }
    
    func updateCustomer() {
        
        if let zip = customerZipCode.text?.trim() {
            getCityStateFromPostalCode(zip)
        }
        currentCustomer?.name = customerName.text?.trim()
        currentCustomer?.address = customerAddress.text?.trim()
        currentCustomer?.zip = customerZipCode.text?.trim()
        currentCustomer?.phone = customerPhone.text?.trim()
        if currentCustomer?.phone == "" { currentCustomer?.phone = "no phone" }
        currentCustomer?.email = customerEmail.text?.trim()
        if currentCustomer?.email == "" { currentCustomer?.email = "no email" }
        
        coreData?.saveContext()
    }
    
    
    func getCityStateFromPostalCode(_ zip: String) {
        let geocoder = CLGeocoder()
        var city = ""
        var state = ""
        
        geocoder.geocodeAddressString(zip) { (placemarks, error) in
            if let placemark = placemarks?[0] {
                if placemark.postalCode == zip {
                    city = placemark.locality!
                    state = placemark.administrativeArea!
                    self.saveCityAndState(city: city, state: state)
                    NotificationCenter.default.post(name: .onCityAvailable, object: self, userInfo: nil)
                }
            }
        }
    }
    
    func saveCityAndState(city: String, state: String) {
        currentCustomer?.city = city
        currentCustomer?.state = state
        coreData?.saveContext()
    }
}
