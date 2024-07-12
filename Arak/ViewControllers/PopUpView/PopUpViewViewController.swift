//
//  PopUpViewViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 06/07/2024.
//

import UIKit

class PopUpViewViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var bannerTitle: String?
    var bannerDesc: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = bannerTitle
        descLabel.text = bannerDesc

    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
