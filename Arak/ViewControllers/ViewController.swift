//
//  ViewController.swift
//  Arak
//
//  Created by Abed Qassim on 21/02/2021.
//

import UIKit
import AVKit
class ViewController: UIViewController {

  var player: AVPlayer?
    var notificationViewModel: NotificationViewModel = NotificationViewModel()
  override func viewDidLoad() {
      super.viewDidLoad()
      loadVideo()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hiddenNavigation(isHidden: true)
    notificationViewModel.getStaticLinks { _ in }
    if Helper.isLoggingUser() {
        notificationViewModel.getNotifications(page: 0) { _ in}
        notificationViewModel.updateToken { _ in }
    }
    navigationController?.navigationBar.transparentNavigationBar()
  }

    
  private func loadVideo() {
      do {
          try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
      } catch { }
      guard let path = Bundle.main.path(forResource: "splash", ofType:"mp4") else {return}
      NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
      player = AVPlayer(url: NSURL(fileURLWithPath: path) as URL)
      let playerLayer = AVPlayerLayer(player: player)
      playerLayer.frame = self.view.frame
      playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
      playerLayer.zPosition = -1
      self.view.layer.addSublayer(playerLayer)
      player?.seek(to: CMTime.zero)
      player?.play()

  }
  
  deinit {
      NotificationCenter.default.removeObserver(self)
  }

  @objc func playerDidFinishPlaying(note: NSNotification) {
    if Helper.isLoggingUser() {
      let tabBarViewController = self.initViewControllerWith(identifier: BubbleTabBarController.className, and: "") as! BubbleTabBarController
      tabBarViewController.modalPresentationStyle = .fullScreen
      let navigationRoot = UINavigationController(rootViewController: tabBarViewController)
      navigationRoot.modalPresentationStyle = .fullScreen
      self.present(navigationRoot)
    } else {
      let loginViewController = initViewControllerWith(identifier: LoginViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue)
      show(loginViewController)
    }

  }

}

