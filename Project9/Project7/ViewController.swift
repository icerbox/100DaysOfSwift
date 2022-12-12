//
//  ViewController.swift
//  Project7
//
//  Created by Айсен Еремеев on 01.12.2022.
//

import UIKit
import WebKit

class ViewController: UITableViewController {
  
  var petitions = [Petition]()
  var sortedPetitions = [Petition]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Новости"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openCredits))
    
    performSelector(inBackground: #selector(fetchJSON), with: nil)
  }
  
  @objc func fetchJSON() {
    let urlString: String
    
    var tabTag: Int = 0
    DispatchQueue.main.async {
      tabTag = (self.navigationController?.tabBarItem.tag)!
    }
    
    if tabTag == 0 {
      urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
      urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
  
    // Раскрываем url
    if let url = URL(string: urlString) {
      // Раскрываем data
      if let data = try? Data(contentsOf: url) {
        // Если все в порядке запускаем метод parse()
        parse(json: data)
        return
      }
    }
    performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(filterPetitions))
  }
  
  @objc func showError() {
      let ac = UIAlertController(title: "Loading error", message: "There was a error problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
  }
  
  // Метод parse берет JSON в формате Data
  func parse(json: Data) {
    // Объявляем экземпляр декодера JSONDecoder()
    let decoder = JSONDecoder()
    // Запрашиваем у декодера забрать данные JSON в структуру Petitions.self
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
      // Назначаем массиву petitions полученные в массив jsonPetitions.result данные JSON
      petitions = jsonPetitions.results
      sortedPetitions = petitions
      // обновляем таблицу
//      tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
      }
    } else {
      performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sortedPetitions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let petition = sortedPetitions[indexPath.row]
    
    cell.textLabel?.text = petition.title
    cell.detailTextLabel?.text = petition.body
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DetailViewController()
    vc.detailItem = petitions[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc func openCredits() {
    let ac = UIAlertController(title: nil, message: "Использованы данные из открытого источника We The People API of the Whitehouse", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
    present(ac, animated: true)
  }
  
  @objc func filterPetitions() {
    let ac = UIAlertController(title: nil, message: "Введите ключевое слово для фильтрации", preferredStyle: .alert)
    ac.addTextField()
    
    ac.addAction(UIAlertAction(title: "Искать", style: .default) { [unowned ac] _ in
      let answer = ac.textFields![0].text!
      DispatchQueue.global(qos: .background).async {
        if !answer.isEmpty {
          let filtered = self.petitions.filter { petition in
            return petition.title.contains(answer)
          }
          self.sortedPetitions = filtered
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
          
        } else {
          self.sortedPetitions = self.petitions
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        }
      }
    })
    present(ac, animated: true)
  }
}
