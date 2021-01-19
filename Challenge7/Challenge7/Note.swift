//
//  Note.swift
//  Challenge7
//
//  Created by Tiberiu on 05.01.2021.
//

import UIKit

class Note: NSObject, Codable {
    var content: String
    var date: String
    
    init(content: String, date: String) {
        self.content = content
        self.date = date
    }
}
