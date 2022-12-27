//
//  CartViewController.swift
//  Milestone_Projects_4-6
//
//  Created by Андрей Антонен on 27.11.2022.
//

import UIKit

class CartViewController: UITableViewController {
  
  var currentCart: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let currentCart = currentCart else {
      return 0
    }
    return curr
  }



}
