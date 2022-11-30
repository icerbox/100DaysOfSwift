//
//  ViewController.swift
//  Milestone_Projects_4-6
//
//  Created by Айсен Еремеев on 27.11.2022.
//

import UIKit

class RootViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  let productTableViewCell = "productTableViewCell"
  
  var products = [Product]()
  var pictures = [UIImage?]()
  var shoppingList =  [Product]()
  let currentImage: UIImageView? = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Список продуктов"
    tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "productTableViewCell")
    tableView.rowHeight = 150
    tableView.tableFooterView = UIView()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddProductWindow))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(openCart))
    products.append(Product(title: "Хлеб", price: "114 руб.", image: UIImage(named: "bread") ?? UIImage()))
    products.append(Product(title: "Тушенка", price: "114 руб.", image: UIImage(named: "stew") ?? UIImage()))
    products.append(Product(title: "Макароны", price: "114 руб.", image: UIImage(named: "pasta") ?? UIImage()))
    products.append(Product(title: "Кофе", price: "114 руб.", image: UIImage(named: "coffee") ?? UIImage()))
    products.append(Product(title: "Соль", price: "114 руб.", image: UIImage(named: "salt") ?? UIImage()))
    products.append(Product(title: "Сахар", price: "114 руб.", image: UIImage(named: "sugar") ?? UIImage()))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    print("Текущие продукты: \(products)")
    print("Текущие изображения: \(pictures.count)")
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell") as? ProductTableViewCell
    let currentLastItem = products[indexPath.row]
    cell?.product = currentLastItem
    return cell ?? ProductTableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let ac = UIAlertController(title: "Добавить товар в корзину?", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Добавить", style: .default, handler: {
      (action) in
      self.addToCart(product: self.products[indexPath.row])
    }))
    ac.addAction(UIAlertAction(title: "Закрыть окно", style: .cancel, handler: nil))
    present(ac, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let ac = UIAlertController(title: "Вы точно хотите удалить данный продукт?", message: nil, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Удалить", style: .default, handler: {
        (action) in
        print("deleted")
        self.products.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }))
      ac.addAction(UIAlertAction(title: "Закрыть окно", style: .cancel, handler: nil))
      present(ac, animated: true)
    }
  }
    
  @objc func openCart() {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Cart") as? CartViewController {
      vc.currentCart = shoppingList
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @objc func openAddProductWindow() {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "AddProduct") as? AddProductViewController {
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  func addToCart(product: Product) {
    shoppingList.append(product)
    print(shoppingList)
  }
  
  func deleteProduct() {
    
  }

}
