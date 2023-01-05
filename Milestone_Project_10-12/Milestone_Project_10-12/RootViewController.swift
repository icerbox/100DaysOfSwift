//
//  ViewController.swift
//  Milestone_Project_10-12
//
//  Created by Айсен Еремеев on 25.12.2022.
//

import UIKit



class RootViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditViewControllerDelegate, UIGestureRecognizerDelegate, myTableCellDelegate {
  
  func myTableCellDelegate() {
    print("tapped")
  }
  
      
  func editViewControllerDidCancel(_ controller: EditViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func editViewController(_ controller: EditViewController, didFinishAdding item: Picture) {
    if let i = pictures.firstIndex(where: { $0.fileName == item.fileName }) {
      pictures[i] = item
      navigationController?.popViewController(animated: true)
      save()
      tableView.reloadData()
    } else {
      let newRowIndex = pictures.count
      pictures.append(item)
      
      let indexPath = IndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)
      navigationController?.popViewController(animated: true)
      save()
      tableView.reloadData()
    }
  }
  
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
        for i in decodedPictures {
          print("Восстановили элемент \(i.fileName) \(i.caption)")
        }
        pictures = decodedPictures
        
      }
    }
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
    cell.delegate = self
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
    
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction] {
    let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
    let deleteAction = UITableViewRowAction(style: .destructive, title: deleteTitle) { (action, indexPath) in
      self.pictures.remove(at: indexPath.row)
      
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
      self.save()
    }
    
    let editTitle = NSLocalizedString("Edit", comment: "Edit action")
    let editAction = UITableViewRowAction(style: .normal, title: editTitle) { (action, indexPath) in
      let editViewController = EditViewController()
      editViewController.delegate = self
      editViewController.editingImage = self.pictures[indexPath.row]
      self.show(editViewController, sender: self)
    }
    editAction.backgroundColor = .green
    return [deleteAction, editAction]
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
    // Обязательно делаем целевой вьюконтроллер делегатом
    let editViewController = EditViewController()
    editViewController.delegate = self
    editViewController.editingImage = Picture(fileName: imageName, caption: "Unknown")
    show(editViewController, sender: self)
    dismiss(animated: true)
  }
  
  func save() {
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: pictures, requiringSecureCoding: false) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "pictures")
      for i in pictures {
        print("Сохранили элемент \(i.fileName) \(i.caption)")
      }
    }
  }
}


