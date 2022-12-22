//
//  Countrie.swift
//  Project2
//
//  Created by Айсен Еремеев on 19.12.2022.
//

import UIKit

class Score: NSObject, NSCoding {
  var highScore: Int
  
  init(highScore: Int) {
    self.highScore = highScore
  }
  
  required init?(coder aDecoder: NSCoder) {
    highScore = aDecoder.decodeObject(forKey: "highScore") as? Int ?? 0
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(highScore, forKey: "highScore")
  }
  
}
