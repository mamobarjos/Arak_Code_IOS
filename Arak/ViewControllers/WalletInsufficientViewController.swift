//
//  WalletInsufficientViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 15/07/2021.
//

import UIKit

class WalletInsufficientViewController: UIViewController {
    typealias ConfirmBlock = (Bool) -> Void

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    private var confirmBlock: ConfirmBlock?
    private var serviceViewModel = ServiceViewModel()
    private var error = ""
    
    private var titleDialog:String = ""
    private var descriptionDialog:String = ""
    private var buttonDialog:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.29)
        //addGesture()
        localization()
    }

    
    private func localization() {
        titleLabel.text = titleDialog
        descriptionLabel.text = descriptionDialog
        sendButton.setTitle(buttonDialog, for: .normal)
        titleLabel.textAligment()
        descriptionLabel.textAligment()
    }
    @IBAction func Send(_ sender: Any) {
        self.confirmBlock?(true)
    }
    
    @IBAction func Close(_ sender: Any) {
        self.confirmBlock?(false)
    }
    func confige(confirmBlock: ConfirmBlock?,title:String = "Wallet Insufficient".localiz() , description:String = "You do not have enough balance in your wallet, you can proceed with your credit card".localiz() , buttonTitle:String = "Send".localiz()) {
        self.confirmBlock = confirmBlock
        self.titleDialog = title
        self.descriptionDialog = description
        self.buttonDialog = buttonTitle
    }
    

    
}
