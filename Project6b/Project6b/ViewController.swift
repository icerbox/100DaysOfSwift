//
//  ViewController.swift
//  Project6b
//
//  Created by Айсен Еремеев on 27.11.2022.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let label1 = UILabel.makeLabel(text: "THESE", backgroundColor: .red)
    let label2 = UILabel.makeLabel(text: "ARE", backgroundColor: .cyan)
    let label3 = UILabel.makeLabel(text: "SOME", backgroundColor: .yellow)
    let label4 = UILabel.makeLabel(text: "AWESOME", backgroundColor: .green)
    let label5 = UILabel.makeLabel(text: "LABELS", backgroundColor: .orange)
    
    view.addSubview(label1)
    view.addSubview(label2)
    view.addSubview(label3)
    view.addSubview(label4)
    view.addSubview(label5)
    
//    let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
//
//    for label in viewsDictionary.keys {
//      view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//    }
//
//    let metrics = ["labelHeight": 88, "spacing"]
    let spacing: CGFloat = 10.0
//    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
    
    var previous: UILabel?
    
    for label in [label1, label2, label3, label4, label5] {
//      label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
      label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                                     label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      
      label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20, constant: -spacing).isActive = true
      
      if let previous = previous {
        label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
      } else {
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
      }
      previous = label
    }
  }
}

extension UILabel {
  static func makeLabel(text: String, backgroundColor: UIColor) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    label.sizeToFit()
    label.textAlignment = .center
    label.backgroundColor = backgroundColor
    return label
  }
}
