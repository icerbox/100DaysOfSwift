//
//  CartViewController.swift
//  Milestone_Projects_4-6
//
//  Created by Айсен Еремеев on 27.11.2022.
//

import UIKit

class CartViewController: UITableViewController {
  
  var currentCart = [Product]()
  
//  let cartTableViewCell = "cartTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.title = "Ваша текущая корзина"
      
      tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "cartTableViewCell")
      tableView.rowHeight = 150
      tableView.tableFooterView = UIView()
      print(currentCart)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableViewCell") as? CartTableViewCell
    let currentLastItem = currentCart[indexPath.row]
    cell?.product = currentLastItem
    return cell ?? ProductTableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let ac = UIAlertController(title: "Вы точно хотите удалить данный продукт?", message: nil, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Удалить", style: .default, handler: {
        (action) in
        print("deleted")
        self.currentCart.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }))
      ac.addAction(UIAlertAction(title: "Закрыть окно", style: .cancel, handler: nil))
      present(ac, animated: true)
    }
  }
}
