//
//  ProductTableViewCell.swift
//  Milestone_Projects_4-6
//
//  Created by Айсен Еремеев on 29.11.2022.


import UIKit

class ProductTableViewCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(stackView)
    contentView.addSubview(stackView2)
    setupConstraints()
  }
  
  var product: Product? {
    didSet {
      productTitle.text = "Наименование продукта: " + product!.title
      productPrice.text = "Цена: " + product!.price
      productImage.image = product?.image
    }
  }
  
  lazy var productImage: UIImageView = {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  lazy var productTitle: UILabel = {
    let label = UILabel()
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    return label
  }()

  lazy var productPrice: UILabel = {
    let label = UILabel()
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    return label
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillProportionally
    stackView.addArrangedSubview(productImage)
//    stackView.backgroundColor = .red
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  lazy var stackView2: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .fillProportionally
    stackView.addArrangedSubview(productTitle)
    stackView.addArrangedSubview(productPrice)
//    stackView.backgroundColor = .green
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    productImage.image = nil
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      stackView.trailingAnchor.constraint(equalTo: stackView2.leadingAnchor),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
      
      stackView2.leadingAnchor.constraint(equalTo: stackView.trailingAnchor),
      stackView2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      stackView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stackView2.topAnchor.constraint(equalTo: contentView.topAnchor)
    ])
  }
}
