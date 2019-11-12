//
//  MaterialsListViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/9/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class MaterialsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentQuote: Quote?
    let coreData = CoreDataStack.shared
    var context = CoreDataStack.shared.persistentContainer.viewContext
    
    var materialArray = [Material]()
    var recentMaterialArray = [Material]()
    
    @IBOutlet weak var materialsListTableView: UITableView!
    @IBOutlet weak var recentItemsTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        materialsListTableView.delegate = self
        materialsListTableView.dataSource = self
        materialsListTableView.layer.cornerRadius = 10
        recentItemsTableView.layer.cornerRadius = 10
        
        fetchMaterials()
    }
    
    // MARK: - Alert
    
    @IBAction func addNewItemPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Item", message: "Add a new item", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let itemToSave = textField.text else {
                    return
            }
            if let quote = self.currentQuote {
                let item = Material(context: self.context)
                item.name = itemToSave
                quote.addToMaterials(item)
                self.coreData.saveContext()
            }
            self.fetchMaterials()
            self .materialsListTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func loadMaterialArray() {
        if let quote = currentQuote {
            print("quote = currentQuote, check")
            if let materials = quote.materials {
                print("materialsArray = blah, check")
                materialArray = Array(materials) as! [Material]
                materialArray = materialArray.sorted(by: { ($0.dateCreated!).compare($1.dateCreated!) == .orderedDescending
                })
            }
        }
    }
    
    func fetchMaterials() {
        if let quoteNumber = currentQuote?.quoteNumber {
            let fetchRequest = NSFetchRequest<Material>(entityName: "Material")
            fetchRequest.predicate = NSPredicate(format: "quote.quoteNumber CONTAINS[c] %@", quoteNumber)
            do {
                materialArray = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch \(error)")
            }
        }
    }
    
    // MARK: - Materials List Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materialArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let materialName = materialArray[indexPath.row].name {
            cell.textLabel?.text = materialName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let material = materialArray[indexPath.row]
            context.delete(material)
            coreData.saveContext()
            materialArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Recent Materials List Table view
    
    
    
    
}
