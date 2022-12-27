//
//  Picture.swift
//  project1
//
//  Created by Айсен Еремеев on 15.12.2022.
//

import UIKit

@objc(Picture)
class Picture: NSObject, NSCoding {
  var name: String
  var clicked: Int64
  
  init(name: String, clicked: Int64) {
    self.name = name
    self.clicked = clicked
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    clicked = aDecoder.decodeObject(forKey: "clicked") as? Int64 ?? 0
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(clicked, forKey: "clicked")
  }
}

