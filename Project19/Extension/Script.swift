//
//  Script.swift
//  Extension
//
//  Created by Айсен Еремеев on 09.02.2023.
//

import UIKit

class Script: NSObject, NSCoding {
    var currentPage: String
    var title: String
    var script: String
    
    init(currentPage: String, title: String, script: String) {
        self.currentPage = currentPage
        self.title = title
        self.script = script
    }
    
    required init?(coder aDecoder: NSCoder) {
        currentPage = aDecoder.decodeObject(forKey: "currentPage") as? String ?? ""
        title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        script = aDecoder.decodeObject(forKey: "script") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(currentPage, forKey: "currentPage")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(script, forKey: "script")
    }
    
}
