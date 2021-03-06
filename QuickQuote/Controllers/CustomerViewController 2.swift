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
    @IBOutlet weak var itemBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissEmployee), name: .onDismissEmployee, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissLogin), name: .onDismissLogin, object: nil)
        //TODO: onDismissNewCustomer unnecessary?
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissNewCustomer), name: .onDismissNewCustomer, object: nil)
        if isLoggedIn() {
            prepareView()
        } else {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    @objc func onDismissLogin() {
        prepareView()
    }
    
    @objc func onDismissEmployee() {
        prepareView()
    }
    
    @objc func onDismissCustomerEdit() {
        customerTableView.reloadData()
    }
    
    @objc func onDismissNewCustomer() {
        customerTableView.reloadData()
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func prepareView() {
        fetchCustomers(searchString: "")
        configureSearchController()
        title = "Customers"
        if customers.count > 0 {
            highlightFirstRow()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissCustomerEdit), name: .onDismissCustomerEdit, object: nil)
        itemBarButton.title = UserDefaults.standard.object(forKey: "currentEmployee") as? String ?? ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ModalCustomer":
            if let destinationVC = segue.destination as? NewCustomerViewController {
                destinationVC.delegate = self
            }
        case "editCustomer":
            if let destinationVC = segue.destination as? EditCustomerViewController {
                destinationVC.currentCustomer = currentCustomer as? Customer
            }
        case "editEmployee1Segue":
            if let destinationVC = segue.destination as? EmployeeViewController {
                destinationVC.employeeName = UserDefaults.standard.object(forKey: "currentEmployee") as? String ?? ""
            }
        case "editEmployee2Segue":
            if let destinationVC = segue.destination as? EmployeeViewController {
                destinationVC.employeeName = UserDefaults.standard.object(forKey: "currentEmployee") as? String ?? ""
            }
        case "signoutSegue":
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        default:
            break
        }
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
            //TODO: When a new customer is added, the last customer im the list is highlighted - the code below didn't fix it
            customers = customers.sorted(by:
            { ($0.dateModified!).compare($1.dateModified!) == .orderedDescending })
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
            customers = customers.sorted(by:
                { ($0.dateModified!).compare($1.dateModified!) == .orderedDescending })
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
        if customers.count > 0 {
            customerTableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .top)
        }
    }
}
