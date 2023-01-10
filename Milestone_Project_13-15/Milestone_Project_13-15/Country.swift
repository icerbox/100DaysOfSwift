//
//  Country.swift
//  Milestone_Project_13-15
//
//  Created by Айсен Еремеев on 09.01.2023.
//

import Foundation

struct Country: Codable {
  let name: String
  let code: String
  let capital: String
  let flag: String
  let currency: Currency
}

struct Currency: Codable {
  let code: String
  let name: String
//  let symbol: String
}

