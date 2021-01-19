//
//  DetailViewController.swift
//  Challenge5
//
//  Created by Tiberiu on 31.12.2020.
//

import UIKit

class DetailViewController: UITableViewController {
    var facts: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let facts = facts else { return }
        //the next 5 lines are preffred to autoreisze the title's font :)
        let navbarTitle = UILabel()
        navbarTitle.text = "Did you know these about \(facts.name)?"
        navbarTitle.minimumScaleFactor = 0.5
        navbarTitle.adjustsFontSizeToFitWidth = true
        navigationItem.titleView = navbarTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    @objc func shareTapped() {
        guard let facts = facts else {
            print("No facts found")
            return
        }
        let country = "Check out this info about \(facts.name)!"
        let capital = "Capital: \(facts.capital)"
        let size = "Size: \(facts.size)"
        let population = "Population: \(facts.population) milion"
        let currency = "Currency: \(facts.currency)"
        let vc = UIActivityViewController(activityItems: [country, capital, size, population, currency], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Fact", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Capital is: \(facts?.capital ?? "Unknown")"
        case 1:
            cell.textLabel?.text = "It has a size of \(facts?.size ?? "Unknown")"
        case 2:
            cell.textLabel?.text = "It has a population of \(facts?.population ?? 0) milion"
        case 3:
            cell.textLabel?.text = "It uses \(facts?.currency ?? "Unknown") as currency"
        default:
            cell.textLabel?.text = nil
        }
        return cell
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
