//
//  MainShopViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/02/2022.
//

import UIKit

class MainShopViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopSubTitleLabel: UILabel!
    @IBOutlet weak var descTitle: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    @IBOutlet weak var phoneStackView: UIStackView!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var whatsAppButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        ImageView.layer.cornerRadius = 10
        ImageView.backgroundColor = .red
        phoneStackView.setCustomSpacing(10, after: whatsAppButton)
        shopNameLabel.text = "Osama Store"
        scrollView.contentInset.bottom = 300
    }
    
    @IBAction func favButtonAction(_ sender: Any) {
    }

    @IBAction func locationButtonAction(_ sender: Any) {
    }
    @IBAction func callButtonAction(_ sender: Any) {
    }
    @IBAction func whatsAppButtonAction(_ sender: Any) {
    }
}
