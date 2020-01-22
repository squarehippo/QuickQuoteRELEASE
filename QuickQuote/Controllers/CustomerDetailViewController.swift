//
//  CustomerDetailViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/14/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class CustomerDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate
{
    
    var currentCustomer: Customer? {
        didSet {
            refreshUI()
        }
    }
    
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    var quoteFetchedController: NSFetchedResultsController<Quote>!
    
    @IBOutlet weak var quoteTableView: UITableView! 
    @IBOutlet weak var customerAddress1: UILabel!
    @IBOutlet weak var customerAddress2: UILabel!
    @IBOutlet weak var customerEmail: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var customerName: UILabel!
    
    
    override func viewDidLoad() {
        
        quoteTableView.dataSource = self
        quoteTableView.delegate = self
        
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissCustomerEdit), name: .onDismissCustomerEdit, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onCityAvailable), name: .onCityAvailable, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeCustomer), name: .onChangeCustomer, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureFetchedController(searchString: currentCustomer?.name ?? "")
        do {
            try quoteFetchedController.performFetch()
        } catch  {
            print("could not perform fetch")
        }
    }
    
    func configureFetchedController(searchString: String) {
        let customerFetchRequest = NSFetchRequest<Quote>(entityName: "Quote")
        
        let predicate = NSPredicate(format: "customer.name CONTAINS[c] %@", searchString)
        customerFetchRequest.predicate = predicate
        
        let firstSortDescriptor = NSSortDescriptor(key: "dateModified", ascending: false)
        customerFetchRequest.sortDescriptors = [firstSortDescriptor]
        
        quoteFetchedController = NSFetchedResultsController<Quote>(
        fetchRequest: customerFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        quoteFetchedController.delegate = self
    }
    
    @objc func onDismissCustomerEdit() {
        refreshUI()
        title = currentCustomer?.name
    }
    
    @objc func onChangeCustomer(_ notification: Notification) {
        currentCustomer = notification.userInfo?["currentCust"] as? Customer
        title = currentCustomer?.name
    }
    
    @objc func onCityAvailable() {
        refreshUI()
    }
    
    func refreshUI() {
        loadViewIfNeeded()
        if let name = currentCustomer?.name {
            configureFetchedController(searchString: name)
            do {
                try quoteFetchedController.performFetch()
            } catch  {
                print("could not perform fetch")
            }
        }        
        customerAddress1.text = currentCustomer?.address ?? ""
        customerAddress2.text = currentCustomer?.cityStateZipToString()
        customerPhone.text = currentCustomer?.phone ?? ""
        customerEmail.text = currentCustomer?.email ?? ""
        customerName.text = currentCustomer?.name ?? ""
        quoteTableView.reloadData()
    }
    
    // MARK: - Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteFetchedController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteReuseIdentifierCell") as! QuoteCell
        
        let quote = quoteFetchedController.fetchedObjects![indexPath.row] as Quote
        switch quote.quoteStatus {
        case "\(QuoteStatus.opened)":
            cell.quoteStatusView.backgroundColor = UIColor(hex: "#df915aff")
        case "\(QuoteStatus.inProgress)":
            cell.quoteStatusView.backgroundColor = UIColor(hex: "#dfc95aff")
        case "\(QuoteStatus.complete)":
            cell.quoteStatusView.backgroundColor = UIColor(hex: "#5adf7dff")
        default:
            cell.quoteStatusView.backgroundColor = UIColor(hex: "#df5a5aff")
        }

        cell.quoteNumber.text = quote.quoteNumber
        let newDateString = quote.dateCreated?.dateToShortString()
        cell.quoteDate.text = newDateString
        if let currentImage = getImageToDisplay(from: quote) {
            cell.quoteImageView.image = UIImage(data: currentImage.imageData!)
        } else {
            cell.quoteImageView.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditQuoteSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let quote = quoteFetchedController.fetchedObjects![indexPath.row] as Quote
            context.delete(quote)
            coreData?.saveContext()
        }
    }
    
    func getImageToDisplay(from quote: Quote) -> Image? {
        if let images = Array(quote.images!) as? [Image] {
            if images.count > 0 {
                return images.first
            }
        }
        return nil
    }
    
    //MARK: - NSFetchedController delegate methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        quoteTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        quoteTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            print("Attempting insert here...")
            print("number of rows: \(quoteTableView.numberOfRows(inSection: 0))")
            if let insertIndexPath = newIndexPath {
                quoteTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        case .delete:
            print("deleting...")
            if let deleteIndexPath = indexPath {
                quoteTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            print("updating...")
            if let updateIndexPath = indexPath {
                let cell = quoteTableView.cellForRow(at: updateIndexPath) as! QuoteCell
                let quote = quoteFetchedController.fetchedObjects![updateIndexPath.row] as Quote
                cell.quoteNumber.text = quote.quoteNumber
                let newDateString = quote.dateCreated?.dateToShortString()
                cell.quoteDate.text = newDateString
                if let currentImage = getImageToDisplay(from: quote) {
                    cell.quoteImageView.image = UIImage(data: currentImage.imageData!)
                } else {
                    cell.quoteImageView.image = nil
                }
            }
        case .move:
            if let deleteIndexPath = indexPath {
                quoteTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            
            if let insertIndexPath = newIndexPath {
                quoteTableView.insertRows(at: [insertIndexPath], with: .fade)
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
            print("section inserting...")
            quoteTableView.insertSections(sectionIndexSet, with: .fade)
        case .delete:
            print("section deleting...")
            quoteTableView.deleteSections(sectionIndexSet, with: .fade)
        default:
            break
        }
    }

    //MARK: -- Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewQuoteSegue" {
            print("prepare for NewQuoteSegue")
            let destination = segue.destination as? QuoteViewController
            destination?.currentCustomer = currentCustomer
            destination?.context = context
        }
        if segue.identifier == "EditQuoteSegue" {
            let destination = segue.destination as? QuoteViewController
            destination?.currentQuote = quoteFetchedController.fetchedObjects![quoteTableView.indexPathForSelectedRow!.row] as Quote 
            destination?.isNewQuote = false
            destination?.context = context
        }
    }
    
}

extension CustomerDetailViewController: CustomerSelectionDelegate {
    func customerSelected(_ selectedCustomer: Customer) {
        currentCustomer = selectedCustomer
        print("currentCustomer = ", currentCustomer)
        quoteTableView.reloadData()
        title = currentCustomer?.name
    }
}
