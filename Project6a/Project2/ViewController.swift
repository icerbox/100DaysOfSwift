//
//  ViewController.swift
//  Project2
//
//  Created by Андрей Антонен on 19.11.2022.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  
  var countries = [String]()
  var score = 0
  var correctAnswer = 0
  var questionsCount = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "us", "uk"]
    
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1
    
    button1.layer.borderColor = UIColor.lightGray.cgColor
    button1.layer.borderColor = UIColor.lightGray.cgColor
    button1.layer.borderColor = UIColor.lightGray.cgColor
    
    askQuestion()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
  }

  func askQuestion(action: UIAlertAction! = nil) {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
    
    title = countries[correctAnswer].uppercased()
    questionsCount += 1
    print("Количество вопросов: \(questionsCount)")
  }
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    var alertTitle: String
    
    if sender.tag == correctAnswer {
      alertTitle = "Correct"
      score += 1
      title! += ", счет игрока: \(score)"
    } else {
      alertTitle = "Wrong! That's the flag of \(countries[sender.tag])"
      score -= 1
      title! += ", счет игрока: \(score)"
    }
    
    if questionsCount < 10 {
      let ac = UIAlertController(title: alertTitle, message: "Ваши очки равны: \(score)", preferredStyle: .alert)
      
      ac.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: askQuestion))
      
      present(ac, animated: true)
    } else if questionsCount == 10 {
      let ac = UIAlertController(title: alertTitle, message: "Игра окончена! Вы набрали: \(score) очков", preferredStyle: .alert)
      score = 0
      ac.addAction(UIAlertAction(title: "Начать заново", style: .default, handler: askQuestion))
      
      present(ac, animated: true)
    }
      
    
  }
  
  @objc func shareTapped() {
    let vc = UIAlertController(title: "Your score", message: "Your score is \(score)", preferredStyle: .alert)
    vc.addAction(UIAlertAction(title: "Continue", style: .default, handler: {
      (actionsdf) in vc.dismiss(animated: true, completion: nil)
    }))
    present(vc, animated: true)
  }
  
}

