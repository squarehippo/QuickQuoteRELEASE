//
//  NewQuoteViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/24/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class QuoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    var currentPDF = [String]()
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var quoteNumber: UILabel!
    @IBOutlet weak var quoteDate: UILabel!
    @IBOutlet var imageButtonCollection: [ImageButton]!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTableView.dataSource = self
        taskTableView.delegate = self
        taskTableView.layer.cornerRadius = 10
        imagePicker.delegate = self
        
        assignCurrentQuoteInformation()
        setUpViewTasks()
        
        currentPDF = ["This is where the PDF will be stored"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AddImagesToButtons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewTaskSegue" {
            if let destinationVC = segue.destination as? NewTaskViewController {
                destinationVC.currentQuote = currentQuote
            }
        }
        //Try guard statement...
        if segue.identifier == "editTask" {
            if let destinationVC = segue.destination as? EditTaskViewController {
                if let currentTasks = currentCustomerTasks {
                    if let selectedRow = taskTableView.indexPathForSelectedRow  {
                        destinationVC.currentTask = currentTasks[selectedRow.row]
                    }
                }
            }
        }
        if segue.identifier == "workOrder" {
            if let destinationVC = segue.destination as? WorkOrderViewController {
                destinationVC.currentQuote = currentQuote
            }
        }
    }
    
    //MARK: - View Related
    
    func setUpViewTasks() {
        if isNewQuote {
            title = "New quote for \(currentCustomer?.name ?? "customer")"
        } else {
            title = "Quote for \(currentQuote?.customer?.name ?? "customer")"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onDismissNewTask), name: .onDismissNewTask, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeCustomer), name: .onChangeCustomer, object: nil)
    }
    
    @objc func onDismissNewTask() {
        loadCustomerTasks()
        taskTableView.reloadData()
    }
    
    @objc func onChangeCustomer() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func assignCurrentQuoteInformation() {
        if isNewQuote {
            currentQuoteNumber = makeQuoteNumber(withUser: "Adam Lyon", andDate: Date())
            quoteDate.text = Date().dateToString()
            saveNewQuote()
        } else {
            quoteDate.text = currentQuote?.dateCreated?.dateToString()
            currentQuoteNumber = currentQuote?.quoteNumber
        }
        quoteNumber.text = "Quote: " + (currentQuoteNumber ?? "error")
        loadCustomerTasks()
    }
    
    func refreshUI() {
        loadViewIfNeeded()
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let pdfPath = createPDF()
        let pdfURL = URL(fileURLWithPath: pdfPath)
        let uiavc = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            uiavc.popoverPresentationController?.barButtonItem = self.shareButton
        }
        present(uiavc, animated: true, completion: nil)
    }
    
    func createPDF() -> String {
        return ""
    }
    
    func toPDF(views: [UIView]) {
        if views.isEmpty { return }
        pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), nil)
        let context = UIGraphicsGetCurrentContext()
        for view in views {
            UIGraphicsBeginPDFPage()
            view.layer.render(in: context!)
        }
        UIGraphicsEndPDFContext()
    }
    
    
    //MARK: - Quote Related
    
    func saveNewQuote() {
        let newQuote = Quote(context: context)
        newQuote.quoteNumber = currentQuoteNumber
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
    
    func fetchCurrentImage(imageTag: Int32) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "tag = %@", imageTag)
        do {
            currentImageArray = try context.fetch(fetchRequest) as! [Image]
            currentImage = currentImageArray.first
        } catch let error as NSError {
            print("Could not fetch \(error)")
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
        let text = currentCustomerTasks?[indexPath.row]
        cell.taskTitle.text = text?.title
        cell.taskCost.text = text?.cost
        cell.taskDescription.text = text?.taskDescription
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
        if let quote = currentQuote {
            imageArray = (Array(quote.images!) as? [Image])!
        }
    }
    
    func AddImagesToButtons() {
        loadImageArray()
        positionAddImageButton()
        
        let sortedArray = imageArray.sorted { $0.tag < $1.tag }
        for (image) in sortedArray where image.imageData != nil {
            for button in imageButtonCollection {
                if button.tag == image.tag {
                    button.isEnabled = true
                    button.imageView?.contentMode = .scaleAspectFill
                    button.setImage(UIImage(data: image.imageData!), for: .normal)
                }
            }
        }
    }
    
    @IBAction func imageButtonPressed(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.view.tag = sender.tag
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let resizedImage = pickedImage.resizedTo1MB() {
                if let imageData = resizedImage.pngData() {
                    let buttonTag = picker.view.tag
                    saveImage(data: imageData, tag: buttonTag)
                }
            }
        }
        dismiss(animated: true, completion: nil)
        AddImagesToButtons()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func positionAddImageButton() {
        if imageArray.count < 5 {
            for button in imageButtonCollection {
                if button.tag > imageArray.count {
                    button.isEnabled = false
                    button.setImage(nil, for: .normal)
                    button.backgroundColor = UIColor.clear
                }
                if button.tag == imageArray.count {
                    button.isEnabled = true
                    button.imageView?.contentMode = .center
                    button.setImage(UIImage(named: "addPhoto"), for: .normal)
                    button.backgroundColor = UIColor.lightGray
                }
            }
        }
    }
    
    func saveImage(data: Data, tag: Int) {
        if imageArray.count != tag {
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

    
//    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
//        if sender.state == UIGestureRecognizer.State.began {
//            imageButton = sender.view as? TaskImageButton
//            
//            if let buttonTag = imageButton?.tag {
//                if buttonTag <= photoArray.count {
//                    imageButton?.wiggle()
//                    let width = imageButton?.frame.width ?? 50
//                    let height = imageButton?.frame.height ?? 50
//                    deleteButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
//                    deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
//                    imageButton?.addSubview(deleteButton)
//                }
//            }
//        }
//    }
//    
//    @objc func deleteButtonTapped(_ sender: UIButton) {
//        if let buttonTag = sender.superview?.tag {
//            deleteImage(imageIndex: buttonTag - 1)
//            buttonToDelete = nil
//        }
//    }
//    
//    func deleteImage(imageIndex: Int) {
//        clearAllAnimations()
//        let task = currentTask
//        let photo = photoArray[imageIndex]
//        task?.removeFromPhotos(photo)
//        coreData.saveContext()
//        
//        loadPhotos()
//    }
//    
//    func clearAllAnimations() {
//        imageButton?.layer.removeAllAnimations()
//        imageButton?.layer.transform = CATransform3DIdentity
//        imageButton?.removeDeleteButton()
//    }
    
    func rotateImage(image: UIImage) -> UIImage {
        if (image.imageOrientation == UIImage.Orientation.up) {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy!
    }
}

extension QuoteViewController: NewTaskDelegate {
    func newTaskVCDismissed() {
        taskTableView.reloadData()
    }
}
