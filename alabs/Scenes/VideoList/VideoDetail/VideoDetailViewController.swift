//
//  VideoDetailViewController.swift
//  alabs
//
//  Created by ryan on 19.03.2022.
//

import UIKit
import  WebKit

class VideoDetailViewController: UIInputViewController, WKUIDelegate {
    var websiteURL: String?
    var webView: WKWebView!

    override func loadView() {
        webViewSettings()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUrl()
    }

    func webViewSettings() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    func loadUrl() {
        let myURL = URL(string: websiteURL ?? "https://google.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}


