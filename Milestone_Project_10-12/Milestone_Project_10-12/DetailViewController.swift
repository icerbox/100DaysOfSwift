//
//  DetailViewController.swift
//  Milestone_Project_10-12
//
//  Created by Айсен Еремеев on 26.12.2022.
//

import UIKit

class DetailViewController: UIViewController {
  
  var selectedImage: Picture?
    
  lazy var image: UIImageView = {
    var image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  lazy var caption: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()

    override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      view.backgroundColor = .white
    }
  
  func setupViews() {
    view.addSubview(image)
    view.addSubview(caption)
    NSLayoutConstraint.activate([
      image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
      image.widthAnchor.constraint(equalTo: view.widthAnchor),
      caption.topAnchor.constraint(equalTo: image.bottomAnchor),
      caption.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      caption.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
    navigationItem.largeTitleDisplayMode = .never
    
    DispatchQueue.global(qos: .background).async { [self] in
      let path = self.getDocumentsDirectory().appendingPathComponent(self.selectedImage!.fileName)
      DispatchQueue.main.async {
        self.image.image = UIImage(contentsOfFile: path.path)
        self.caption.text = self.selectedImage!.caption
      }
    }
    
  }
      
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
