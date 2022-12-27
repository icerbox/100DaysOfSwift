import UIKit

class ViewController: UICollectionViewController {
  
  var pictures = [String]().sorted()
  var shows = [Int]()
  var clickedPictures = [Picture?]()
//  let sortedArray = pictures.sorted()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Storm Viewer"
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
    performSelector(inBackground: #selector(fetchData), with: nil)
    
//    let defaults = UserDefaults.standard
//
//    if let savedPictures = defaults.object(forKey: "picturesShow") as? Data {
//      if let decodedPictures = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPictures) as? [Picture] {
//        clickedPictures = decodedPictures
//      }
//    }
    destroyAllData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("view did appear")
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
    print("indexPath в cellForItem: \(indexPath.item)")
    let sortedArray = pictures.sorted()
    cell.imageView.image = UIImage(named: sortedArray[indexPath.item])
    cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
    cell.imageView.layer.borderWidth = 2
    cell.imageView.layer.cornerRadius = 3
    cell.layer.cornerRadius = 7
    
    if clickedPictures.isEmpty {
      cell.showLabel.text = "Кликнуто: 0"
    } else {
//      print("Массив кликнутых картинок: \(clickedPictures)")
      for i in clickedPictures {
        print("Начинаем цикл проверки кликнутой картинки, если оно было ранее кликнуто добавляем +1, если нет ничего не делаем")
        print("Проверяем индекс кликнутой картинки, имя картинки: \(i!.name), имя ячейки: \(sortedArray[indexPath.item]), индекс: \(i!.index) и текущий индекс плитки: \(indexPath.item)")
        if i!.name == sortedArray[indexPath.item] {
          print("Соответствие найдено: Имя кликнутой картинки: \(i!.name), индекс: \(i!.index) а текущий индекс плитки: \(sortedArray[indexPath.item])")
          print("Меняем значение лейбла картинки \(i!.name) на \(i!.clicked)")
          cell.showLabel.text = "Кликнуто: \(String(describing: i!.clicked))"
        }
        print("Соответствие не найдено, лейбл не меняем")
      }
    }
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Текущий indexPath: \(indexPath.item)")
    self.collectionView.reloadItems(at: [indexPath])
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      //--------------------
      // Сортируем основной массив картинок
      let sortedArray = pictures.sorted()
      print("indexPath.item в didSelectItem: \(indexPath.item) ")
      // Передаем в DetailViewController данные текущей кликнутой картинки
      vc.selectedImage = sortedArray[indexPath.item]
      // Если массив кликнутых картинок пустой, то добавляем в массив без проверки на соответствие индексу
      if clickedPictures.isEmpty {
        clickedPictures.append(Picture(name: sortedArray[indexPath.item], index: indexPath.item, clicked: 0))
        collectionView.reloadData()
        print("Массив пустой, сразу добавляем элемент name: \(sortedArray[indexPath.item]), index: \(indexPath.item), clicked: 1)")
      } else {
        print("Массив не пустой, начинаем проверку индексов")
        var isFound: Bool = false
        for i in clickedPictures {
          print("Начинаем проверку кликнутой картинки на текущий индекс. Если индекс кликнутой картинки совпадает с индексом текущей ячейки то добавляем в поле clicked + 1")
          if i!.name == sortedArray[indexPath.item] {
            print("Нашлось совпадение. Текущий индекс: \(i!.index) и индекс текущей ячейки: \(indexPath.item), текущее имя: \(i!.name), и имя текущей ячейки: \(sortedArray[indexPath.item])")
            i!.clicked += 1
            isFound.toggle()
            collectionView.reloadData()
          }
//          else {
//            clickedPictures.append(Picture(name: sortedArray[indexPath.item], index: indexPath.item, clicked: 1))
//            print("Добавили элемент \(i?.index), \(i?.name), \(i?.clicked)")
//          }
//          print("Данные кликнутой ячейки: \(i?.index), \(i?.name), \(i?.clicked)")
        }
        
        if !isFound {
            print("кликнутый элемент не найден, ничего не делаем: \(sortedArray[indexPath.item]), индексом: \(indexPath.item)")
//          clickedPictures.append(Picture(name: sortedArray[indexPath.item], index: indexPath.item, clicked: 1))
        }
      }
      for element in clickedPictures {
        print("Массив кликнутых картинок: индекс: \(element!.index), имя: \(element!.name), кликов: \(element!.clicked)")
      }
//      save()
  //----------------------------
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
    
    for item in items {
      if item.hasPrefix("nssl") {
        pictures.append(item)
      }
    }
    DispatchQueue.main.async { [weak self] in
      self?.collectionView.reloadData()
    }
  }
  
  func save() {
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: clickedPictures, requiringSecureCoding: false) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "picturesShow")
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

