//
//  ImageTableViewCell.swift
//  Milestone_Project_1_2_3
//
//  Created by Айсен Еремеев on 21.11.2022.
//

import UIKit

class ImageViewCell: UITableViewCell {
  lazy var mainImageView: UIImageView = {
    var imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.addSubview(mainImageView)
    
    NSLayoutConstraint.activate([
      mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      mainImageView.topAnchor.constraint(equalTo: topAnchor),
      mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
