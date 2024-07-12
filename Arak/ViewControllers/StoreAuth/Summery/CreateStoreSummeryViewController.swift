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
    private var viewModel = CreateStoreViewModel()

    public var mode: StoreMode = .add
    public var data: [String:Any]?

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
            guard let data = data else {
                return
            }
            print(data)
            self.showLoading()

            if mode == .add {
            viewModel.createStore(data: data, compliation: { [weak self] error in
                defer {
                    self?.stopLoading()
                }
                if error != nil {
                    self?.showToast(message: error)
                    return
                }
                let vc = self?.initViewControllerWith(identifier: CongretsStoreViewController.className, and: "", storyboardName: Storyboard.storeAuth.rawValue) as! CongretsStoreViewController
                self?.show(vc)
            })
            } else {
                viewModel.updateStore(id: Helper.store?.id ?? -1, data: data, compliation: { [weak self] error in
                    defer {
                        self?.stopLoading()
                    }
                    if error != nil {
                        self?.showToast(message: error)
                        return
                    }
                    self?.showToast(message: "Your Store Updated Successfully")
                    for controller in (self?.navigationController!.viewControllers ?? []) as Array {
                        if controller.isKind(of: StoreViewController.self) {
                            self?.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                })
            }
        }
    }

    private func updateUI() {
        guard let store = data else{
            return
        }

        imageView.contentMode = .scaleToFill
        if let url = URL(string:store["cover"] as? String ?? "") {
//            imageView.kf.setImage(with: url, placeholder: )
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "Summery Image"))
        }

        companyNameLabel.text = store["name"] as? String
        descLabel.text = store["desc"] as? String
        websiteLabel.text = store["website"] as? String
        phoneLabel.text = store["phone_no"] as? String
        locationLabel.text = "lon: \(store["lon"] as? String ?? "")" + " , " + "lat: \(store["lat"] as? String ?? "")"
    }

    private func createBlureView() -> CheckoutView {
        let checkoutView = CheckoutView()
        return checkoutView
    }
}
