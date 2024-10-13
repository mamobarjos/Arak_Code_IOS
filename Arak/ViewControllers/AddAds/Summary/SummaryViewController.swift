//
//  SummaryViewController.swift
//  Arak
//
//  Created by Abed Qassim on 28/02/2021.
//

import UIKit
import AVKit
class SummaryViewController: UIViewController {


  private var ads: Adverisment?
  private var viewModel: CheckoutViewModel = CheckoutViewModel()

  override func viewDidLoad() {
        super.viewDidLoad()
    setup()
  }

  private func setup() {
    loadDetailView()
    localzation()
  }

  private func localzation() {
    title = "Summary".localiz()

  }

  private func loadDetailView() {

    guard let detailView = Bundle.main.loadNibNamed("SummaryDetailView", owner: self, options: nil)?.first as? SummaryDetailView else {
      navigationController?.popViewController(animated: true)
      return
    }

      detailView.configeUI(ads: ads, viewMode: .view, viewController: nil) { (action) in
      switch action {
        case .checkout:
            let vc = self.initViewControllerWith(identifier: CheckoutViewController.className, and: "",storyboardName: Storyboard.Main.rawValue) as! CheckoutViewController
            vc.confige(ads: self.ads)
            self.show(vc)
         
          break
        case .playVideo(let path):
          if let videoURL = URL(string: path ?? "") {
            let player = AVPlayer(url: videoURL)
            try? AVAudioSession.sharedInstance().setCategory(.playback, options: [])
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
          }
          break
      default:
          break
      }
    }

    self.view.addSubview(detailView)
    detailView.bounds = self.view.frame

    detailView.center = self.view.center
  }

  func confige(ads: Adverisment?) {
    self.ads = ads
  }
    
    
}
