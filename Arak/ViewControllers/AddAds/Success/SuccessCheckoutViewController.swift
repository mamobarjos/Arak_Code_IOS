//
//  SuccessCheckoutViewController.swift
//  Arak
//
//  Created by Abed Qassim on 01/03/2021.
//

import UIKit

class SuccessCheckoutViewController: UIViewController {
    
    typealias MyAdsBlock = () -> Void
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var goMyAdsLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    
    private var myAds: MyAdsBlock?
    
    private var titlePopUp: String = ""
    private var descriptionPopUp: String = ""
    private var goString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.29)
        setup()
    }
    
    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToMyAds))
        goMyAdsLabel.isUserInteractionEnabled = true
        goMyAdsLabel.addGestureRecognizer(tap)
        self.parentView.addShadow(position: .all)
        loclization()
    }
    
    @IBAction func MyAds(_ sender: Any) {
        goToMyAds()
    }
    
    func confige(title: String,description: String , goString: String,myAds: MyAdsBlock?) {
        self.myAds = myAds
        self.titlePopUp = title
        self.descriptionPopUp = description
        self.goString = goString
    }
    
    
    @objc func goToMyAds() {
        myAds?()
    }
    
    func loclization() {
        successLabel.text = titlePopUp
        messageLabel.text = descriptionPopUp
        goMyAdsLabel.text = goString
    }
    
}
