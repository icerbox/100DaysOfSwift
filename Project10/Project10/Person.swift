//
//  Person.swift
//  Project10
//
//  Created by Айсен Еремеев on 12.12.2022.
//

import UIKit

class Person: NSObject {
  var name: String
  var image: String
  
  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
}
