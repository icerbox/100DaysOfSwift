import UIKit

protocol AddProductViewControllerDelegate: AnyObject {
  func addProductViewControllerDidCancel(_ controller: AddProductViewController)
  func addProductViewControler(_ controller: AddProductViewController, didFinishAdding item: String)
}

class AddProductViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  weak var delegate: AddProductViewControllerDelegate?
    
  @IBOutlet var titleTextfield: UITextField!
  @IBOutlet var priceTextField: UITextField!
  @IBOutlet var addImageButton: UIButton!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var addProductButton: UIButton!
  @IBOutlet var cancelButton: UIButton!
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Добавить продукт"
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowAddProductViewController" {
      if let rootViewController = segue.destination as? RootViewController {
        rootViewController.products.append(Product(title: titleTextfield.text!, price: priceTextField.text!, image: imageView.image!))
        print("В performSegue передается изображение \(String(describing: imageView.image)) ")
      }
    }
  }
  
  @IBAction func addProduct(_ sender: UIButton) {
    print("Нажата кнопка добавить")
    if let vc = storyboard?.instantiateViewController(withIdentifier: "RootView") as? RootViewController {
      if let text = titleTextfield.text, let price = priceTextField.text {
        print("В массив добавлен продукт \(text), со стоимостью \(price), массив продуктов:  \(vc.products) \(String(describing: imageView.image))")
        self.performSegue(withIdentifier: "ShowAddProductViewController", sender: nil)
      }
    }
  }
  
  @IBAction func addProductImage(_ sender: Any) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .photoLibrary
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      imageView?.image = image
      picker.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func cancelAddingProduct(_ sender: UIButton) {
    print("Нажата кнопка отменить")
    delegate?.addProductViewControllerDidCancel(self)
    self.navigationController?.popViewController(animated: true)
  }
  
  
}

