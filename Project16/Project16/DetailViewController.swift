//
//  DetailViewController.swift
//  Project16
//
//  Created by Айсен Еремеев on 10.01.2023.
//
import WebKit
import UIKit

class DetailViewController: UIViewController, WKNavigationDelegate {
  var webView: WKWebView!
  var currentUrl: String?
      
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    webView.backgroundColor = .yellow
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    guard let currentUrl = currentUrl else { return }
    if let encodedUrl = currentUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedUrl) {
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
  }
}
}
