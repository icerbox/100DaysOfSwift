//
//  Picture.swift
//  project1
//
//  Created by Айсен Еремеев on 15.12.2022.
//

import UIKit

class Picture: NSObject, NSCoding {
  var name: String
  var index: Int
  var clicked: Int = 0
  
  init(name: String, index: Int, clicked: Int) {
    self.name = name
    self.index = index
    self.clicked = clicked
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    index = aDecoder.decodeObject(forKey: "index") as? Int ?? 0
    clicked = aDecoder.decodeObject(forKey: "clicked") as? Int ?? 0
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(index, forKey: "index")
    aCoder.encode(index, forKey: "clicked")
  }
}

