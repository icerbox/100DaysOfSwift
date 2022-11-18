//
//  DetailViewController.swift
//  project1
//
//  Created by Андрей Антонен on 18.11.2022.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet var imageView: UIImageView!
  
  var selectedImage: String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
      if let imageToLoad = selectedImage {
        imageView.image = UIImage(named: imageToLoad)
      }
    }

}
