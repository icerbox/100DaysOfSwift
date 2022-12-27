import UIKit

class ViewController: UICollectionViewController {
  
  var pictures = [String]().sorted()
  var clickedPictures = [Picture]()
//  let sortedArray = pictures.sorted()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Storm Viewer"
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
    performSelector(inBackground: #selector(fetchData), with: nil)
    
    
    
    let defaults = UserDefaults.standard
    
    if let savedPictures = defaults.object(forKey: "clickedPictures") as? Data {
      print("Начинаем загрузку данных")
      if let decodedPictures = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPictures) as? [Picture] {
        for i in clickedPictures {
          print("Загружаем элемент с именем: \(i.name), значением кликов: \(i.clicked)")
        }
        clickedPictures = decodedPictures
      }
    } else {
      print("Ошибка загрузки данных")
    }
//    destroyAllData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    for i in clickedPictures {
      print("Текущий элемент из массива clickedPictures с именем: \(i.name), значением кликов: \(i.clicked)")
    }
    DispatchQueue.main.async { [weak self] in
      self?.collectionView.reloadData()
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pictures.count
  }

  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
      fatalError("Unable to dequeue PictureCell")
    }
//    print("\(clickedPictures[indexPath.item]!.name)")
    cell.imageView.image = UIImage(named: clickedPictures[indexPath.item].name)
    cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
    cell.imageView.layer.borderWidth = 2
    cell.imageView.layer.cornerRadius = 3
    cell.layer.cornerRadius = 7
    
    cell.showLabel.text = "Кликнуто: \(clickedPictures[indexPath.item].clicked)"

    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    print("Текущий indexPath: \(indexPath.item)")
    self.collectionView.reloadItems(at: [indexPath])
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      let sortedArray = pictures.sorted()
      // Передаем в DetailViewController данные текущей кликнутой картинки
      vc.selectedImage = sortedArray[indexPath.item]
      clickedPictures[indexPath.item].clicked += 1
      save()
      vc.picturesArrayCount = sortedArray.count
      vc.currentArrayItemIndex = sortedArray.firstIndex(of: vc.selectedImage ?? "Нет значения")
      navigationController?.pushViewController(vc, animated: true)
    }
  }
//  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return pictures.count
//  }
//
//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
//    let sortedArray = pictures.sorted()
//    cell.textLabel?.text = sortedArray[indexPath.row]
//    return cell
//  }
//
//  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
//      print("Текущая картинка в массиве pictures: \(pictures[indexPath.row])")
//      let sortedArray = pictures.sorted()
//      vc.selectedImage = sortedArray[indexPath.row]
//      vc.picturesArrayCount = pictures.count
//      vc.currentArrayItemIndex = pictures.firstIndex(of: vc.selectedImage ?? "Нет значения")
//      navigationController?.pushViewController(vc, animated: true)
//    }
//  }
  
  @objc func fetchData() {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    
    for item in items.sorted() {
      if item.hasPrefix("nssl") {
        pictures.append(item)
        clickedPictures.append(Picture(name: "\(item)", clicked: 0))
        print("Добавляем в массив clickedPictures: Имя: \(item), clicked: 0")
      }
    }
    DispatchQueue.main.async { [weak self] in
      self?.collectionView.reloadData()
    }
  }
  
  func save() {
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: clickedPictures, requiringSecureCoding: false) {
      for i in clickedPictures {
        print("Сохраняем элемент с именем: \(i.name), значением кликов: \(i.clicked)")
      }
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "clickedPictures")
    }
  }
  
  func destroyAllData() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
      defaults.removeObject(forKey: key)
    }
  }
}

