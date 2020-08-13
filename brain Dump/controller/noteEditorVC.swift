//
//  noteEditorVC.swift
//  brain Dump
//
//  Created by natarajan k on 25/07/19.
//  Copyright © 2019 natarajan k. All rights reserved.
//

import UIKit

class noteEditorVC: UIViewController {
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    var note : Note?
    var userDidSave = false

    override func viewDidLoad() {
        super.viewDidLoad()
       navigationController?.navigationBar.tintColor = UIColor.white
//        navigationItem.leftBarButtonItem?.tintColor = .white
        
        
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem = doneBarButtonItem
//        navigationItem.rightBarButtonItem?.tintColor = .white
        
        if let note = self.note{
            noteTextView.text = note.body
            navigationItem.title = "Edit Note"
            categoryTextField.isUserInteractionEnabled = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noteTextView.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if userDidSave == false{
           savefunc()
        }
    }
    
    func savefunc(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,noteTextView.text.isEmpty == false else{return}
        let context = appDelegate.persistentContainer.viewContext
        
        if let note = self.note{
            note.body = noteTextView.text
        }else{
            let newNote = Note(context: context)
            newNote.body = noteTextView.text
            
            let category = Category(context: context)
            category.name = categoryTextField.text
            newNote.category = category
        }
        
        appDelegate.saveContext()
    }
    
    @objc func didTapDone(){
        print("Done")
        savefunc()
        userDidSave = true
        //once tap automaticaly pop up main VC
        navigationController?.popViewController(animated: true)
    }
    

   

}
