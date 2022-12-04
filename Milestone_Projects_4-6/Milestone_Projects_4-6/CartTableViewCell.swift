//
//  ProductTableViewCell.swift
//  Milestone_Projects_4-6
//
//  Created by Айсен Еремеев on 29.11.2022.


import UIKit

class CartTableViewCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(stackView)
    contentView.addSubview(stackView2)
    contentView.addSubview(stackView3)
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
  
  lazy var increaseButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: "plus"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFill
    return button
  }()

  lazy var decreaseButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: "minus"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFill
    return button
  }()
  
  lazy var productQuantity: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textAlignment = .center
    label.text = "1"
    label.textColor = .black
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
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10)
    return stackView
  }()
  
  lazy var stackView3: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fillProportionally
    stackView.addArrangedSubview(increaseButton)
    stackView.addArrangedSubview(productQuantity)
    stackView.addArrangedSubview(decreaseButton)
//    stackView.backgroundColor = .yellow
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
      stackView.trailingAnchor.constraint(equalTo: stackView2.leadingAnchor, constant: 10),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
      
      stackView2.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10),
      stackView2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      stackView2.trailingAnchor.constraint(equalTo: stackView3.leadingAnchor),
      stackView2.topAnchor.constraint(equalTo: contentView.topAnchor),
      
      stackView3.leadingAnchor.constraint(equalTo: stackView2.trailingAnchor),
      stackView3.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      stackView3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stackView3.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView3.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
    ])
  }
}
