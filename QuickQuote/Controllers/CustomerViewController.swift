//
//  CustomerViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/14/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

//TODO: Change this to use the notification center already in place
protocol CustomerSelectionDelegate: class {
    func customerSelected(_ newCustomer: Customer)
}

class CustomerViewController: UITableViewController, UISearchResultsUpdating {
    
    var delegate: CustomerSelectionDelegate?
    var customers = [Customer]()
    var currentCustomer: NSManagedObject?
    let coreData = CoreDataStack.shared
    var context = CoreDataStack.shared.persistentContainer.viewContext
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var customerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCustomers(searchString: "")
        configureSearchController()
        title = "Customers"
        highlightFirstRow()
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissCustomerEdit), name: .onDismissCustomerEdit, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalCustomer" {
            if let nextVC = segue.destination as? NewCustomerViewController {
                nextVC.delegate = self
            }
        }
        if segue.identifier == "editCustomer" {
            if let nextVC = segue.destination as? EditCustomerViewController {
                nextVC.currentCustomer = currentCustomer as? Customer
            }
        }
    }
    
    @objc func onDismissCustomerEdit() {
        customerTableView.reloadData()
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ""
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func highlightFirstRow() {
        if customers.count > 0 {
            customerTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            delegate?.customerSelected(customers[0])
        }
    }
    
    func fetchCustomers(searchString: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Customer")
        if searchString.count != 0 {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchString)
        }
        do {
            customers = try context.fetch(fetchRequest) as! [Customer]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
    }
    // MARK: - Customer Search Functions
    
    func updateSearchResults(for searchController: UISearchController) {
        if let currentSearch = searchController.searchBar.text {
            fetchCustomers(searchString: currentSearch)
        }
        customerTableView.reloadData()
    }
    
    //TODO: Add scope?

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let customer = customers[indexPath.row]
        cell.textLabel?.text = customer.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCustomer = customers[indexPath.row]
        delegate?.customerSelected(selectedCustomer)
        currentCustomer = selectedCustomer
        NotificationCenter.default.post(name: .onChangeCustomer, object: self, userInfo: nil)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cust = customers[indexPath.row]
            context.delete(cust)
            customers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            coreData.saveContext()
            delegate?.customerSelected(customers[0])
            //Not working! - row is being selected but not highlighted. Grrr...
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        }
    }
}

extension CustomerViewController: NewCustomerDelegate {
    func newCustomerVCDismissed() {
        fetchCustomers(searchString: "")
        customerTableView.reloadData()
        let row = customers.count - 1
        delegate?.customerSelected(customers[row])
        customerTableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .top)
    }
}
