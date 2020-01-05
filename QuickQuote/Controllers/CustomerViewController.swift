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

// TODO: Change this to use the notification center already in place
protocol CustomerSelectionDelegate: class {
    func customerSelected(_ newCustomer: Customer)
}

class CustomerViewController: UITableViewController, UISearchResultsUpdating, NSFetchedResultsControllerDelegate {
    
    var delegate: CustomerSelectionDelegate?
    var customers = [Customer]()
    var currentCustomer: NSManagedObject?
    
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    var customerFetchedController: NSFetchedResultsController<Customer>!
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var customerTableView: UITableView!
    @IBOutlet weak var itemBarButton: UIBarButtonItem!
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLoggedIn() {
            prepareView()
        } else {
            performSegue(withIdentifier: "segueToLogin", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureSearchController()
        configureFetchedController(searchString: "")
        do {
            try customerFetchedController.performFetch()
        } catch  {
            print("could not perform fetch")
        }
    }
    
    // MARK: - Setup
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func prepareView() {
        title = "Customers"
        if customers.count > 0 {
            highlightFirstRow()
        }
        itemBarButton.title = UserDefaults.standard.object(forKey: "currentEmployee") as? String ?? ""
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
            // TODO: - When a new customer is added, the last customer im the list is highlighted - the code below didn't fix it
            customers = customers.sorted(by:
            { ($0.dateModified!).compare($1.dateModified!) == .orderedDescending })
            delegate?.customerSelected(customers[0])
        }
    }
    
    func configureFetchedController(searchString: String) {
        let customerFetchRequest = NSFetchRequest<Customer>(entityName: "Customer")
        
        if searchString.count != 0 {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", searchString)
            customerFetchRequest.predicate = predicate
        }
        
        let firstSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let secondSortDescriptor = NSSortDescriptor(key: "dateModified", ascending: false)
        customerFetchRequest.sortDescriptors = [firstSortDescriptor, secondSortDescriptor]
        
        customerFetchedController = NSFetchedResultsController<Customer>(
        fetchRequest: customerFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        customerFetchedController.delegate = self
    }
    
    // MARK: - Customer Search Functions
    func updateSearchResults(for searchController: UISearchController) {
        if let currentSearch = searchController.searchBar.text {
            configureFetchedController(searchString: currentSearch)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = customerFetchedController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let customer = customerFetchedController.object(at: indexPath)
        cell.textLabel?.text = customer.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = customerFetchedController.object(at: indexPath)
        delegate?.customerSelected(customer)
        currentCustomer = customer
        NotificationCenter.default.post(name: .onChangeCustomer, object: self, userInfo: nil)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let customer = customerFetchedController.object(at: indexPath)
            if editingStyle == .delete {
                context.delete(customer)
                do {
                    try context?.save()
                } catch  {
                    print("Boom")
                }
            }
        }
    }
    
    //MARK: - NSFetchedController delegate methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        customerTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        customerTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                customerTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                customerTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            if let updateIndexPath = indexPath {
                let cell = customerTableView.cellForRow(at: updateIndexPath)
                let customer = customerFetchedController.object(at: updateIndexPath)
                cell?.textLabel?.text = customer.name
            }
        case .move:
            if let deleteIndexPath = indexPath {
                customerTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            
            if let insertIndexPath = newIndexPath {
                customerTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let sectionIndexSet = NSIndexSet(index: sectionIndex) as IndexSet
        
        switch type {
        case .insert:
            customerTableView.insertSections(sectionIndexSet, with: .fade)
        case .delete:
            customerTableView.deleteSections(sectionIndexSet, with: .fade)
        default:
            break
        }
    }
    
    // MARK: - prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ModalCustomer":
            if let destinationVC = segue.destination as? NewCustomerViewController {
                //destinationVC.delegate = self
                destinationVC.context = context
            }
        case "editCustomer":
            if let destinationVC = segue.destination as? EditCustomerViewController {
                destinationVC.currentCustomer = currentCustomer as? Customer
                destinationVC.context = context
            }
        case "editEmployee1Segue":
            if let destinationVC = segue.destination as? EmployeeViewController {
                destinationVC.employeeName = UserDefaults.standard.object(forKey: "currentEmployee") as? String ?? ""
                destinationVC.context = context
            }
        case "editEmployee2Segue":
            if let destinationVC = segue.destination as? EmployeeViewController {
                destinationVC.employeeName = UserDefaults.standard.object(forKey: "currentEmployee") as? String ?? ""
                destinationVC.context = context
            }
        case "signoutSegue":
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        default:
            break
        }
    }
    
}
