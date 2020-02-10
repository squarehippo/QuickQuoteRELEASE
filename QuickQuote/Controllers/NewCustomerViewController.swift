//
//  NewCustomerViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/22/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

protocol NewCustomerDelegate {
    func newCustomerVCDismissed()
}

class NewCustomerViewController: UIViewController {
    
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    var currentCustomer: NSManagedObject?
    var delegate: NewCustomerDelegate?
    
    @IBOutlet weak var newCustomerView: UIView!
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerAddress: UITextField!
    @IBOutlet weak var customerZipCode: UITextField!
    @IBOutlet weak var customerPhone: UITextField!
    @IBOutlet weak var customerEmail: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        customerName.becomeFirstResponder()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        save()
        delegate?.newCustomerVCDismissed()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        
        if let zip = customerZipCode.text?.trim() {
            getCityStateFromPostalCode(zip)
        }
        let cust = Customer(context: context)
        cust.name = customerName.text?.trim()
        cust.address = customerAddress.text?.trim()
        cust.zip = customerZipCode.text?.trim()
        cust.phone = customerPhone.text?.trim()
        if cust.phone == "" { cust.phone = "no phone" }
        cust.email = customerEmail.text?.trim()
        if cust.email == "" { cust.email = "no email" }
        
        coreData?.saveContext()
        fetchCurrentCustomer()
        NotificationCenter.default.post(name: .onChangeCustomer, object: self, userInfo: ["currentCust" : currentCustomer as! Customer])
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
        fetchCurrentCustomer()
        let cust = currentCustomer as! Customer
        cust.city = city
        cust.state = state
        coreData?.saveContext()
    }
    
    func fetchCurrentCustomer() {
        let fetchRequest = NSFetchRequest<Customer>(entityName: "Customer")
        do {
            let fetchedResults = try context.fetch(fetchRequest)
             if fetchedResults.count > 0 {
                currentCustomer = fetchedResults.last!
            }
        } catch let error as NSError {
            // something went wrong
            print(error.description)
        }
    }
}
