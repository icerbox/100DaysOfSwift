//
//  DetailViewController.swift
//  Milestone_Project_13-15
//
//  Created by Айсен Еремеев on 09.01.2023.
//

import UIKit

class DetailViewController: UIViewController {
  
  var selectedCountry: Country?
  
  
  lazy var name: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  lazy var code: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  lazy var capital: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  lazy var currency: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  lazy var flag: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFit
    image.backgroundColor = .yellow
    return image
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    view.backgroundColor = .white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
    navigationItem.largeTitleDisplayMode = .never
   
    guard let country = selectedCountry else { return }
    name.text = "Country name: " + country.name
    code.text = "Country code: " + country.code
    capital.text = "Capital of the country: " + country.capital
    currency.text = "Currency code: " + country.currency.code + " name: " + country.currency.name
    loadImage(stringUrl: country.flag) {
      print("Добавлено изображение: \(String(describing: $0))")
      self.flag.image = $0
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }
  
  func setupViews() {
    view.addSubview(name)
    view.addSubview(code)
    view.addSubview(capital)
    view.addSubview(currency)
    view.addSubview(flag)
    NSLayoutConstraint.activate([
      flag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      flag.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      flag.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
      flag.widthAnchor.constraint(equalTo: view.widthAnchor),
      name.topAnchor.constraint(equalTo: flag.bottomAnchor),
      name.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      name.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      name.heightAnchor.constraint(equalToConstant: 40),
      code.topAnchor.constraint(equalTo: name.bottomAnchor),
      code.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      code.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      code.heightAnchor.constraint(equalToConstant: 40),
      capital.topAnchor.constraint(equalTo: code.bottomAnchor),
      capital.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      capital.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      capital.heightAnchor.constraint(equalToConstant: 40),
      currency.topAnchor.constraint(equalTo: capital.bottomAnchor),
      currency.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      currency.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      currency.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
  
  func loadImage(stringUrl: String, completion : @escaping ((UIImage?) -> Void)) {
    // Если url не nil то:
    guard let url = URL(string: stringUrl) else { return }
    print("url: \(url)")
    // Сохраняем ссылку в переменную request
    let request = URLRequest(url: url)
    // присваиваем значению токен с хидером Authorization
//    request.setValue("Oauth \(token)", forHTTPHeaderField: "Authorization")
    // Создаем таск
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      // Если полученные данные не nil, то:
      guard let data = data else { return }
      DispatchQueue.main.async {
        completion(UIImage(data: data))
      }
    }
    task.resume()
  }

}
