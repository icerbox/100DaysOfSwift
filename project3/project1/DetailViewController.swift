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
      
        title = "Picture \(String(describing: currentArrayItemIndex! + 1)) of \(String(describing: picturesArrayCount!))"
      
        navigationItem.largeTitleDisplayMode = .never
        
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
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
  
  @objc func shareTapped() {
    
    guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
      print("No image found")
      return
    }
    let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
}
