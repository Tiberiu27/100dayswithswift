//
//  Photo.swift
//  Challenge4
//
//  Created by Tiberiu on 19.12.2020.
//

import UIKit

class Photo: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}
