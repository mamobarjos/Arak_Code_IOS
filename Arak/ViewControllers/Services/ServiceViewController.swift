//
//  ServiceViewController.swift
//  Arak
//
//  Created by Abed Qassim on 13/06/2021.
//

import UIKit

class ServiceViewController: UIViewController {

  @IBOutlet weak var arakRankingLabel: UILabel!
  @IBOutlet weak var arakServiceLabel: UILabel!
    
  override func viewDidLoad() {
        super.viewDidLoad()

    arakServiceLabel.text = "Arak Service".localiz()
    arakRankingLabel.text = "Arak Ranking".localiz()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if HomeViewController.goToMyAds {
            HomeViewController.goToMyAds = false
            let vc = initViewControllerWith(identifier: MyAdsViewController.className, and: "My Ads".localiz()) as! MyAdsViewController
            show(vc)
        }
       
    }
  
  @IBAction func ArakRanking(_ sender: Any) {
    let arakRanking = initViewControllerWith(identifier: RankViewController.className, and: "Arak Ranking".localiz()) as! RankViewController
    show(arakRanking)
  }
  @IBAction func ArakService(_ sender: Any) {
    let arakService = initViewControllerWith(identifier: ArakServiceViewController.className, and: "Arak Service".localiz()) as! ArakServiceViewController
    show(arakService)
  }
    
    @IBAction func addAdsButtonAction(_ sender: Any) {
        let vc = initViewControllerWith(identifier: AdsViewController.className, and: "") as! AdsViewController
        show(vc)
    }
}
