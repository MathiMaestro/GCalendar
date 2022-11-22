//
//  WebVC.swift
//  calendar
//
//  Created by Mathiyalagan S on 22/11/22.
//

import UIKit
import WebKit

protocol WebViewToCalendarViewProtocol: AnyObject {
    func viewDismissed()
}

class WebVC: UIViewController, WKUIDelegate {
    
    var webUrl : URL
    var webView: WKWebView!
    weak var delegate: WebViewToCalendarViewProtocol?

    init(url: URL, delegate: WebViewToCalendarViewProtocol? = nil) {
        self.webUrl     = url
        self.delegate   = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        loadWebView()
    }
    
    private func configureNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    private func loadWebView() {
        self.webView.load(URLRequest(url: self.webUrl))
    }
    
    @objc func dismissView() {
        dismiss(animated: true) {
            self.delegate?.viewDismissed()
        }
    }
    
    deinit {
        print("WebVC deinitialised")
    }
    
}
