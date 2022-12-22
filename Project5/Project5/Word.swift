//
//  Word.swift
//  Project5
//
//  Created by Айсен Еремеев on 19.12.2022.
//

import UIKit

class Word: NSObject, NSCoding {
  var currentWord: String
  var usedWordsArray: String
  
  init(currentWord: String, usedWordsArray: String) {
    self.currentWord = currentWord
    self.usedWordsArray = usedWordsArray
  }
  
  required init?(coder aDecoder: NSCoder) {
    currentWord = aDecoder.decodeObject(forKey: "currentWord") as? String ?? ""
    usedWordsArray = aDecoder.decodeObject(forKey: "usedWordsArray") as? String ?? ""
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(currentWord, forKey: "currentWord")
    aCoder.encode(usedWordsArray, forKey: "usedWordsArray")
  }
}
