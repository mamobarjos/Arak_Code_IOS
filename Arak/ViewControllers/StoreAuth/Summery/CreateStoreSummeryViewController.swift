//
//  SummeryViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 18/02/2022.
//

import UIKit
import Kingfisher

class CreateStoreSummeryViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    lazy var checkoutView = createBlureView()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        view.addSubview(checkoutView)
        checkoutView.layout
            .left(to: .superview)
            .trailing(to: .superview)
            .bottom(to: .superview)
            .height(to: 190)

        checkoutView.onAction = {[unowned self] in
            let vc = self.initViewControllerWith(identifier: CongretsStoreViewController.className, and: "", storyboardName: Storyboard.storeAuth.rawValue) as! CongretsStoreViewController
            self.show(vc)
        }
        // Do any additional setup after loading the view.
    }

    private func updateUI() {
        let store = Helper.store
        imageView.contentMode = .scaleToFill
        if let url = URL(string:store?.cover ?? "") {
//            imageView.kf.setImage(with: url, placeholder: )
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "Summery Image"))
        }

        companyNameLabel.text = store?.name
        descLabel.text = store?.desc
        websiteLabel.text = store?.website
        phoneLabel.text = store?.phoneNo
        locationLabel.text = "lon: \(store?.lon ?? "")" + " , " + "lat: \(store?.lat ?? "")"
    }

    private func createBlureView() -> CheckoutView {
        let checkoutView = CheckoutView()
        return checkoutView
    }
}
