//
//  ViewController.swift
//  Milestone_Projects_7-9
//
//  Created by Айсен Еремеев on 06.12.2022.
//

import UIKit
 
class ViewController: UIViewController, UITextFieldDelegate {
  
  var currentAnswer = [String]()
  var word = [String]()
  var usedLetters = [String]()
  var score = 0 {
    didSet {
      scoreLabel.text = "Ваши очки: \(score)"
      if score > -7 {
        imageView.image = UIImage(named: "\(abs(score)).png")
      } else if score == -7 {
        imageView.image = UIImage(named: "\(abs(score)).png")
        let ac = UIAlertController(title: "ВЫ ПРОИГРАЛИ", message: "Попробовать еще?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
          self.startNewRound()
        }))
        present(ac, animated: true)
    } else {
        imageView.image = UIImage(named: "0.png")
      }
    }
  }
  
  private lazy var imageView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private lazy var backgroundImage: UIImageView = {
    let image = UIImageView(frame: .zero)
    image.image = UIImage(named: "background")
    image.contentMode = .scaleToFill
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private lazy var scoreLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 18)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.text = "Ваши очки: 0"
    return label
  }()
  
  private lazy var questionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 20)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  private let clue: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textAlignment = .center
    textField.font = UIFont.systemFont(ofSize: 22)
    return textField
  }()
  
  private let answer: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Введите ответ"
    textField.textAlignment = .center
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    textField.font = UIFont.systemFont(ofSize: 20)
    textField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    textField.addTarget(self, action: #selector(checkAnswer), for: .editingChanged)
    return textField
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    startNewRound()
    answer.delegate = self
  }
  
  private func startNewRound() {
    if let fileWithData = Bundle.main.url(forResource: "questions", withExtension: "txt") {
      if let dataContents = try? String(contentsOf: fileWithData) {
        var questions = dataContents.components(separatedBy: "\n")
        questions.shuffle()
        let parts = questions[0].components(separatedBy: ": ")
        questionLabel.text = parts[1]
        score = 0
        answer.text = ""
        word = [String]()
        currentAnswer = [String]()
        currentAnswer.append(parts[0])
        // Выводим знаки вопросов в зависимости от длины текущего ответа
        for _ in 0...currentAnswer[0].count - 1 {
          word.append("?")
        }
        clue.text! = word.joined(separator: "")
      }
    }
  }
  
    @objc func checkAnswer() {
      guard let userEnteredLetter = answer.text, !userEnteredLetter.isEmpty else { return }
      let usedLetters = Array(currentAnswer[0].uppercased()).enumerated()
      var isFound: Bool = false
      if score == -7 {
        
      }
      for (index, letter) in usedLetters {
        let characterToString = String(letter)
          if characterToString.contains(userEnteredLetter) {
            word[index] = characterToString
            isFound = true
            clue.text! = word.joined(separator: "")
            answer.text = ""
          }
      }
      if !isFound {
        if !isFound {
          let ac = UIAlertController(title: nil, message: "Нет такой буквы!", preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.score -= 1
            self.answer.text = ""
          }))
          present(ac, animated: true)
        }
        isFound = true
      }
      if word.joined(separator: "") == currentAnswer[0].uppercased() {
        let ac = UIAlertController(title: nil, message: "Вы угадали слово \(currentAnswer[0].uppercased())! Продолжаем играть?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Да, продолжить", style: .default, handler: { _ in
          self.startNewRound()
        }))
          present(ac, animated: true)
      }
    }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let maxLength = 1
    let currentString = (textField.text ?? "") as NSString
    let newString = currentString.replacingCharacters(in: range, with: string)
    return newString.count <= maxLength
  }
  
  private func setupViews() {
    view.addSubview(scoreLabel)
    view.addSubview(questionLabel)
    view.addSubview(answer)
    view.addSubview(clue)
    view.addSubview(imageView)
    view.insertSubview(backgroundImage, at: 0)
  }
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
      scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
      
      imageView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
      imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
      imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 10),
      
      questionLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
      questionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
      questionLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
      
      clue.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
      clue.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
      clue.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 10),
      answer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      answer.topAnchor.constraint(equalTo: clue.bottomAnchor, constant: 20),
  
      backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
