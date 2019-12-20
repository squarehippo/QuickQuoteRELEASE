//
//  CustomerDetailViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/14/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class CustomerDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var currentCustomer: Customer? {
        didSet {
            refreshUI()
        }
    }
    var currentCustomerQuotes = [Quote]()
    
    let coreData = CoreDataStack.shared
    var context = CoreDataStack.shared.persistentContainer.viewContext
    
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCustomerQuotes()
        quoteTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewQuoteSegue" {
            let destination = segue.destination as? QuoteViewController
            destination?.currentCustomer = currentCustomer
        }
        if segue.identifier == "EditQuoteSegue" {
            let destination = segue.destination as? QuoteViewController
            destination?.currentQuote = currentCustomerQuotes[quoteTableView.indexPathForSelectedRow!.section]
            destination?.isNewQuote = false
        }
    }
    
    @objc func onDismissCustomerEdit() {
        refreshUI()
        title = currentCustomer?.name
    }
    
    @objc func onCityAvailable() {
        refreshUI()
    }
    
    func refreshUI() {
        loadViewIfNeeded()
        customerAddress1.text = currentCustomer?.address ?? ""
        customerAddress2.text = cityStateZipToString()
        customerPhone.text = currentCustomer?.phone ?? ""
        customerEmail.text = currentCustomer?.email ?? ""
        customerName.text = currentCustomer?.name ?? ""
    }
    
    func cityStateZipToString() -> String {
        if let city = currentCustomer?.city,
        let state = currentCustomer?.state,
        let zip = currentCustomer?.zip {
            return "\(city), \(state) \(zip)"
        }
        return ""
    }
    
    func loadCustomerQuotes() {
        if let quotes = currentCustomer?.quotes {
            currentCustomerQuotes = Array(quotes) as! [Quote]
            currentCustomerQuotes = currentCustomerQuotes.sorted(by: { ($0.dateModified!).compare($1.dateModified!) == .orderedDescending
            })
        }
    }
    
    // MARK: - Table view 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentCustomerQuotes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteReuseIdentifierCell") as! QuoteCell
        cell.layer.cornerRadius = 10
        let quote = currentCustomerQuotes[indexPath.section]
        
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
        //cell.quoteStatusView.backgroundColor =
        cell.quoteNumber.text = quote.quoteNumber
        let newDateString = quote.dateCreated?.dateToShort()
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
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let quote = currentCustomerQuotes[indexPath.section]
            context.delete(quote)
            coreData.saveContext()
            currentCustomerQuotes.remove(at: indexPath.section)
            let indexSet = IndexSet(integer: indexPath.section)
            tableView.deleteSections(indexSet, with: .fade)
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
}

extension CustomerDetailViewController: CustomerSelectionDelegate {
    func customerSelected(_ newCustomer: Customer) {
        currentCustomer = newCustomer
        loadCustomerQuotes()
        quoteTableView.reloadData()
        title = currentCustomer?.name
    }
}
