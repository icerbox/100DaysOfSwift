//
//  EditViewController.swift
//  Milestone_Project_10-12
//
//  Created by Айсен Еремеев on 28.12.2022.
//

import UIKit

protocol EditViewControllerDelegate: AnyObject {
  func editViewControllerDidCancel(_ controller: EditViewController)
  func editViewController(_ controller: EditViewController, didFinishAdding item: Picture)
}

class EditViewController: UIViewController {
  
  weak var delegate: EditViewControllerDelegate?
  
  var editingImage: Picture?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
      view.backgroundColor = .white
    }
  
  @objc func cancel(_ sender: UIButton) {
    print("Функция cancel выполнена")
    delegate?.editViewControllerDidCancel(self)
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func done(_sender: UIButton) {
    print("Функция done выполнена, caption.text: \(caption.text!)")
    let item = Picture(fileName: editingImage!.fileName, caption: caption.text!)
    delegate?.editViewController(self, didFinishAdding: item)

    guard let viewControllers = self.navigationController?.viewControllers else { return }

    for viewController in viewControllers {
      if viewController is RootViewController {
        self.navigationController?.popToViewController(viewController, animated: true)
        break
      }
    }
  }
  
  lazy var image: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  lazy var fileName: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  lazy var caption: UITextField = {
    let label = UITextField()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  lazy var doneButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .gray
    button.setTitle("Сохранить изменения", for: .normal)
    button.addTarget(self, action: #selector(done), for: .touchUpInside)
    return button
  }()
  
  lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .gray
    button.setTitle("Отменить", for: .normal)
    button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    return button
  }()
  
  func setupViews() {
    view.addSubview(image)
    view.addSubview(caption)
    view.addSubview(doneButton)
    view.addSubview(cancelButton)
    NSLayoutConstraint.activate([
      image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
      image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
      image.widthAnchor.constraint(equalTo: view.widthAnchor),
      caption.topAnchor.constraint(equalTo: image.bottomAnchor),
      caption.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      caption.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      doneButton.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: 20),
      doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -200),
      doneButton.widthAnchor.constraint(equalToConstant: 200),
      doneButton.heightAnchor.constraint(equalToConstant: 60),
      cancelButton.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: 20),
      cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 200),
      cancelButton.widthAnchor.constraint(equalToConstant: 200),
      cancelButton.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let path = getDocumentsDirectory().appendingPathComponent(editingImage!.fileName)
        image.image = UIImage(contentsOfFile: path.path)
        caption.text = self.editingImage!.caption
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
