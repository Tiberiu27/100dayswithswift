//
//  ViewController.swift
//  Challenge5
//
//  Created by Tiberiu on 31.12.2020.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let data = loadJSON(file: "countries") {
            countries = data
        } else {
            print("Failed to load countries")
        }
    }
    
    func loadJSON(file: String) -> [Country]? {
        if let url = Bundle.main.url(forResource: file, withExtension: ".json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Countries.self, from: data)
                return jsonData.results
            } catch {
                print("error: \(error)")
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.facts = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }

    }


}



