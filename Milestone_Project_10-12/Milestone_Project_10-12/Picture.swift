//
//  Picture.swift
//  Milestone_Project_10-12
//
//  Created by Айсен Еремеев on 25.12.2022.
//

import UIKit

class Picture: NSObject, NSCoding {
  
    var fileName: String
    var caption: String
    
    init(fileName: String, caption: String) {
        self.fileName = fileName
        self.caption = caption
    }
    
  required init?(coder aDecoder: NSCoder) {
    fileName = aDecoder.decodeObject(forKey: "fileName") as? String ?? ""
    caption = aDecoder.decodeObject(forKey: "caption") as? String ?? ""
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(fileName, forKey: "fileName")
    aCoder.encode(caption, forKey: "caption")
  }
}
