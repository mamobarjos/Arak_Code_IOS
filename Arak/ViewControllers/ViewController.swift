//
//  ViewController.swift
//  Arak
//
//  Created by Abed Qassim on 21/02/2021.
//

import UIKit
import AVKit
import Lottie

class ViewController: UIViewController {

    var player: AVPlayer?
    var notificationViewModel: NotificationViewModel = NotificationViewModel()
    
//    @IBOutlet weak var arakLabel: UILabel!
//    @IBOutlet weak var view1: UIView!
//    @IBOutlet weak var view2: UIView!
//    @IBOutlet weak var view3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if Helper.isLoggingUser() {
                Network.shared.request(request: APIRouter.getUserInfo, decodable: User.self) {[weak self] (response, error) in
                    
                    Helper.userType = Helper.UserType.NORMAL.rawValue
                    Helper.country = response?.data?.country
              
                
                let tabBarViewController = self?.initViewControllerWith(identifier: BubbleTabBarController.className, and: "") as! BubbleTabBarController
                tabBarViewController.modalPresentationStyle = .fullScreen
                let navigationRoot = UINavigationController(rootViewController: tabBarViewController)
                navigationRoot.modalPresentationStyle = .fullScreen
                self?.present(navigationRoot)
                }
            } else {
                let loginViewController = self.initViewControllerWith(identifier: LoginViewController.className, and: "", storyboardName: Storyboard.Auth.rawValue)
                self.show(loginViewController)
            }
        })
      
//        // loadVideo()
//        self.view2.center = .init(x: view.frame.height / 2, y: view.frame.width)
//        view1.center = .init(x: view.frame.height / 2, y: 0)
//        view3.center = .init(x: view.frame.height, y: 0)
//        arakLabel.alpha = 0
//        self.view.bringSubviewToFront(self.arakLabel)
//        animateViews()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        hiddenNavigation(isHidden: true)
//        notificationViewModel.getStaticLinks { _ in }
//        if Helper.isLoggingUser() {
//            notificationViewModel.getNotifications(page: 0) { _ in}
//            notificationViewModel.updateToken { _ in }
//        }
//        navigationController?.navigationBar.transparentNavigationBar()
//    }
  
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
      
    }

//    func animateViews() {
//        // Define the spacing between the views
//        let verticalSpacing: CGFloat = 20.0
//        
//        // Get the target x position to align them horizontally
//        let targetXPosition = self.view.center.x
//
//        // Set the y positions for the views to align them vertically around view2
//        let targetYPosition2 = self.view.center.y
//        let targetYPosition3 = targetYPosition2 - view2.frame.height - verticalSpacing
//        let targetYPosition1 = targetYPosition2 + view2.frame.height + verticalSpacing
//
//        // Animate view2 to the target position
//        UIView.animate(withDuration: 3, animations: {
//            self.view2.center = self.view.center
//        })
//        
//        
//        UIView.animate(withDuration: 3) {
//            self.view1.center = self.view.center
//        } completion: { sucess in
//            if sucess {
//                if Helper.isLoggingUser() {
//                    let tabBarViewController = self.initViewControllerWith(identifier: BubbleTabBarController.className, and: "") as! BubbleTabBarController
//                    tabBarViewController.modalPresentationStyle = .fullScreen
//                    let navigationRoot = UINavigationController(rootViewController: tabBarViewController)
//                    navigationRoot.modalPresentationStyle = .fullScreen
//                    self.present(navigationRoot)
//                } else {
//                    let loginViewController = self.initViewControllerWith(identifier: LoginViewController.className, and: "", storyboardName: Storyboard.Auth.rawValue)
//                    self.show(loginViewController)
//                }
//            }
//        }
//
//        
//        UIView.animate(withDuration: 3, animations: {
//            self.view3.center = .init(x: self.view.frame.height / 2, y: self.view.frame.width / 2)
//        })
//        
//        UIView.animate(withDuration: 2, animations: {
//            self.arakLabel.alpha = 1
//            self.view.bringSubviewToFront(self.arakLabel)
//        })
//        
//      
////        { _ in
////            // After view2 animation completes, animate view3 above view2
////            UIView.animate(withDuration: 1.0, animations: {
////                self.view3.center = CGPoint(x: targetXPosition, y: targetYPosition3)
////            }) { _ in
////                // After view3 animation completes, animate view1 below view2
////                UIView.animate(withDuration: 1.0, animations: {
////                    self.view1.center = CGPoint(x: targetXPosition, y: targetYPosition1)
////                }) { _ in
////                    // Animation completion handler
////                }
////            }
////        }
//    }
}
