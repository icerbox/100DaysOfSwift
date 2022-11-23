//
//  ViewController.swift
//  Project4
//
//  Created by Айсен Еремеев on 21.11.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
  
  // Создаем свойство webView для вызова WKWebView
  var webView: WKWebView!
  // Создаем свойство progressView для вызова UIProgressView
  var progressView: UIProgressView!
  // Создаем массив websites для хранения разрешенных сайтов
  var websites = ["apple.com", "iltumen.ru", "hackingwithswift.com"]
  
  
  override func loadView() {
    // Создаем новый экземпляр WKWEbView и назначаем его свойству webView
    webView = WKWebView()
    // назначаем делегата себя
    webView.navigationDelegate = self
    // Назначаем корневому вью вьюконтроллера созданный webview
    view = webView
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Добавляем кнопку в правый верхний угол навигейшн контроллера
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    // Добавляем заполнитель .flexibleSpace чтобы отвести кнопки вправо
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
    let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.sizeToFit()
    let progressButton = UIBarButtonItem(customView: progressView)
    
    toolbarItems = [progressButton, spacer, back, forward, refresh]
    navigationController?.isToolbarHidden = false
    
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    
    // Создаем константу url, которому создаем адрес URL из строки которая получена из первого элемента массива websites
    let url = URL(string: "https://" + websites[0])!
    // Формируем запрос URL из константы url и загружаем его в наш webview
    webView.load(URLRequest(url: url))
    //
    webView.allowsBackForwardNavigationGestures = true
  }
  
  // Метод который запускается при нажатии на правую верхнюю кнопку "Open"
  @objc func openTapped() {
    // объявляем экземпляр UIALertController
    let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
    
    // Выводим все сайты из массива websites
    for website in websites {
      ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
    }
    
    // Добавляем кнопку
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(ac, animated: true)
  }
  
  func openPage(action: UIAlertAction) {
    guard let actionTitle = action.title else { return }
    guard let url = URL(string: "https://" + actionTitle) else { return }
    webView.load(URLRequest(url: url))
  }
  //
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
      progressView.progress = Float(webView.estimatedProgress)
    }
  }
  
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    // 1. Присваиваем константе url значение URL из навигации
    let url = navigationAction.request.url
    
    guard navigationAction.navigationType == .other || navigationAction.navigationType == .reload else {
      decisionHandler(.cancel)
      let ac = UIAlertController(title: "Заблокировано", message: "Адрес не найден в списке безопасных", preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "Закрыть окно", style: .cancel, handler: nil))
            present(ac, animated: true)
      return
    }
    // 2. Мы используем if let для ракскрытия значения опшионала url.host. Это можно прочитать как, если в этом url есть хост, вытащи его. Под хостом имеется в виду домен вебсайта, вроде apple.com. Мы должны раскрыть его, так как не все url содержат
    if let host = url?.host {
          // 3. Проходимся по все сайтам в нашем массиве безопасных сайтов websites.
          for website in websites {
          // 4. Используем метод строки contains() чтобы проверить содержиться ли текущий хост в проверяемом вебсайте из массива websites
            if host.contains(website) {
              // 5. Если текущий хост содержит имя сайта из websites, то разрешаем загрузку
              decisionHandler(.allow)
              // 6. После этого производим выход из метода
              return
            }
          }
        }
      // 7. Если хост не установлен, то мы вызываем decisionHandler с отрицательным результатом и отменяем загрузку
      decisionHandler(.cancel)
  }
}

