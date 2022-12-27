//
//  ViewController.swift
//  Project5
//
//  Created by Айсен Еремеев on 24.11.2022.
//

import UIKit

class ViewController: UITableViewController {
  
  var allWords = [String]()
  var usedWords = [Word]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let defaults = UserDefaults.standard
    if let savedData = defaults.object(forKey: "usedWords") as? Data {
      if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Word] {
        usedWords = decodedData
      }
    }
    title = usedWords[0].currentWord
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startGame))
    
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
      if let startWords = try? String(contentsOf: startWordsURL) {
        allWords = startWords.components(separatedBy: "\n")
      }
    }
    
    if allWords.isEmpty {
      allWords = ["silkworm"]
    }
  }
  
  @objc func startGame() {
    // Устанавливаем в титле рандомное слово из базы слов
    title = allWords.randomElement()
    // Удаляем все сохраненные в userDefaults данные
    deleteSavedData()
    // Очищаем массив с использованными вопросами
    usedWords.removeAll()
    // перезагружаем таблицу
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    let currentElement = usedWords[indexPath.row]
    cell.textLabel?.text = currentElement.usedWordsArray
    return cell
  }
  
  @objc func promptForAnswer() {
    let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
    ac.addTextField()
    
    let submitAction = UIAlertAction(title: "Submit", style: .default) {
      [weak self, weak ac] _ in
      guard let answer = ac?.textFields?[0].text else { return }

      self?.submit(answer)
    }
    ac.addAction(submitAction)
    present(ac, animated: true)
  }
  
  func submit(_ answer: String) {
    let lowerAnswer = answer
    if isPossible(word: lowerAnswer) {
      if isOriginal(word: lowerAnswer) {
        if isReal(word: lowerAnswer) {
          usedWords.append(Word(currentWord: title ?? "", usedWordsArray: lowerAnswer))
          
          let indexPath = IndexPath(row: 0, section: 0)
          tableView.insertRows(at: [indexPath], with: .automatic)
          save()
          return
        } else {
          showErrorMessage(errorTitle: "Word not recognized", errorMessage: "You can't just make them up, you know!")
        }
      } else {
        showErrorMessage(errorTitle: "Word already used", errorMessage: "Be more original!")
      }
    } else {
      showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title!.lowercased()).")
    }
  }
  
  func isPossible(word: String) -> Bool {
    guard var tempWord = title?.lowercased() else { return false }
    
    for letter in word {
      if let position = tempWord.firstIndex(of: letter) {
        tempWord.remove(at: position)
      } else {
        return false
      }
    }
    return true
  }
  
  func isOriginal(word: String) -> Bool {
    for i in usedWords {
      print("Попали внутрь цикла. Текущий элемент массива \(i.usedWordsArray)")
      if i.usedWordsArray.contains(word) {
        return false
      }
    }
    return true
  }
  
  func isReal(word: String) -> Bool {
    if word.count < 3 {
      showErrorMessage(errorTitle: "Запрещено", errorMessage: "Введенное слово меньше 3 символов")
      return false
    }
    if word == title {
      showErrorMessage(errorTitle: "Запрещено", errorMessage: "Слово повторяет стартовое слово")
      return false
    }
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    return misspelledRange.location == NSNotFound
  }
  
  func showErrorMessage(errorTitle: String, errorMessage: String) {
    let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  func save() {
    print("Начинаем сохранение данных")
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: usedWords, requiringSecureCoding: false) {
      print("savedData: \(savedData)")
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "usedWords")
    }
  }
  
  func deleteSavedData() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
      defaults.removeObject(forKey: key)
    }
  }
}
