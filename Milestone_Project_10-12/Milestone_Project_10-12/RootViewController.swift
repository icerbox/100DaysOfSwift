//
//  ViewController.swift
//  Milestone_Project_10-12
//
//  Created by Айсен Еремеев on 25.12.2022.
//

import UIKit

class RootViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  var pictures = [Picture]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView(frame: .zero)
    tableView.register(PictureCell.self, forCellReuseIdentifier: "PictureCell")
    tableView.delegate = self
    tableView.dataSource = self
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
    
    let defaults = UserDefaults.standard
    
    if let savedPictures = defaults.object(forKey: "pictures") as? Data {
      if let decodedPictures = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPictures) as? [Picture] {
        pictures = decodedPictures
        
      }
    }
  }
  
  override func loadView() {
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as? PictureCell else {
      fatalError("Unable to dequeue PersonCell.")
    }
    let picture = pictures[indexPath.row]
    cell.caption.text = picture.caption

    let path = getDocumentsDirectory().appendingPathComponent(picture.fileName)
    
    cell.image.image = UIImage(contentsOfFile: path.path)
    cell.image.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
    cell.image.contentMode = .scaleAspectFit
    cell.layer.cornerRadius = 7
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailViewController = DetailViewController()
    detailViewController.selectedImage = pictures[indexPath.row]
    show(detailViewController, sender: self)
  }
    
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  @objc func addPhoto() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
    }
    present(picker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    
    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
    
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    
    let picture = Picture(fileName: imageName, caption: "Unknown")
    pictures.append(picture)
    save()
    tableView.reloadData()
    
    dismiss(animated: true)
  }
  
  func save() {
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: pictures, requiringSecureCoding: false) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "pictures")
    }
  }
}

