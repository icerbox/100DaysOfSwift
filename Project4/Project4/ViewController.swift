//
//  ViewController.swift
//  Project4
//
//  Created by Айсен Еремеев on 21.11.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
  
  var webView: WKWebView!
  var progressView: UIProgressView!
  var websites = ["apple.com", "iltumen.ru", "hackingwithswift.com"]
  
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.sizeToFit()
    let progressButton = UIBarButtonItem(customView: progressView)
    
    toolbarItems = [progressButton, spacer, refresh]
    navigationController?.isToolbarHidden = false
    
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    
    let url = URL(string: "https://" + websites[0])!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
  }

  @objc func openTapped() {
    let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
    
    for website in websites {
      ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
    }
    
    
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(ac, animated: true)
  }
  
  func openPage(action: UIAlertAction) {
    guard let actionTitle = action.title else { return }
    guard let url = URL(string: "https://" + actionTitle) else { return }
    webView.load(URLRequest(url: url))
  }
  
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
    
    // 2. Мы используем if let для ракскрытия значения опшионала url.host. Это можно прочитать как, если в этом url есть хост, вытащи его. Под хостом имеется в виду домен вебсайта, вроде apple.com. Мы должны раскрыть его, так как не все url содержат
    if let host = url?.host {
      // 3. Мы проходимся по все сайтам в нашем массиве безопасных сайтов websites.
      for website in websites {
        // 4. Мы используем метод строки contains() чтобы проверить содержиться ли текущий хост в проверяемом вебсайте из массива websites
        if host.contains(website) {
          // 5. Если текущий хост содержит имя сайта из websites, то разрешаем загрузку
          decisionHandler(.allow)
          // 6. После этого производим выход из метода
          return
        } else if !host.contains(website) {
          print("текущий хост: \(host)")
          let ac = UIAlertController(title: "Warning!", message: "It's url blocked", preferredStyle: .alert)
          present(ac, animated: true)
          
          ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: {
            (action) in ac.dismiss(animated: true, completion: nil)
          }))
        }
      }
    }
    // 7. Если хост не установлен, то мы вызываем decisionHandler с отрицательным результатом и отменяем загрузку
    decisionHandler(.cancel)
  }
}

