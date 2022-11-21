//
//  DetailViewController.swift
//  Milestone_Project_1_2_3
//
//  Created by Айсен Еремеев on 21.11.2022.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  
  var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

      if let imageToLoad = selectedImage {
        imageView.image = imageToLoad
      }
    }
    
}
