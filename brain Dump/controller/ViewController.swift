//
//  ViewController.swift
//  brain Dump
//
//  Created by natarajan k on 08/07/19.
//  Copyright © 2019 natarajan k. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var notes = [Note]()
    
    @IBOutlet weak var noteSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
        // Do any additional setup after loading the view.
//        loadData()
        tableView.rowHeight = UITableView.automaticDimension
        noteSearchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    func loadData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
           let fetchObject = try context.fetch(fetchRequest)
            guard  let notes = fetchObject as? [Note] else {return}
            self.notes = notes
            self.tableView.reloadData()
        }catch{
            print(error)
        }
        
        
    }

    @IBAction func didTapAdd(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segue.main.NoteVCtoNoteEditorVC", sender: nil)
        
//        let alert = UIAlertController(title: "Add Note", message: nil, preferredStyle: .alert)
//        alert.addTextField()
//
//        let action = UIAlertAction(title: "Save", style: .default) { (_) in
//          guard  let  noteBody = alert.textFields?.first?.text,
        //core data part
        
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            else {return}
//            let context = appDelegate.persistentContainer.viewContext
//            let newNote = Note(context: context)
//            newNote.body = noteBody
//            appDelegate.saveContext()
//            self.notes.append(newNote)
//            self.tableView.reloadData()
//        }
//        alert.addAction(action)
//        present(alert,animated: true)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NoteCell else {return UITableViewCell()}
        let note = notes[indexPath.row]
        cell.populate(with:note)

//        cell.textLabel?.text = note.body
//        cell.textLabel?.numberOfLines = 0
        return cell
        }
    
    //tableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        performSegue(withIdentifier: "segue.main.NoteVCtoNoteEditorVC", sender: note)
//        print(note.body)
//        let alert = UIAlertController(title: "Edit Note", message: nil, preferredStyle: .alert)
//        alert.addTextField { (textField) in
//            textField.text = note.body
//        }
//        let updateAction = UIAlertAction(title: "Update", style: .default) { (_) in
//            guard
//            let updatedBody = alert.textFields?.first?.text,
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            else{return}
//            note.body = updatedBody
//            appDelegate.saveContext()
//            self.loadData()
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(updateAction)
//        alert.addAction(cancelAction)
//        present(alert,animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard  editingStyle == .delete else {return}
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let note = notes[indexPath.row]
        do{
            context.delete(note)
            try context.save()
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        catch{
            print(error)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let NoteEditorVc = segue.destination as? noteEditorVC,let note = sender as? Note{
            NoteEditorVc.note = note
            
        }
    }
    
    
    
    @IBAction func PrintValue(_ sender: Any) {

        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = "print job"
        printController.printInfo = printInfo

//        guard let category = categoryLabel.text else {return}
//        let noteBody = noteBodyLabel.text
       
        let formatter = UIMarkupTextPrintFormatter(markupText: "helloworld")
        formatter.perPageContentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        printController.printFormatter = formatter
        printController.present(animated: true, completionHandler: nil)
    }


    
    }

extension ViewController:UISearchBarDelegate,UISearchDisplayDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != " "
        {
            var predicate:NSPredicate = NSPredicate()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            predicate = NSPredicate(format: "category.name contains[c]'\(searchText)'")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            fetchRequest.predicate = predicate
            do{
                let fetchObject = try context.fetch(fetchRequest)
                guard  let notes = fetchObject as? [Note] else {return}
                self.notes = notes
//                notes = try context.fetch(fetchRequest) as! [Note]
            }catch{
                print("could not find the note")
            }
        }else {
            loadData()
                }
        tableView.reloadData()

        
}
}
