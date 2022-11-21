//
//  ViewController.swift
//  Milestone_Project_1_2_3
//
//  Created by Айсен Еремеев on 21.11.2022.
//

import UIKit

class ViewController: UITableViewController {
  
  var pictures = [UIImage?]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.register(ImageViewCell.self, forCellReuseIdentifier: "ImageViewCell")
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    
    for item in items {
      if item.hasPrefix("nssl") {
          pictures.append(UIImage(named: item))
      }
      print(item)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }
    
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as! ImageViewCell
    cell.mainImageView.image = pictures[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let currentImage = pictures[indexPath.row]
    let imageCrop = currentImage!.getCropRatio()
    return tableView.frame.width / imageCrop
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      vc.selectedImage = pictures[indexPath.row]
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

extension UIImage {
  func getCropRatio() -> CGFloat {
    let widthRatio = CGFloat(self.size.width / self.size.height)
    return widthRatio
  }
}
