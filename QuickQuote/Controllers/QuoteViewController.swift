//
//  NewQuoteViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/24/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class QuoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate {
    
    var currentCustomer: Customer? 
    
    let pageWidth: CGFloat = 612.0
    let pageHeight: CGFloat = 792.0
    var pdfData = NSMutableData()
    var contentView: UIView?
    
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    var taskFetchedController: NSFetchedResultsController<Task>!
    var imageFetchedController: NSFetchedResultsController<Image>!

    
    var currentEmployee: Employee?
    var currentQuote: Quote?
    var currentQuoteNumber: String?
    var currentCustomerTasks: [Task]?
    var isNewQuote = true
    
    var currentImage: Image?
    var currentImageArray = [Image]()
    var savedObjects = [NSManagedObject]()
    let imagePicker = UIImagePickerController()
    var imageArray = [Image]()
    var deleteButton = DeleteButton()
    var imageCell = UICollectionViewCell()
    var currentPath: IndexPath?

    
    var currentPDF = [String]()
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var quoteNumber: UILabel!
    @IBOutlet weak var quoteDate: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    //MARK: - View Related
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTableView.dataSource = self
        taskTableView.delegate = self
        taskTableView.layer.cornerRadius = 10
        
        addObservers()
        
        if currentQuote == nil { createNewQuote() }
        prepareQuote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureTaskFetchedController(quote: currentQuote!)
        do {
            try taskFetchedController.performFetch()
        } catch  {
            print("could not perform fetch")
        }
//        configureImageFetchedController(quote: currentQuote!)
//        do {
//            try imageFetchedController.performFetch()
//        } catch  {
//            print("could not perform fetch")
//        }
    }
    
    private func createNewQuote() {
        let newQuote = Quote(context: context)
        getCurrentEmployee()
        currentQuoteNumber = makeQuoteNumber(withUser: currentEmployee?.name ?? "error", andDate: Date())
        newQuote.quoteNumber = currentQuoteNumber
        newQuote.quoteStatus = "\(QuoteStatus.inProgress)"
        currentEmployee?.addToQuotes(newQuote)
        currentCustomer?.addToQuotes(newQuote)
        coreData?.saveContext()
        fetchCurrentQuote()
        
        NotificationCenter.default.post(name: .onCreateNewQuote, object: self, userInfo: nil)
    }
    
    private func prepareQuote() {
        currentQuoteNumber = currentQuote?.quoteNumber
        quoteNumber.text = "Quote: " + (currentQuoteNumber ?? "error")
        quoteDate.text = currentQuote?.dateCreated?.dateToShortString()
        title = "Quote for \(currentQuote?.customer?.name ?? "customer")"
        loadImageArray()
    }
    
    @objc func onChangeCustomer(_ notification: Notification) {
        if let notificationCustomer = notification.userInfo?["currentCust"] as? Customer {
            if currentCustomer?.name != notificationCustomer.name {
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func onDismissImageModal() {
        loadImageArray()
        imageCollectionView.reloadData()
    }
        
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeCustomer), name: .onChangeCustomer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissImageModal), name: .onDismissImageModal, object: nil)
    }
    
    func clearAllAnimations() {
        imageCell.layer.removeAllAnimations()
        imageCell.layer.transform = CATransform3DIdentity
        imageCell.viewWithTag(1001)?.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != imageCell {
            clearAllAnimations()
        }
    }
    
    //MARK: - Quote Related
    
//    func assignEmployee(quote: Quote) {
//        //let employeeName = UserDefaults.standard.object(forKey: "currentEmployee") as? String ?? ""
//        //currentEmployee = getCurrentEmployee(name: employeeName)
//    }
    
    func getCurrentEmployee() {
        let employeeName = UserDefaults.standard.object(forKey: "currentEmployee") as? String ?? ""
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employee")
        let predicate1 = NSPredicate(format: "name = %@", employeeName)
        fetchRequest.predicate = predicate1
        fetchRequest.fetchLimit = 1
        do {
            let thisEmployee = try context.fetch(fetchRequest)
            currentEmployee = thisEmployee.first as? Employee
        } catch let error as NSError {
            print(error)
        }
    }
    
    func makeQuoteNumber(withUser sender: String, andDate date: Date) -> String {
        let seconds = date.dateToSeconds()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyy"
        let formattedDate = formatter.string(from: date)
        
        let fullName = sender.trimmingCharacters(in: .whitespacesAndNewlines)
        var components = fullName.components(separatedBy: " ")
        if (components.count > 0) {
            let firstName = components.removeFirst()
            let firstLetter = firstName.prefix(1)
            let lastName = components.joined(separator: " ")
            let secondLetter = lastName.prefix(1)
            let quoteNumber = "\(firstLetter)\(secondLetter)\(formattedDate)-\(seconds)"
            return quoteNumber
        }
        return "00000000" //there was an error
    }
    
    func secondsFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        var totalSeconds = 0
        
        let hours = calendar.component(.hour, from: date)
        totalSeconds = hours * 3600
        let minutes = calendar.component(.minute, from: date)
        totalSeconds += minutes * 60
        let seconds = calendar.component(.second, from: date)
        totalSeconds += seconds
        return totalSeconds
    }
    
    func fetchCurrentQuote() {
        let fetchRequest = NSFetchRequest<Quote>(entityName: "Quote")
        //TODO: Use quote number as predicate to ENSURE correct quote is returned
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.count > 0 {
                currentQuote = fetchedResults.last!
            }
        } catch let error as NSError {
            // something went wrong
            print(error.description)
        }
    }
    
    func loadCustomerTasks() {
        if let quote = currentQuote {
            currentCustomerTasks = Array(quote.tasks!) as? [Task]
            currentCustomerTasks = currentCustomerTasks?.sorted(by:
                { ($0.dateCreated!).compare($1.dateCreated!) == .orderedDescending })
        }
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskFetchedController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskReuseIdentifier")! as! TaskCell
        cell.layer.cornerRadius = 10
        cell.taskDescription.sizeToFit()
        let currentTask = taskFetchedController.object(at: indexPath)
        cell.taskTitle.text = "Task \(indexPath.row + 1)"
        cell.taskTitle.text! += ": \(currentTask.title ?? "")"
        if let cost = currentTask.cost {
            if cost.isNumeric {
                cell.taskCost.text = "\(cost.currencyFormatting())"
            } else {
                cell.taskCost.text = cost
            }
        }
        cell.taskDescription.text = currentTask.taskDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editTask", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskFetchedController.object(at: indexPath)
            context.delete(task)
            coreData?.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    //MARK: - NSFetchedController + delegate methods
    
    func configureTaskFetchedController(quote: Quote) {
        let taskFetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        let predicate = NSPredicate(format: "quote = %@", quote)
        taskFetchRequest.predicate = predicate
        
        let firstSortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
        taskFetchRequest.sortDescriptors = [firstSortDescriptor]
        
        taskFetchedController = NSFetchedResultsController<Task>(
        fetchRequest: taskFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        taskFetchedController.delegate = self
    }
    
    func configureImageFetchedController(quote: Quote) {
        let imageFetchRequest = NSFetchRequest<Image>(entityName: "Image")
        
        let predicate = NSPredicate(format: "quote = %@", quote)
        imageFetchRequest.predicate = predicate
        
        let firstSortDescriptor = NSSortDescriptor(key: "dateModified", ascending: true)
        imageFetchRequest.sortDescriptors = [firstSortDescriptor]
        
        imageFetchedController = NSFetchedResultsController<Image>(
        fetchRequest: imageFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        imageFetchedController.delegate = self
    }
    
    func controllerWillChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == taskFetchedController {
            taskTableView.beginUpdates()
        } else {
            
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                taskTableView.insertRows(at: [insertIndexPath], with: .automatic)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                taskTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            if let updateIndexPath = indexPath {
                let cell = taskTableView.cellForRow(at: updateIndexPath) as! TaskCell
                let task = taskFetchedController.object(at: updateIndexPath)
                cell.taskTitle.text = task.title
                cell.taskCost.text = task.cost
                cell.taskDescription.text = task.taskDescription
            }
        case .move:
            if let deleteIndexPath = indexPath {
                taskTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            
            if let insertIndexPath = newIndexPath {
                taskTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        default:
            break
        }
    }
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
//        return sectionName
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        let sectionIndexSet = NSIndexSet(index: sectionIndex) as IndexSet
//        
//        switch type {
//        case .insert:
//            taskTableView.insertSections(sectionIndexSet, with: .fade)
//        case .delete:
//            taskTableView.deleteSections(sectionIndexSet, with: .fade)
//        default:
//            break
//        }
//    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           taskTableView.endUpdates()
       }
    
    //MARK: - Photo Related
    
    func loadImageArray() {
        fetchImageArray()
        let sortedArray = currentImageArray.sorted { $0.tag < $1.tag }
        saveSortedArray(named: sortedArray)
    }
    
    func fetchImageArray() {
        if let quote = currentQuote {
            guard let quoteNumber = quote.quoteNumber else { return }
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")
            fetchRequest.predicate = NSPredicate(format: "quote.quoteNumber = %@", quoteNumber)
            do {
                currentImageArray = try context.fetch(fetchRequest) as! [Image]
                savedObjects = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch \(error)")
            }
        }
    }
    
    func saveSortedArray(named sortedArray: [Image]) {
        for (index, image) in sortedArray.enumerated() {
            image.tag = Int32(index)
            coreData?.saveContext()
        }
    }
    
    func saveImage(data: Data, tag: Int) {
        if currentImageArray.count != tag {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")
            fetchRequest.predicate = NSPredicate(format: "tag == %i", Int32(tag))
            do {
                let test = try context.fetch(fetchRequest) as! [Image]
                let objectToDelete = test[0]
                context.delete(objectToDelete)
                coreData?.saveContext()
            } catch  {
                print("error")
            }
        }
        
        //save new image
        if let quote = currentQuote {
            let image = Image(context: context)
            image.imageData = data
            image.tag = Int32(tag)
            quote.addToImages(image)
            coreData?.saveContext()
        }
    }
    
    //MARK: - Image Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = imageCollectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        performSegue(withIdentifier: "collectionSegue", sender: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        let sortedArray = currentImageArray.sorted { $0.tag < $1.tag }
        cell.collectionImage.image = UIImage(data: sortedArray[indexPath.row].imageData!)
        return cell
    }
    
    //MARK: - Share
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let pdfPath = getPDF()
        let pdfURL = URL(fileURLWithPath: pdfPath)
        let quoteNumber = currentQuote?.quoteNumber ?? ""
        let emailAddress = currentQuote?.customer?.email ?? ""
        let custName = currentQuote?.customer?.name ?? ""
        let message = MessageWithSubject(subject: "nc|drainage quote \(quoteNumber) for \(custName) \(emailAddress)", message: "Thank you for choosing nc|drainage!")
        let controller = UIActivityViewController(activityItems: [message, pdfURL], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.popoverPresentationController?.barButtonItem = self.shareButton
        }
        present(controller, animated: true, completion: nil)
        
        if currentQuote?.quoteStatus != "\(QuoteStatus.complete)" {
            currentQuote?.quoteStatus = "\(QuoteStatus.inProgress)"
            coreData?.saveContext()
        }
    }
    
    func getPDF() -> String {
        let newPDF = PreparePDFSheets()
        if let quote = currentQuote {
           return newPDF.getPDFPath(for: quote)
        }
        return ""
    }
    
    //MARK: -- prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NewTaskSegue":
            if let destinationVC = segue.destination as? NewTaskViewController {
                destinationVC.currentQuote = currentQuote
                destinationVC.context = context
            }
        case "editTask":
            
            if let destinationVC = segue.destination as? EditTaskViewController {
                let selectedTask = taskFetchedController.fetchedObjects![taskTableView.indexPathForSelectedRow?.row ?? 0] as Task
                destinationVC.currentTask = selectedTask
                destinationVC.context = context
            }
            
        case "workOrder":
            if let destinationVC = segue.destination as? WorkOrderViewController {
                destinationVC.currentQuote = currentQuote
                destinationVC.context = context
            }
        case "collectionSegue":
            if let destinationVC = segue.destination as? ImageViewController {
                destinationVC.currentQuote = currentQuote
                let path = self.imageCollectionView.indexPath(for: sender as! ImageCollectionViewCell)
                destinationVC.buttonTag = path?.row
                destinationVC.context = context
            }
        case "newPhotoSegue":
            if let destinationVC = segue.destination as? ImageViewController {
                destinationVC.currentQuote = currentQuote
                destinationVC.buttonTag = currentImageArray.count
                destinationVC.context = context
            }
        default:
            break
        }
    }

}

extension QuoteViewController: NewTaskDelegate {
    func newTaskVCDismissed() {
        taskTableView.reloadData()
    }
}

