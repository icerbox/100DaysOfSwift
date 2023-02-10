//
//  ActionViewController.swift
//  Extension
//
//  Created by Айсен Еремеев on 31.01.2023.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var pageHead = ""
    var scriptsArray = [Script]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scriptsArray.append(Script(currentPage: pageURL, title: "Посмотреть текущее время", script: "const date = new Date();\n alert(date);"))
//        scriptsArray.append(Script(currentPage: pageURL, title: "Посмотреть локацию", script: "alert(document.location)"))
//        scriptsArray.append(Script(currentPage: pageURL, title: "Посмотреть заголовок страницы", script: "alert(document.title)"))
//
        let defaults = UserDefaults.standard
//        print("Значение title в userDefaults: \(defaults.valueExists(forKey: "title"))")
        print("Значение title в userDefaults: \(defaults.dictionaryRepresentation().values)")
        if let savedData = defaults.object(forKey: "scriptsArray") as? Data {
            if let decodedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Script] {
                scriptsArray = decodedData
            }
        }
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let showScriptsButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showScripts))
        let addScriptsButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScripts))
        
        navigationItem.leftBarButtonItems = [showScriptsButton, addScriptsButton]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print("javaScriptValues \(javaScriptValues)")
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    self?.pageHead = javaScriptValues["head"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    @IBAction func addScripts() {
        var titleField = UITextField()
        var scriptField = UITextField()
        
        let alert = UIAlertController(title: "Добавить новый скрипт", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField1 in
            alertTextField1.placeholder = "Добавьте заголовок скрипта"
            titleField = alertTextField1
        }
        alert.addTextField { alertTextField2 in
            alertTextField2.placeholder = "Добавьте текст скрипта"
            scriptField = alertTextField2
        }
//        print("titleField до guard: \(titleField.text!), scriptField до guard: \(scriptField.text!)")
//        guard let titleText = titleField.text, let scriptText = scriptField.text else { return }
//        print("titleField после guard: \(titleText), scriptField после guard: \(scriptText)")
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            guard let titleText = titleField.text, !titleText.isEmpty, let scriptText = scriptField.text, !scriptText.isEmpty else { return }
            self.scriptsArray.append(Script(currentPage: self.pageURL, title: "\(titleText)", script: "\(scriptText)"))
            print("Добавлен элемент: currentPage: \(self.pageURL), title: \(titleText), script: \(scriptText)")
            self.save()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": textView.text as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    func runJS(script: String) {
        print("runJS activated")
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @IBAction func showScripts() {
        let alert = UIAlertController(title: "Список доступных скриптов:", message: "Выберите скрипт", preferredStyle: .alert)
        
        
        for i in scriptsArray {
            print("title: \(i.title), script: \(i.script)")
            alert.addAction(UIAlertAction(title: i.title, style: .default) {_ in
                let script = i.script
                self.runJS(script: script)
            })
        }

//        alert.addAction(UIAlertAction(title: "Посмотреть локацию", style: .default) {_ in
//            let script = "alert(document.location)"
//            self.runJS(script: script)
//        })
//        alert.addAction(UIAlertAction(title: "Посмотреть заголовок страницы", style: .default) {_ in
//            let script = "alert(document.title)"
//            self.runJS(script: script)
//        })
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardScreenEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    func save() {
        print("Начинаем сохранение данных")
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: scriptsArray, requiringSecureCoding: false) {
            for i in savedData {
                print("Текущий сохраняемый элемент: \(i)")
            }
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "scriptsArray")
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

extension UserDefaults {
    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
