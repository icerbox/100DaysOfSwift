//
//  PictureTableViewCell.swift
//  Milestone_Project_10-12
//
//  Created by Айсен Еремеев on 25.12.2022.
//

import UIKit

class PictureCell: UITableViewCell {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    var image: UIImageView = {
      var image = UIImageView()
      image.translatesAutoresizingMaskIntoConstraints = false
      image.contentMode = .scaleAspectFit
      return image
    }()
    
    var caption: UILabel = {
      var label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textAlignment = .center
      return label
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
    }
    
  private func setupViews() {
    addSubview(image)
    addSubview(caption)
    NSLayoutConstraint.activate([
      image.topAnchor.constraint(equalTo: topAnchor),
      image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
      image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
      image.heightAnchor.constraint(equalToConstant: 190),
      caption.topAnchor.constraint(equalTo: image.bottomAnchor),
      caption.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
      caption.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
      caption.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}
