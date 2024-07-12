//
//  ArakServiceDetailsPopUpViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 09/07/2024.
//

import UIKit


class ArakServiceDetailsPopUpViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    var onButtonAction: (() -> Void)?
    var serviceDesc: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.setTitle("action.Continue".localiz(), for: .normal)
        titleLabel.text = "Service Details".localiz()
        descLabel.text = serviceDesc

    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        onButtonAction?()
    }
}
