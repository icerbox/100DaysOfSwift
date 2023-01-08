//
//  ViewController.swift
//  Project13
//
//  Created by Айсен Еремеев on 06.01.2023.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var intensity: UISlider!
  @IBOutlet weak var radius: UISlider!
  @IBOutlet weak var containerView: UIView!
  
  
  @IBOutlet weak var changeButton: UIButton!
  
  var currentImage: UIImage!
  var context: CIContext!
  var currentFilter: CIFilter!

  override func viewDidLoad() {
    super.viewDidLoad()
    containerView.backgroundColor = UIColor(white: 0, alpha: 0)
    
    title = "InstaFilter"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
      UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
        print("Делаем не прозрачным")
        self.view.updateConstraintsIfNeeded()
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        self.imageView.alpha = 1.0
      })
  }
  
  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    
    
    currentImage = image
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    
    applyProcessing()
  }

  @IBAction func changeFilter(_ sender: UIButton) {
    let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    if let popoverController = ac.popoverPresentationController {
      popoverController.sourceView = sender
      popoverController.sourceRect = sender.bounds
    }
    present(ac, animated: true)
    
  }
  
  func setFilter(action: UIAlertAction) {
    guard currentImage != nil else { return }
    guard let actionTitle = action.title else { return }
    
    currentFilter = CIFilter(name: actionTitle)
    
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    changeButton.setTitle(actionTitle, for: .normal)
    applyProcessing()
  }
  @IBAction func save(_ sender: Any) {
    guard let image = imageView.image else { let ac = UIAlertController(title: "В imageView нет картинки!", message: nil, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "ОК", style: .cancel))
      present(ac, animated: true)
      return
    }
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
  }
  
  @IBAction func intensityChanged(_ sender: Any) {
    applyProcessing()
  }
  
  @IBAction func radiusChanged(_ sender: Any) {
    applyRadius()
  }
  
  
  func applyProcessing() {
    
    let inputKeys = currentFilter.inputKeys
    
    if inputKeys.contains(kCIInputIntensityKey) {
      currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
    }
    
    if inputKeys.contains(kCIInputRadiusKey) {
      currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
    }
    
    if inputKeys.contains(kCIInputScaleKey) {
      currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
    }
    
    if inputKeys.contains(kCIInputCenterKey) {
      currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
    }
    
    guard let outputImage = currentFilter.outputImage else { return }
    if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
      
      print("Выводим изображение")
      let processedImage = UIImage(cgImage: cgImage)
      imageView.image = processedImage
      print("Выводим анимацию")
      imageView.alpha = 0
//      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//        UIView.animate(withDuration: 10.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
//          print("Делаем не прозрачным")
//          self.view.updateConstraintsIfNeeded()
//          self.view.layoutSubviews()
//          self.view.layoutIfNeeded()
//          self.imageView.alpha = 1.0
//        })
//      }
    }
  }
  
  func applyRadius() {
    
    let inputKeys = currentFilter.inputKeys
        
    if inputKeys.contains(kCIInputRadiusKey) {
      currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
    }
    
    guard let outputImage = currentFilter.outputImage else { return }
    if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
      let processedImage = UIImage(cgImage: cgImage)
      imageView.image = processedImage
      
    }
  }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
    } else {
      let ac = UIAlertController(title: "Saved", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
  }
}

