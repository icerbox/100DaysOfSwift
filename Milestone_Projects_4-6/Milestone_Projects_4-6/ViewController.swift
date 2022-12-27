//
//  ViewController.swift
//  Milestone_Projects_4-6
//
//  Created by Айсен Еремеев on 27.11.2022.
//

import UIKit

class ViewController: UITableViewController {
  
  
  var products = [String]()
  var shoppingList =  [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Список продуктов"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(addProduct))
    products.append("Хлеб")
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath)
    cell.textLabel?.text = products[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let ac = UIAlertController(title: "Добавить товар в корзину?", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Добавить", style: .default, handler: {
      (action) in
      self.addToCart(item: self.products[indexPath.row])
    }))
    ac.addAction(UIAlertAction(title: "Закрыть окно", style: .cancel, handler: nil))
    present(ac, animated: true)
  }
  
  @objc func addProduct() {
    let ac = UIAlertController(title: "Введите название продукта", message: nil, preferredStyle: .alert)
    ac.addTextField()
    let submitAction = UIAlertAction(title: "Ввести", style: .default) {
      [weak self, weak ac] _ in
      guard let title = ac?.textFields?[0].text else { return }
      self?.products.append(title)
      self?.tableView.reloadData()
    }
    ac.addAction(submitAction)
    present(ac, animated: true)
  }
  
  func addToCart(item: String) {
    shoppingList.append(item)
    print(shoppingList)
  }
  func openCart() {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Cart") as? CartViewController {
      vc.currentCart = shoppingList
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

