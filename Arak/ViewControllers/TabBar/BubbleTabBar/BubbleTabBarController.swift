//
//  BubbleTabBarController.swift
//  BubbleTabBar
//
//  Created by Anton Skopin on 28/11/2018.
//  Copyright © 2018 cuberto. All rights reserved.
//

import UIKit

open class BubbleTabBarController: UITabBarController {
    
    fileprivate var shouldSelectOnTabBar = true
    open override var selectedViewController: UIViewController? {
        willSet {
            guard shouldSelectOnTabBar,
                  let newValue = newValue else {
                shouldSelectOnTabBar = true
                return
            }
            
            guard let tabBar = tabBar as? BubbleTabBar, let index = viewControllers?.index(of: newValue) else {
                return
            }
            tabBar.select(itemAt: index, animated: false)
        }
    }
    
    open override var selectedIndex: Int {
        willSet {
            guard shouldSelectOnTabBar else {
                shouldSelectOnTabBar = true
                return
            }
            guard let tabBar = tabBar as? BubbleTabBar else {
                return
            }
            
            tabBar.select(itemAt: selectedIndex, animated: false)
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = BubbleTabBar()
        tabBar.setup {
            self.showToast(message: "Please login to continue ".localiz())
            self.showLogin()
        }
        self.setValue(tabBar, forKey: "tabBar")
        hiddenNavigation(isHidden: false)
        self.navigationController?.navigationBar.transparentNavigationBar()
    }
    
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private var _barHeight: CGFloat = 74
    open var barHeight: CGFloat {
        get {
            if #available(iOS 11.0, *) {
                return _barHeight + view.safeAreaInsets.bottom
            } else {
                return _barHeight
            }
        }
        set {
            _barHeight = newValue
            updateTabBarFrame()
        }
    }
    
    private func updateTabBarFrame() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = barHeight
        tabFrame.origin.y = self.view.frame.size.height - barHeight
        self.tabBar.frame = tabFrame
        tabBar.setNeedsLayout()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateTabBarFrame()
    }
    
    open override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        }
        updateTabBarFrame()
    }
    
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else {
            return
        }
        if let controller = viewControllers?[idx] {
            
            shouldSelectOnTabBar = false
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: controller)
        }
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        
    }
    
    private func setupUI() {
        clearItemsBar()
        addBarItem(itemPostion: .Right, icon: #imageLiteral(resourceName: "settings-1") , isLogo: true,tag: 1, badgeCount: 0, leftCount: 0)
        addBarItem(itemPostion: .Right, icon: #imageLiteral(resourceName: "Icon ionic-md-notifications") ,isNotification:  true, isLogo: true ,tag: 2, badgeCount: 4, leftCount: 0)
        addBarItem(itemPostion: .Left, icon: #imageLiteral(resourceName: "Arak Logo"), isLogo: true,tag: 3, badgeCount: 0, leftCount: 0)
    }
    
    override func rightTapped(itemBar: UIBarButtonItem) {
        if Helper.userType == Helper.UserType.GUEST.rawValue  {
            showLogin()
            Helper.resetLoggingData()
            return
        }
        if itemBar.tag == 1 {
            let vc = initViewControllerWith(identifier: SettingsViewController.className, and: "") as! SettingsViewController
            show(vc)
        } else if itemBar.tag == 2 {
            let vc = initViewControllerWith(identifier: NotificationViewController.className, and: "") as! NotificationViewController
            show(vc)
        }
    }
    
    override func leftTapped(itemBar: UIBarButtonItem) {
        if itemBar.tag == 3 {
            let vc = initViewControllerWith(identifier: ArakServiceViewController.className, and: "") as! ArakServiceViewController
            show(vc)
        }
    }
}
