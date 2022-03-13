//
//  ProductViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 17/02/2022.
//

import UIKit
import WWLayout
//TODO: connect Fav Manager :)

class ProductViewController: UIViewController {
    let contentView = ProductContentView()
    lazy var scrollView = ScrollContainerView(contentView: contentView)
    let bottomView = BottomBarItemView()

    let visitStoreButtom = UIButton().then {
        $0.backgroundColor = UIColor.accentOrange.withAlphaComponent(0.80)
        $0.setTitle("Visit Store", for: .normal)
        $0.setTitleColor(.background, for: .normal)
        $0.setTitleColor(.accent, for: .highlighted)
        $0.layer.cornerRadius = 5
    }

    private var productViewModel = ProductViewModel()
    private var storeProduct: [Product] = []
    public var storeId: Int?
    public var storeName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)

        view.addSubview(bottomView)
        view.addSubview(visitStoreButtom)

        view.bringSubviewToFront(bottomView)
        view.bringSubviewToFront(visitStoreButtom)

        bottomView.layout
            .leading(to: .superview)
            .trailing(to: .superview)
            .bottom(to: .superview)

        visitStoreButtom.layout
            .leading(to: .superview, offset: 25)
            .trailing(to: .superview, offset: -25)
            .height(to: 55)
            .bottom(.equal, to: bottomView, edge: .top, offset: -9)


        scrollView.layout.fill(.superview)
        scrollView.scrollView.contentInset.bottom = -200

        contentView.delegate = self

        hiddenNavigation(isHidden: true)
        configration(productId: 1)
        connectAction()
        visitStoreButtom.addTarget(self, action: #selector(handleVisitStoreTap), for: .touchUpInside)
    }

    func configration(productId: Int) {
        self.showLoading()
        productViewModel.getProduct(productId: productId, complition: {[weak self] error in
            defer {
                self?.stopLoading()
            }

            if let error = error {
                self?.showToast(message: error)
            }


            self?.updateUI(product: self?.productViewModel.getStoreProduct() ?? [])
            self?.contentView.relatedProducts = self?.productViewModel.getRelatedProducts() ?? []
        })
    }

    @objc func handleVisitStoreTap() {

        let vc = initViewControllerWith(identifier: StoreViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! StoreViewController
        vc.storeId = storeId
        show(vc)
    }

    private func connectAction() {
        bottomView.webAction = {
            if let url = URL(string: "https://www.hackingwithswift.com") {
                UIApplication.shared.open(url)
            }
        }

        bottomView.phoneAction = { [weak self] in
            if let phoneCallURL = URL(string: "tel://") {

                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
              }
        }

        bottomView.locationAction = {

        }

        bottomView.whatsAppAction = { [weak self] in
            let urlWhats = "whatsapp://send?phone="
              if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                  if let whatsappURL = URL(string: urlString) {
                      if UIApplication.shared.canOpenURL(whatsappURL){
                          if #available(iOS 10.0, *) {
                              UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                          } else {
                              UIApplication.shared.openURL(whatsappURL)
                          }
                      }
                      else {
                          print("Install Whatsapp")
                      }
                  }
              }
        }
    }
}


extension ProductViewController {
    private func updateUI(product: [Product]) {
        contentView.storeProduct = product
    }
}

extension ProductViewController :ProductContentViewDelegate {
    func didTapOnViewAllproducts() {
        let vc = initViewControllerWith(identifier: StoreProductsViewController.className, and: "\(storeName ?? "All Products")", storyboardName: Storyboard.MainPhase.rawValue) as! StoreProductsViewController
        vc.storeId = storeId
        show(vc)
    }

    func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
    }

    func userDidTapFavIcon(id: String) {
        // will be implemated later
        self.showToast(message: "WIll be Implemented later 😎")
    }

    func userDidTapShare(id: String) {
        let text = "This is some text that I want to share."

               // set up activity view controller
               let textToShare = [ text ]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

               // exclude some activity types from the list (optional)
               activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

               // present the view controller
               self.present(activityViewController, animated: true, completion: nil)
    }
}
