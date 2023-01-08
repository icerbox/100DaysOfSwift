//
//  ViewController.swift
//  Project8
//
//  Created by Айсен Еремеев on 03.12.2022.
//

import UIKit

class ViewController: UIViewController {

//MARK: - Переменные и константы
  var cluesLabel = UILabel.makeLabel(labelText: "ӨЙДӨТӨН БИЭРИИ", fontSize: 24, textAlignment: .left, numberOfLines: 0, setHuggingPriority: 1)
  var answersLabel = UILabel.makeLabel(labelText: "ЭППИЭТ", fontSize: 24, textAlignment: .right, numberOfLines: 0, setHuggingPriority: 1)
  var scoreLabel = UILabel.makeLabel(labelText: "ЭҺИГИ ОЧКУОҔУТ: 0", fontSize: 22, textAlignment: .right, numberOfLines: 1, setHuggingPriority: 999)
  var letterButtons = [UIButton]()
  var activatedButtons = [UIButton]()
  var solutions = [String]()
  var score = 0 {
    didSet {
      scoreLabel.text = "ОЧКУОҔУТ: \(score)"
    }
  }
  var scoreNeededForLevelUp = 0
  var level = 1
  
  private let currentAnswer: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "ТААЙАРГА АЛЛАРАА БААР ТЫЛЛАРЫ БАТТАА"
    textField.textAlignment = .center
    textField.font = UIFont.systemFont(ofSize: 36)
    textField.isUserInteractionEnabled = false
    return textField
  }()
  
  private let submit: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("БИГЭРГЭТ", for: .normal)
    button.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    return button
  }()
  
  private let clear: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("ЫРАСТАА", for: .normal)
    button.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    return button
  }()
  
  private let buttonsView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.lightGray.cgColor
    return view
  }()
//MARK: - Жизненный цикл
  
  override func loadView() {
    setupViews()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    performSelector(inBackground: #selector(loadLevel), with: nil)
    setupConstraints()
  }
//MARK: - Методы
  
  @objc func letterTapped(_ sender: UIButton) {
    guard let buttonTitle = sender.titleLabel?.text else { return }
    
    currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
    activatedButtons.append(sender)
//    sender.isHidden = true
    UIButton.animate(withDuration: 1, delay: 0, options: []) {
      sender.alpha = 0
    }
  }
  
  @objc func submitTapped(_ sender: UIButton) {
    guard let answerText = currentAnswer.text else { return }
    print("answerText is: \(answerText)")
    print("solutions is: \(solutions)")
    if let solutionPosition = solutions.firstIndex(of: answerText) {
      print("solutionPosition is: \(solutionPosition)")
      activatedButtons.removeAll()
      
      var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
      splitAnswers?[solutionPosition] = answerText
      answersLabel.text = splitAnswers?.joined(separator: "\n")
      currentAnswer.text = ""
      score += 1
      scoreNeededForLevelUp += 1
      if scoreNeededForLevelUp % 7 == 0 {
        let ac = UIAlertController(title: "ОҺУОБАЙ!", message: "Аныгыскы таһымҥа таҕыстыбыт?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Бардыбыт!", style: .default, handler: levelUp))
        present(ac, animated: true)
      }
    } else if !currentAnswer.text!.isEmpty {
      let ac = UIAlertController(title: nil, message: "Таайбатыгыт!", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "СӨП", style: .cancel))
      if score != 0 {
        score -= 1
      }
      clearTapped(self)
      present(ac, animated: true)
    }
  }
  
  func levelUp(action: UIAlertAction) {
    level += 1
    
    solutions.removeAll(keepingCapacity: true)
    loadLevel()
    
    for button in letterButtons {
      UIButton.animate(withDuration: 1, delay: 0, options: []) {
        button.alpha = 1
      }
    }
  }
  
  @objc func clearTapped(_ sender: Any) {
    currentAnswer.text = ""
    
    for button in activatedButtons {
      UIButton.animate(withDuration: 1, delay: 0, options: []) {
        button.alpha = 1
      }
    }
  }
  
  @objc func loadLevel() {
    var clueString = ""
    var solutionString = ""
    var letterBits = [String]()
    
    if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
      if let levelContents = try? String(contentsOf: levelFileURL) {
        var lines = levelContents.components(separatedBy: "\n")
//        print("lines\(lines)")
        lines.shuffle()
        
        for (index, line) in lines.enumerated() {
//          print("До использования components \(line)")
          let parts = line.components(separatedBy: ": ")
//          print("После использования components: \(parts)")
          let answer = parts[0]
          guard parts.count == 2 else { continue }
          let clue = parts[1]
          
          clueString += "\(index + 1). \(clue)\n"
          
          let solutionWord = answer.replacingOccurrences(of: "|", with: "")
          solutionString += "\(solutionWord.count) буукуба\n"
          solutions.append(solutionWord)
          
          let bits = answer.components(separatedBy: "|")
          letterBits += bits
        }
      }
    }
    DispatchQueue.main.async { [weak self] in
      self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
//      print("clueLabel.text: \(self?.cluesLabel.text)")
      self?.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
      
      self?.letterButtons.shuffle()
      
      if self?.letterButtons.count == letterBits.count {
        for i in 0..<self!.letterButtons.count {
          self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
        }
      }
    }
  }
  
  private func setupViews() {
    view = UIView()
    view.backgroundColor = .white
    view.addSubview(scoreLabel)
    view.addSubview(cluesLabel)
    view.addSubview(answersLabel)
    view.addSubview(currentAnswer)
    view.addSubview(submit)
    view.addSubview(clear)
    view.addSubview(buttonsView)
    
    let width = Int((UIScreen.main.bounds.width - 200) / 5 )
    let height = 80

    for row in 0..<4 {
      for column in 0..<5 {
        let letterButton = UIButton(type: .system)
        letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 34)
        letterButton.setTitle("WWW", for: .normal)
        letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

        let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
        letterButton.frame = frame
        buttonsView.addSubview(letterButton)
        letterButtons.append(letterButton)
      }
    }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      
      cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
      cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.9, constant: -100),
      
      answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
      answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
      answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
      
      currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
      currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
      
      submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
      submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
      submit.heightAnchor.constraint(equalToConstant: 44),
      
      clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
      clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
      clear.heightAnchor.constraint(equalToConstant: 44 ),
      
      buttonsView.heightAnchor.constraint(equalToConstant: 320),
      buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
      buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
      buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
      buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
      
    ])
  }
}

//MARK: - Расширения

extension UILabel {
  static func makeLabel(labelText: String, fontSize: CGFloat, textAlignment: NSTextAlignment, numberOfLines: Int, setHuggingPriority: Float) -> UILabel{
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: fontSize)
    label.text = labelText
    label.textAlignment = textAlignment
    label.numberOfLines = numberOfLines
    label.setContentHuggingPriority(UILayoutPriority(setHuggingPriority), for: .vertical)
    return label
  }
}
