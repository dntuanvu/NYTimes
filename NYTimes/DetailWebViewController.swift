//
//  DetailWebViewController.swift
//  NYTimes
//
//  Created by Home on 27/9/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class DetailWebViewController : UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerIndicator: UIActivityIndicatorView!
    
    var webUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.stopSpinner()
        
        if let link = self.webUrl {
            let url = URL (string: link)
            let requestObj = URLRequest(url: url!)
            self.webView.loadRequest(requestObj)
        }
    }
    
    func spinner() {
        self.spinnerView.isHidden = false
        self.spinnerView.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: {
            self.spinnerView.alpha = 0.5
        })
        
        self.spinnerIndicator.startAnimating()
        self.spinnerIndicator.isHidden = false
    }
    
    func stopSpinner() {
        self.spinnerView.isHidden = true
        self.spinnerIndicator.stopAnimating()
        self.spinnerIndicator.isHidden = true
    }
    
    // MARK: UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.spinner()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.stopSpinner()
    }
}
