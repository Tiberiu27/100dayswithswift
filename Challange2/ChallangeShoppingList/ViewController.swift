//
//  ViewController.swift
//  ChallangeShoppingList
//
//  Created by Tiberiu on 10.12.2020.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [spacer, shareButton]
        navigationController?.isToolbarHidden = false
        
        if shoppingList.isEmpty {
            shoppingList = ["None"]
        }
        
        refreshList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add Item", message: "You are adding...", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {[weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            
            //this forbbids only whitespace/empty items from adding to the list
            if answer.trimmingCharacters(in: .whitespaces).isEmpty {
                return
            }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
            
    }
    func submit(_ answer: String) {
        title = "Last item added: \(answer)"
        
        let answer = answer.lowercased()
        shoppingList.insert(answer, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func refreshList() {
        title = "Last item added: None"
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func shareList() {
        let list = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        popoverPresentationController?.barButtonItem = toolbarItems?[0]
        present(vc, animated: true)
    }
}

