//
//  ViewController.swift
//  testUserDefaults
//
//  Created by Tiberiu on 18.12.2020.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UserTouchID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        
        let dict = ["Name": "Paul", "Country": "UK"]
        defaults.set(dict, forKey: "SavedDict")
        
        let printDict = defaults.object(forKey: "SavedDict") as? [String: String] ?? [String: String]()
        
        print(printDict)
    }


}

