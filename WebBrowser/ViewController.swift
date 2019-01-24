//
//  ViewController.swift
//  WebBrowser
//
//  Created by Pablo on 12/01/2019.
//  Copyright © 2019 Pablo. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    @IBOutlet var webView: WKWebView!
    @IBOutlet var url: UITextField!
    @IBOutlet var refresh: UIButton!
    let urlHomePage = "https://www.etsisi.upm.es"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.url.text = urlHomePage
        let url = URL(string: urlHomePage)!
        self.hideKeyboardWhenTappedAround()
        self.url.delegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        animateLoad()
    }

    @IBAction func loadUrl(_ sender: Any) {
        let url = URL(string: self.url.text!)!
        let request = URLRequest(url: url)
        webView.load(request)
        animateLoad()
    }
    
    @IBAction func selectUrl(_ sender: Any) {
        self.url.becomeFirstResponder()
        self.url.selectAll(nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
            self.url.text = webView.url?.absoluteString
            animateLoad()
        }
    }
    
    @IBAction func goForward(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
            self.url.text = webView.url?.absoluteString
            animateLoad()
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.url.text = webView.url?.absoluteString
        webView.reload()
        animateLoad()
    }

    @IBAction func goHomePage(_ sender: Any) {
        webView.load(URLRequest(url: URL(string: urlHomePage)!))
        self.url.text = urlHomePage
        animateLoad()
    }
    
    func animateLoad() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat], animations: {
            self.refresh.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        })
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat], animations: {
            self.refresh.transform = CGAffineTransform(rotationAngle: 2*CGFloat.pi)
        })
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        var url = (segue.source as! TableViewController).selected
        if url == "" {
            url = (segue.source as! TableViewController).currentWeb
        }
        webView.load(URLRequest(url: URL(string: url)!))
        self.url.text = url
        animateLoad()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        refresh.layer.removeAllAnimations()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! TableViewController
        dest.currentWeb = (webView.url?.absoluteString)!
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
