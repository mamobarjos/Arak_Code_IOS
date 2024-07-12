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

    guard let detailView = Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)?.first as? DetailView else {
      navigationController?.popViewController(animated: true)
      return
    }

      detailView.configeUI(ads: ads, viewMode: .view, viewController: nil) { (action) in
      switch action {
        case .call(let phone):
          Helper.CellPhone(phone)
          break
        case .location(let lat , let lng):
          if let latDouble = Double(lat) , let lngDouble = Double(lng) {
            Helper.OpenMap(latDouble, lngDouble)
          }
          break
        case .website(let url):
          let vc = self.initViewControllerWith(identifier: WebViewViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! WebViewViewController
          vc.confige(title: "", path: url, processType: .Other)
          self.show(vc)
          break
        case .empty:
          break
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
        case .viewFullScreen:
          break
      case .whatsapp(_):
        break
      case .favorite(id: let id):
        break
      
      case .backToHome:
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
