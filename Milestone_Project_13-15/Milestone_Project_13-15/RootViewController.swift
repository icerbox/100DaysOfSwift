//
//  ViewController.swift
//  Milestone_Project_13-15
//
//  Created by Айсен Еремеев on 09.01.2023.
//

import UIKit

class RootViewController: UITableViewController, UINavigationControllerDelegate {

  var countries = [Country]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Список стран"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    fetchData()
  }
  
  func showError() {
    let ac = UIAlertController(title: "Loading error", message: "There was a error problem loading the feed; please check your connection and try again", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let country = countries[indexPath.row]
    
    cell.textLabel?.text = country.name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailViewController = DetailViewController()
    detailViewController.selectedCountry = countries[indexPath.row]
    show(detailViewController, sender: self)
  }
  
  func parse(json: Data) {
    print("Начинаем парсить данные")
    let decoder = JSONDecoder()
    
//    if let jsonCountries = try? decoder.decode(Countries.self, from: json) {
//      print(jsonCountries)
//      countries = jsonCountries.countries
//      print(countries)
//      tableView.reloadData()
//    } else {
//      showError()
//    }
    do {
      let jsonCountries = try decoder.decode(Countries.self, from: json)
      countries = jsonCountries.countries
      tableView.reloadData()
    } catch {
      print(error)
    }
  }

  private func fetchData() {
    print("Начинаем фетчить данные")
    let urlString: String
    
    urlString = "https://raw.githubusercontent.com/icerbox/100DaysOfSwift/master/Milestone_Project_13-15/Milestone_Project_13-15/countries2.json"
    
//    urlString = "https://raw.githubusercontent.com/mledoze/countries/master/countries.json"
    
    if let url = URL(string: urlString) {
      print("урл получил")
      if let data = try? Data(contentsOf: url) {
        parse(json: data)
        return
      }
    }
    showError()
  }
}

