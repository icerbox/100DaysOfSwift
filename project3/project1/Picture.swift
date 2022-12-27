//
//  Picture.swift
//  project1
//
//  Created by Айсен Еремеев on 15.12.2022.
//

import UIKit

<<<<<<< HEAD
@objc(Picture)
class Picture: NSObject, NSCoding {
  var name: String
  var clicked: Int64
  
  init(name: String, clicked: Int64) {
    self.name = name
=======
class Picture: NSObject, NSCoding {
  var name: String
  var index: Int
  var clicked: Int = 0
  
  init(name: String, index: Int, clicked: Int) {
    self.name = name
    self.index = index
>>>>>>> 9dc221fc9df6cb5edb272e1c38a0839679477d12
    self.clicked = clicked
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
<<<<<<< HEAD
    clicked = aDecoder.decodeObject(forKey: "clicked") as? Int64 ?? 0
=======
    index = aDecoder.decodeObject(forKey: "index") as? Int ?? 0
    clicked = aDecoder.decodeObject(forKey: "clicked") as? Int ?? 0
>>>>>>> 9dc221fc9df6cb5edb272e1c38a0839679477d12
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
<<<<<<< HEAD
    aCoder.encode(clicked, forKey: "clicked")
=======
    aCoder.encode(index, forKey: "index")
    aCoder.encode(index, forKey: "clicked")
>>>>>>> 9dc221fc9df6cb5edb272e1c38a0839679477d12
  }
}

