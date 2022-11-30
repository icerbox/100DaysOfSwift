//
//  CartViewController.swift
//  Milestone_Projects_4-6
//
//  Created by Айсен Еремеев on 27.11.2022.
//

import UIKit

class CartViewController: UITableViewController {
  
  var currentCart = [Product]()
  
  let cartTableViewCell = "cartTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.title = "Ваша текущая корзина"
      
      tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "cartTableViewCell")
      tableView.rowHeight = 150
      tableView.tableFooterView = UIView()
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    print("Сейчас в корзине: \(currentCart)")
  }

    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentCart.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentCart", for: indexPath)
    let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableViewCell") as? ProductTableViewCell
    let currentLastItem = currentCart[indexPath.row]
    cell?.product = currentLastItem
    return cell ?? ProductTableViewCell()
  }
}
