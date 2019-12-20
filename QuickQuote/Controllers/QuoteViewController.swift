//
//  NewQuoteViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/24/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class QuoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    
    var currentCustomer: Customer? {
        didSet {
            refreshUI()
        }
    }
    
    let pageWidth: CGFloat = 612.0
    let pageHeight: CGFloat = 792.0
    var pdfData = NSMutableData()
    var contentView: UIView?
    let coreData = CoreDataStack.shared
    var context = CoreDataStack.shared.persistentContainer.viewContext
    
    var currentQuote: Quote?
    var currentQuoteNumber: String?
    var currentCustomerTasks: [Task]?
    var isNewQuote = true
    
    var currentImage: Image?
    var currentImageArray = [Image]()
    let imagePicker = UIImagePickerController()
    var imageArray = [Image]()
    var deleteButton = DeleteButton()
    var imageCell = UICollectionViewCell()
    
    var currentPDF = [String]()
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var quoteNumber: UILabel!
    @IBOutlet weak var quoteDate: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTableView.dataSource = self
        taskTableView.delegate = self
        taskTableView.layer.cornerRadius = 10
        
        loadImageArray()
        assignCurrentQuoteInformation()
        setUpViewTasks()
        loadGestureRecognizer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NewTaskSegue":
            if let destinationVC = segue.destination as? NewTaskViewController {
                destinationVC.currentQuote = currentQuote
            }
        case "editTask":
            guard let destinationVC = segue.destination as? EditTaskViewController,
                let currentTasks = currentCustomerTasks,
                let selectedRow = taskTableView.indexPathForSelectedRow else { return }
            destinationVC.currentTask = currentTasks[selectedRow.row]
        case "workOrder":
            if let destinationVC = segue.destination as? WorkOrderViewController {
                destinationVC.currentQuote = currentQuote
            }
        case "collectionSegue":
            if let destinationVC = segue.destination as? ImageViewController {
                destinationVC.currentQuote = currentQuote
                let path = self.imageCollectionView.indexPath(for: sender as! ImageCollectionViewCell)
                destinationVC.buttonTag = path?.row
            }
        case "newPhotoSegue":
            if let destinationVC = segue.destination as? ImageViewController {
                destinationVC.currentQuote = currentQuote
                destinationVC.buttonTag = currentImageArray.count
            }
        default:
            break
        }
    }
    
    //MARK: - View Related
    
    func setUpViewTasks() {
        if isNewQuote {
            title = "New quote for \(currentCustomer?.name ?? "customer")"
            currentQuote?.quoteStatus = "\(QuoteStatus.opened)"
            coreData.saveContext()
        } else {
            title = "Quote for \(currentQuote?.customer?.name ?? "customer")"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissNewTask), name: .onDismissNewTask, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeCustomer), name: .onChangeCustomer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissImageModal), name: .onDismissImageModal, object: nil)
    }
    
    @objc func onDismissNewTask() {
        loadCustomerTasks()
        taskTableView.reloadData()
    }
    
    @objc func onChangeCustomer() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func onDismissImageModal() {
        loadImageArray()
        imageCollectionView.reloadData()
    }
        
    func loadGestureRecognizer() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        imageCollectionView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .began {
            return
        }
        let p = gesture.location(in: imageCollectionView)

        if let indexPath = imageCollectionView.indexPathForItem(at: p) {
            clearAllAnimations()
            imageCell = imageCollectionView.cellForItem(at: indexPath)!
            imageCell.wiggle()
            let imageButton = imageCell.contentView
            let imageWidth = imageButton.frame.width
            let imageHeight = imageButton.frame.height
            let deleteWidth = imageWidth * 0.5
            //let deleteHeight = imageWidth * 0.5
            deleteButton.frame = CGRect(x: imageWidth / 2 - deleteWidth / 2, y: imageHeight / 2 - deleteWidth / 2, width: deleteWidth, height: deleteWidth)
            deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
            imageButton.addSubview(deleteButton)
            print("Long press = ", indexPath.row)
        } else {
            print("couldn't find index path")
        }
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        
        clearAllAnimations()
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

    //TODO: Substitute Adam Lyon with signed in employee
    func assignCurrentQuoteInformation() {
        if isNewQuote {
            currentQuoteNumber = makeQuoteNumber(withUser: "Adam Lyon", andDate: Date())
            quoteDate.text = Date().dateToShort()
            saveNewQuote()
        } else {
            quoteDate.text = currentQuote?.dateCreated?.dateToShort()
            currentQuoteNumber = currentQuote?.quoteNumber
        }
        quoteNumber.text = "Quote: " + (currentQuoteNumber ?? "error")
        loadCustomerTasks()
    }
    
    func refreshUI() {
        loadViewIfNeeded()
    }
    
    //MARK: - Collection View
    
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
        let uiavc = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            uiavc.popoverPresentationController?.barButtonItem = self.shareButton
        }
        present(uiavc, animated: true, completion: nil)
        
        if currentQuote?.quoteStatus != "\(QuoteStatus.complete)" {
            currentQuote?.quoteStatus = "\(QuoteStatus.inProgress)"
            coreData.saveContext()
        }
    }
    
    func getPDF() -> String {
        let newPDF = PreparePDFSheets()
        if let quote = currentQuote {
           return newPDF.getPDFPath(for: quote)
        }
        return ""
    }
    
    //MARK: - Quote Related
    
    func saveNewQuote() {
        let newQuote = Quote(context: context)
        newQuote.quoteNumber = currentQuoteNumber
        newQuote.quoteStatus = "\(QuoteStatus.inProgress)"
        newQuote.employee?.name = UserDefaults.standard.object(forKey: "currentEmployee") as? String ?? ""
        currentCustomer?.addToQuotes(newQuote)
        coreData.saveContext()
        fetchCurrentQuote()
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
                { ($0.dateCreated!).compare($1.dateCreated!) == .orderedAscending })
        }
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCustomerTasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskReuseIdentifier")! as! TaskCell
        cell.layer.cornerRadius = 10
        cell.taskDescription.sizeToFit()
        let currentTask = currentCustomerTasks?[indexPath.row]
        cell.taskTitle.text = "Task \(indexPath.row + 1)"
        cell.taskTitle.text! += ": \(currentTask?.title ?? "")"
        if let cost = currentTask?.cost {
            if cost.isNumeric {
                cell.taskCost.text = "\(cost.currencyFormatting())"
            } else {
                cell.taskCost.text = cost
            }
        }
        cell.taskDescription.text = currentTask?.taskDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editTask", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let task = currentCustomerTasks?[indexPath.row] {
                context.delete(task)
                coreData.saveContext()
                currentCustomerTasks?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
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
            } catch let error as NSError {
                print("Could not fetch \(error)")
            }
        }
    }
    
    func saveSortedArray(named sortedArray: [Image]) {
        for (index, image) in sortedArray.enumerated() {
            image.tag = Int32(index)
            coreData.saveContext()
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
                coreData.saveContext()
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
            coreData.saveContext()
        }
    }

}

extension QuoteViewController: NewTaskDelegate {
    func newTaskVCDismissed() {
        taskTableView.reloadData()
    }
}

