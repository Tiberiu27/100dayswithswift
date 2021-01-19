//
//  DetailViewController.swift
//  Challenge7
//
//  Created by Tiberiu on 05.01.2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    weak var delegate: ViewController!
    
    var noteContent = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = noteContent
        
        //observer on the keyboard so the done button is shown as you're typing into note
        NotificationCenter.default.addObserver(self, selector: #selector(showNavigationButtons), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back to Notes", style: .plain, target: self, action: #selector(backToRoot))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //very important line here, calls a method from the DELEGATE view, never done it before
        let add = UIBarButtonItem(barButtonSystemItem: .compose, target: delegate, action: #selector(delegate.addNote))
        let remove = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        
        toolbarItems = [spacer, remove, add]
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .systemYellow
    }
    
    @objc func backToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func deleteNote() {
        delegate.notes.remove(at: delegate.noteIndex)
        delegate.save()
        delegate.tableView.reloadData()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func showNavigationButtons() {
        let saveButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveNote))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
    
    func getDate() -> String {
        let  date = Date()
        let formatDate = DateFormatter()
        formatDate.locale = Locale(identifier: "en_GB")
        formatDate.dateStyle = .short
        let formattedDate = formatDate.string(from: date) + "\t"
        return formattedDate
    }
    
    @objc func saveNote() {
        let content = textView?.text ?? ""
        
        //the trick here is when the DetailViewController is called an empty note is created in the ViewController(see addNote() method), so we delete it if it stays empty
        if content.isEmpty {
            deleteNote()
            return

        }
        
        delegate.updateTitle(content: content)
        delegate.updateDate(date: getDate())
        delegate.save()
        delegate.tableView.reloadData()
        navigationItem.rightBarButtonItem = nil // hides only the "done" button, leaving the share one
        view.endEditing(true) //dismisses the keyboard

    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: [noteContent], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
 


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



