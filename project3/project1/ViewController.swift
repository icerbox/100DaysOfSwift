import UIKit

class ViewController: UITableViewController {
  
  var pictures = [String]().sorted()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Storm Viewer"
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
    performSelector(inBackground: #selector(fetchData), with: nil)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    let sortedArray = pictures.sorted()
    cell.textLabel?.text = sortedArray[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      print("Текущая картинка в массиве pictures: \(pictures[indexPath.row])")
      let sortedArray = pictures.sorted()
      vc.selectedImage = sortedArray[indexPath.row]
      vc.picturesArrayCount = pictures.count
      vc.currentArrayItemIndex = pictures.firstIndex(of: vc.selectedImage ?? "Нет значения")
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
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
      self?.tableView.reloadData()
    }
  }
}

