//
//  UIViewController+Ex.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import UIKit
import NVActivityIndicatorView
import AwaitToast
extension UIViewController: NVActivityIndicatorViewable {
    enum Storyboard:String {
        case Main = "Main"
        case MainPhase = "Main_2"
        case Auth = "Auth"
    }
    
    public func dismissViewController(animated: Bool = true) {
        guard let navigationController = navigationController else {
            dismiss(animated: animated)
            return
        }
        
        guard navigationController.viewControllers.count > 1 else {
            return navigationController.dismiss(animated: animated)
        }
        
        navigationController.popViewController(animated: animated)
    }
    
    public func initViewControllerWith(identifier: String, and title: String, storyboardName: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        vc.title = title
        return vc
    }
    
    func hiddenNavigation(isHidden: Bool) {
        guard let navigationController = navigationController else {
            return
        }
        navigationController.navigationBar.isHidden = isHidden
        navigationController.setNavigationBarHidden(isHidden, animated: false)
    }
    
    func showalert(title:String , message:String , okTitleButton:String, cancelTitleButton:String,completion: (() -> Void)? = nil,cancelCompletion:(() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okTitleButton, style: .default, handler: { (okAlert) in
            guard let completion = completion else {
                alert.dismissViewController()
                return
            }
            completion()
            alert.dismissViewController()
        }))
        alert.addAction(UIAlertAction(title: cancelTitleButton, style: .cancel, handler: { (cancelAlert) in
            guard let cancelCompletion = cancelCompletion else {
                alert.dismissViewController()
                return
            }
            cancelCompletion()
            alert.dismissViewController()
        }))
        
        self.present(alert, animated: true)
    }
    
    func showLoading() {
        startAnimating(type: .ballBeat)
    }
    
    func stopLoading() {
        stopAnimating()
    }
    
    func showToast(message: String?, duration: TimeInterval = 3.0) {
        ToastAppearanceManager.default.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ToastAppearanceManager.default.numberOfLines = 0
        ToastAppearanceManager.default.height = AutomaticDimension
        ToastBehaviorManager.default.duration = duration
        ToastAppearanceManager.default.titleEdgeInsets = .init(top: 8, left: 20, bottom: 8, right: 20)
        ToastAppearanceManager.default.textColor = .white
        let toast = Toast.default(text: message ?? "", direction: .top)
        toast.show()
    }
    
    public func present<T: UIViewController>(
        _ viewController: T,
        animated: Bool = true,
        modalPresentationStyle: UIModalPresentationStyle? = nil,
        configure: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil
    ) {
        if let modalPresentationStyle = modalPresentationStyle {
            viewController.modalPresentationStyle = modalPresentationStyle
        }
        
        configure?(viewController)
        present(viewController, animated: animated) {
            completion?(viewController)
        }
    }
    //present viewController With Navigation
    //you can use it directly from viewController
    public func presentWithNavigation<T: UIViewController>(
        _ viewController: T,
        animated: Bool = true,
        configure: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil
    ) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        configure?(viewController)
        present(navigationController, animated: animated) {
            completion?(viewController)
        }
    }
    
    public func show<T: UIViewController>(
        _ viewController: T,
        animated: Bool = true,
        configure: ((T) -> Void)? = nil
    ) {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = ""
        navigationItem.backBarButtonItem = barButtonItem
        viewController.navigationItem.backBarButtonItem = barButtonItem
        
        viewController.hidesBottomBarWhenPushed = true
        viewController.modalPresentationStyle = modalPresentationStyle
        
        configure?(viewController)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    
    public func showLogin() {
        let vc = self.initViewControllerWith(identifier: LoginViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! LoginViewController
        self.presentWithNavigation(vc, animated: true, configure: nil, completion: nil)
    }
}

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.backgroundColor = .clear
    }
    
    func coloredNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = false
        self.backgroundColor = .white
    }
}

extension UIViewController {
    enum ItemPosition {
        case Left
        case Right
        case Both
    }
    
    func addBarItem(itemPostion: ItemPosition , icon: UIImage?,isNotification: Bool = false,tintColor: UIColor? = nil , isLogo: Bool = false , tag:Int, badgeCount: Int,leftCount: Int) {
        
        if itemPostion == .Right {
            var rightItems = self.navigationItem.rightBarButtonItems ?? []
            let rightItem = BadgedButtonItem(with: icon)
            rightItem.position = .right
            rightItem.badgeSize = .medium
            rightItem.badgeAnimation = true
            rightItem.tag = tag
            if tintColor != nil {
                rightItem.tintColor = tintColor
            }
            rightItem.tapAction = {
                self.rightTapped(itemBar: rightItem)
            }
            
            if isNotification {
                if badgeCount >= 0 {
                    rightItem.setBadge(with: Helper.notificationCount)
                }
            }
           
            rightItems.append(rightItem)
            self.navigationItem.rightBarButtonItems = rightItems
        }else if itemPostion == .Left {
            var leftItems = self.navigationItem.leftBarButtonItems ?? []
            let item = BadgedButtonItem(with: icon)
            item.position = .left
            item.badgeSize = .medium
            item.badgeAnimation = true
            item.tag = tag
            if tintColor != nil {
                item.tintColor = tintColor
            }
            item.tapAction = {
                self.leftTapped(itemBar: item)
            }
            if leftCount >= 0 {
                item.setBadge(with: "")
            }
            leftItems.append(item)
            self.navigationItem.leftBarButtonItems = leftItems
            
        } else if itemPostion == .Both {
            var leftItems = self.navigationItem.leftBarButtonItems ?? []
            let item = BadgedButtonItem(with: icon)
            item.position = .left
            item.badgeSize = .medium
            item.badgeAnimation = true
            item.tag = tag
            item.tapAction = {
                self.leftTapped(itemBar: item)
            }
            if leftCount >= 0 {
                item.setBadge(with: "")
            }
            leftItems.append(item)
            self.navigationItem.leftBarButtonItems = leftItems
            
            var rightItems = self.navigationItem.rightBarButtonItems ?? []
            let rightItem = BadgedButtonItem(with: icon)
            rightItem.position = .right
            rightItem.badgeSize = .medium
            rightItem.badgeAnimation = true
            
            rightItem.tag = tag
            rightItem.tapAction = {
                self.rightTapped(itemBar: rightItem)
            }
            if badgeCount > 0 {
                rightItem.setBadge(with: "")
            }
            rightItems.append(rightItem)
            self.navigationItem.rightBarButtonItems = rightItems
        }
        
    }
    
    func clearItemsBar(itemPostion: ItemPosition  = .Both) {
        if itemPostion == .Both {
            self.navigationItem.rightBarButtonItems = []
            self.navigationItem.leftBarButtonItems = []
        } else if itemPostion == .Right {
            self.navigationItem.rightBarButtonItems = []
        } else if itemPostion == .Left {
            self.navigationItem.leftBarButtonItems = []
        }
    }
    
    @objc func rightTapped(itemBar: UIBarButtonItem) {}
    @objc func leftTapped(itemBar: UIBarButtonItem) {}
}

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}

extension UINavigationController {
    func push(_ vc:UIViewController)  {
        self.pushViewController(vc, animated: true)
    }
    func clearBackground() {
        self.view.backgroundColor = .clear
        
    }
}
extension String {
    
    public var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
}
extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
