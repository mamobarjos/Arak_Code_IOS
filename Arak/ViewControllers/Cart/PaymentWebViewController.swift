//
//  PaymentWebViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 31/08/2024.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate: AnyObject {
    func didFinishWithPayment(get url: String, status: PaymentWebViewController.PaymentStatus)
}

class PaymentWebViewController: UIViewController {
    
    enum PaymentStatus {
        case Success
        case Failed
    }
    
    @IBOutlet weak var webView: WKWebView!
    weak var delegate: WebViewControllerDelegate?
    public var url: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        navigationItem.leftBarButtonItem = closeButton
        self.title = "Arak Store".localiz()
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
        webView.uiDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.webView.evaluateJavaScript("document.body.innerHTML") { result, error in
                guard let html = result as? String, error == nil else {
                    return
                }
                print(html)
            }
        }
    }
    
    @objc func closeButtonTapped() {
          // Dismiss the view controller
          dismiss(animated: true, completion: nil)
      }
}
extension PaymentWebViewController: WKUIDelegate {

    func webViewDidClose(_ webView: WKWebView) {
        print("WebViewClosed")
    }
}

extension PaymentWebViewController: WKNavigationDelegate {



    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString {
            print(url)
       
            if url.hasPrefix("https://arak-be.solutionslap.com/payments/status?status=success") ||  url.hasPrefix("https://arak-be.solutionslap.com/payments/status?status=failed") ||  url.hasPrefix("https://arakads.live/payments/status?status=success") ||  url.hasPrefix("https://arakads.live/payments/status?status=failed") {
                if url.contains("success") {
                    delegate?.didFinishWithPayment(get: url, status: .Success)
                } else {
                    delegate?.didFinishWithPayment(get: url, status: .Failed)
                }
               
                dismiss(animated: true)
            }
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        if let url = webView.url?.absoluteString {
            print("url = \(url)")
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.dismiss(animated: true, completion: nil)
    }
}
