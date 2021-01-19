//
//  ViewController.swift
//  Project1
//
//  Created by Tiberiu on 29.11.2020.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    let message = "This is the best app!"
    var viewCount = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Storm Viewer"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(praiseTapped))
        
        performSelector(inBackground: #selector(grabPics), with: nil)
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
        loadDefaults()


    }
    
    @objc func grabPics() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path).sorted()
        
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
    }
    //load views
    func loadDefaults() {
        let defaults = UserDefaults.standard
        if let viewCount = defaults.object(forKey: "viewCount") as? [String: Int] {
            self.viewCount = viewCount
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        
        let selectedPicture = pictures[indexPath.row]
        if let count = viewCount[selectedPicture] {
            cell.detailTextLabel?.text = "You viewed this \(count) times"
        } else {
            cell.detailTextLabel?.text = "You didn't viewd this one yet"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPicture = pictures[indexPath.row]
        if viewCount[selectedPicture] != nil {
            //key exists
            viewCount[selectedPicture]! += 1
        } else {
            viewCount[selectedPicture] = 1
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        //save views
        let defaults = UserDefaults.standard
        defaults.set(viewCount, forKey: "viewCount")
        
        // 1. Try to load the "Detail" view controller and typecasting it to be the DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2. Succes! set it's selected image proprety.
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            // 3. Now Push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func praiseTapped() {
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
}

