//
//  TableViewController.swift
//  Project4
//
//  Created by Айсен Еремеев on 24.11.2022.
//

import UIKit

class TableViewController: UITableViewController {
  
  var websites = ["apple.com", "iltumen.ru", "hackingwithswift.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
      title = "Выберите сайт для загрузки:"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
      cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Website") as? WebViewController {
      vc.selectedWebsite = websites[indexPath.row]
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}



