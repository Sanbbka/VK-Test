//
//  LoginViewController.swift
//  VK-Test
//
//  Created by Alexander Drovnyashin on 08.01.2018.
//  Copyright © 2018 alx. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let request = URLRequest(url: AuthVK, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        self.webView.loadRequest(request)
    }
}

extension LoginViewController: UIWebViewDelegate {
    
    private func getToken(path: String) -> String? {
        return path.stringBetweenString("access_token=", "&")
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        HUD.show(.progress)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.flash(.success)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.navigationController?.popViewController(animated: false)
        HUD.flash(.labeledError(title: error.localizedDescription, subtitle: nil))
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.absoluteString.contains("access_token=") == true {
            if let token = self.getToken(path: (request.url?.absoluteString)!) {
                AppUser.shared.setAppUser(token: token)
                self.didSignInUser()
            }
        }
        
        return true
    }
    
    func didSignInUser() {
        if AppAccess.userState == .logged {
            AppWireframe.shared.setRootViewController(for: nil, completion: nil)
        }
    }
}
