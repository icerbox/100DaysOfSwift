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
  var picturesArrayCount: Int?
  var currentArrayItemIndex: Int?
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        assert(selectedImage != nil, "Selected image should always have a value")
      
        title = "Picture \(String(describing: currentArrayItemIndex! + 1)) of \(String(describing: picturesArrayCount!))"
      
        navigationItem.largeTitleDisplayMode = .never
        
        
      if let imageToLoad = selectedImage {
        imageView.image = UIImage(named: imageToLoad)
      }
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }
}
