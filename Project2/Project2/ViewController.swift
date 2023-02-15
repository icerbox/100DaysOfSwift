//
//  ViewController.swift
//  Project2
//
//  Created by Айсен Еремеев on 19.11.2022.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  
  var countries = [String]()
  var max: Int = 0
  var score: Int = 0
  
  var correctAnswer = 0
  var questionsCount = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    scheduleNotification()
    countries += ["Эстония", "Франция", "Германия", "Ирландия", "Италия", "Монако", "Нигерия", "Польша", "Россия", "Испания", "США", "Англия"]
    
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1
    
    button1.layer.borderColor = UIColor.lightGray.cgColor
    button1.layer.borderColor = UIColor.lightGray.cgColor
    button1.layer.borderColor = UIColor.lightGray.cgColor
    
    askQuestion()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    
    let defaults = UserDefaults.standard

    if let savedScore = defaults.object(forKey: "max") as? Data {
      if let decodedScore = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedScore) as? Int {
        max = decodedScore
      }
    }
  }

  func askQuestion(action: UIAlertAction! = nil) {
    print("Текущий рекорд: \(max) очков")
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
    
    title = countries[correctAnswer].uppercased()
    questionsCount += 1
    print("Количество вопросов: \(questionsCount)")
  }
  
  func newRound(action: UIAlertAction! = nil) {
    print("Текущий рекорд: \(max) очков")
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
    
    questionsCount = 1
    score = 0
    title = countries[correctAnswer].uppercased()
    print("Количество вопросов: \(questionsCount)")
  }
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    var alertTitle: String
    
    UIButton.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
      sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }, completion: {_ in
      sender.transform = .identity
    })
    
    if sender.tag == correctAnswer {
      alertTitle = "Правильно"
      score += 1
      title! += ", счет игрока: \(score)"
    } else {
      alertTitle = "Неправильно! Это флаг \(countries[sender.tag])"
      score -= 1
      title! += ", счет игрока: \(score)"
    }
    
    if questionsCount < 10 {
      let ac = UIAlertController(title: alertTitle, message: "Ваши очки равны: \(score)", preferredStyle: .alert)
      
      ac.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: askQuestion))
      
      present(ac, animated: true)
    }
    
    if questionsCount == 10 {
      if score > max {
        let ac = UIAlertController(title: "Поздравляем! Вы установили новый рекорд! \(score) очков", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Начать заново", style: .default, handler: newRound))
        max = score
        save()
        present(ac, animated: true)
      } else {
        let ac = UIAlertController(title: alertTitle, message: "Игра окончена! Вы набрали: \(score) очков", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Начать заново", style: .default, handler: newRound))
        present(ac, animated: true)
      }
    }
  }
  
  @objc func shareTapped() {
    let vc = UIAlertController(title: nil, message: "Ваши очки: \(score)", preferredStyle: .alert)
    vc.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: {
      (actionsdf) in vc.dismiss(animated: true, completion: nil)
    }))
    present(vc, animated: true)
  }
  
  func save() {
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: score, requiringSecureCoding: false) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "max")
    }
  }
  
    @objc func askForPermissions() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permissions received")
            } else {
                print("Permissions denied")
            }
        }
    }
    
    @objc func scheduleNotification() {
        askForPermissions()
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Hey Dude!"
        content.body = "It's time to play!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        
        dateComponents.hour = 17
        dateComponents.minute = 20
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Let's play", options: .foreground)
        
        let close = UNNotificationAction(identifier: "close", title: "No, i don't want to play", options: .destructive)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, close], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    
    
    
    
    
    
    
}
