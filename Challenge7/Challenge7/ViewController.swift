//
//  ViewController.swift
//  Challenge7
//
//  Created by Tiberiu on 05.01.2021.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [Note]()
    var noteIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.reloadData()
        print(notes)
        //add toolbar
        let add = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, add]
        
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .systemYellow
        
        tableView.rowHeight = 90
        
        load()
    }
    
    @objc func addNote() {
        let note = Note(content: "", date: "")
        notes.insert(note, at: 0)
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController  {
            vc.delegate = self //the absence of this line made me spent hours trying to fix the crashing delegate from DetailViewController
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func updateTitle(content: String) {
        notes[noteIndex].content = content
    }
    
    func updateDate(date: String) {
        notes[noteIndex].date = date
    }
    
    func updateNotesList(notes: [Note]) {
        self.notes = notes
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "notes")
        } else {
            print("Failed to save notes.")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "notes") as? Data {
            let decoder = JSONDecoder()
            
            do {
                notes = try decoder.decode([Note].self, from: savedData)
            } catch {
                print("Failed to load notes")
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.item]
        // break the contents of the note into words in a array.
        let linesInContent = note.content.split(separator: "\n")
        var subtitle = ""
        
        if linesInContent.indices.contains(1) {
            subtitle = String(linesInContent[1])
        } else {
            subtitle = "No additional text"
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? NoteCell else {
            fatalError("unable to dequeue NoteCell")
        }
        cell.title.text = String(linesInContent.first ?? "Unknown")//first word in notes content should be the title.
        cell.date.text = note.date

        cell.subtitle.text = String(subtitle)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteIndex = indexPath.row
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController  {
         vc.delegate = self //the absence of this line made me spent hours trying to fix the crashing delegate from DetailViewController
            let note = notes[indexPath.item]
            vc.noteContent = note.content
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        save()
    }

}

