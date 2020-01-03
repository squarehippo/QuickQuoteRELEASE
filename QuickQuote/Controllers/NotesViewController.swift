//
//  NotesViewController.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/10/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, UITextViewDelegate {
    
    var currentQuote: Quote?
    let coreData = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!

    @IBOutlet weak var notesTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.layer.cornerRadius = 10
        notesTextView.delegate = self
        notesTextView.text = currentQuote?.noteForWorkOrder
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let quote = currentQuote else { return }
        quote.noteForWorkOrder = notesTextView.text
        coreData?.saveContext()
    }

}
