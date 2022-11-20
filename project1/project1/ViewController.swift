import UIKit

class ViewController: UITableViewController {
  
  var pictures = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Storm Viewer"
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    
    for item in items {
      if item.hasPrefix("nssl") {
        pictures.append(item)
      }
    }
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
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
      vc.selectedImage = pictures[indexPath.row]
      vc.picturesArrayCount = pictures.count
      vc.currentArrayItemIndex = pictures.firstIndex(of: vc.selectedImage ?? "Нет значения")
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @objc func shareTapped() {
    let aboutProgram = "Это приложение для просмотра изображений шторма"
    let vc = UIActivityViewController(activityItems: [aboutProgram], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
}

