//
//  WebViewViewController.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController,WKNavigationDelegate {
  enum LinkType {
    case Payment
    case Other
  }
  private var path: String = ""
  private var processType: LinkType = .Other
  private var imageFirebasePath = ""
  let webView:WKWebView = {
    let prefs = WKWebpagePreferences()
    if #available(iOS 14.0, *) {
      prefs.allowsContentJavaScript = true
    }
    let configuration = WKWebViewConfiguration()
    configuration.defaultWebpagePreferences = prefs
    let webView = WKWebView(frame: .zero, configuration: configuration)
    return webView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(webView)
    guard let url = URL(string: path) else {
      return
    }
    webView.load(URLRequest(url: url))
    webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E188a Safari/601.1"

    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      self.webView.evaluateJavaScript("document.body.innerHTML") { result, error in
        guard let html = result as? String , error == nil else {
          return
        }
        print(html)
      }
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    webView.frame = view.bounds
  }

  private func setupView() {
    webView.navigationDelegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hiddenNavigation(isHidden: processType == .Payment )
    navigationController?.navigationBar.transparentNavigationBar()
  }


  func confige(title: String ,path: String,processType: LinkType , imageFirebasePath: String = "")  {
    setupView()
    self.path = path
    self.processType = processType
    self.imageFirebasePath = imageFirebasePath
    navigationController?.title = title
  }

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if let url = navigationAction.request.url {
      if url.absoluteString.contains("status=success") {
        let vc = self.initViewControllerWith(identifier: SuccessCheckoutViewController.className, and: "") as! SuccessCheckoutViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.confige(title: "Success".localiz(), description: "Your ad will be post soon.".localiz(), goString: "Go to My Ads".localiz()) {
            HomeViewController.goToMyAds = true
            vc.dismiss(animated: true, completion: nil)
            self.navigationController?.popToViewController(ofClass: BubbleTabBarController.self)
        }
        self.present(vc, animated: true, completion: nil)

        //success payment
      } else if url.absoluteString.lowercased().contains("status=fail") {
        if !imageFirebasePath.isEmpty {
          if imageFirebasePath.contains("firebasestorage") {
            UploadMedia.deleteMedia(dataArray: [imageFirebasePath]) {
              self.showToast(message: "Your Payment was failure , please try again".localiz())
              self.navigationController?.popViewController(animated: true)
            }
          }
        } else {
          self.showToast(message: "Your Payment was failure , please try again".localiz())
          self.navigationController?.popViewController(animated: true)
        }

        //fail payment
      }

    }
    decisionHandler(.allow)
  }
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    self.webView.updateLayoutForContent()
  }

}
extension WKWebView {

    func updateLayoutForContent() {
        var scriptContent = "var meta = document.createElement('meta');"
             scriptContent += "meta.name='viewport';"
             scriptContent += "meta.content='width=device-width';"
             scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"


        self.evaluateJavaScript(scriptContent,completionHandler: nil)
    }

}

