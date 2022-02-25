//
//  StoreViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit

class StoreViewController: UIViewController {
    let contentView = StoreContentView()
    lazy var scrollView = ScrollContainerView(contentView: contentView)
    let bottomView = BottomBarItemView()

    private var storeViewModel: StoreViewModel = StoreViewModel()

    var storeId: Int?
    private var storeDetails: SingleStore?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        view.addSubview(bottomView)
        bottomView.layout
            .leading(to: .superview)
            .trailing(to: .superview)
            .bottom(to: .superview)

        view.bringSubviewToFront(bottomView)

        scrollView.layout.fill(.superview)
        scrollView.scrollView.contentInset.bottom = 130

        hiddenNavigation(isHidden: true)

        contentView.delegate = self
        configration(storeId: storeId ?? 1)
        connectAction()
    }

    func configration(storeId: Int) {
        self.showLoading()
        storeViewModel.getStore(stroeId: storeId, complition: {[weak self] error in
            defer {
                self?.stopLoading()
            }

            if let error = error {
                self?.showToast(message: error)
            }

            self?.contentView.storeDetails = self?.storeViewModel.getStoreDetails()

            self?.storeDetails = self?.storeViewModel.getStoreDetails()!
            self?.contentView.products = self?.storeViewModel.getStoreProduct() ?? []
        })
    }

   private func connectAction() {
        bottomView.webAction = {
            if let url = URL(string: "https://www.hackingwithswift.com") {
                UIApplication.shared.open(url)
            }
        }

        bottomView.phoneAction = { [weak self] in
            if let phoneCallURL = URL(string: "tel://\(self?.storeDetails?.phoneNo ?? "")") {

                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
              }
        }

        bottomView.locationAction = {

        }

        bottomView.whatsAppAction = { [weak self] in
            let urlWhats = "whatsapp://send?phone=\(self?.storeDetails?.phoneNo ?? "")"
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

extension StoreViewController: StoreContentViewProtocol {
    func didTapOnAddProduct() {
        self.showToast(message: "WIll be Implemented later 😎")
    }

    func didTapViewAllProduct() {
        self.showToast(message: "WIll be Implemented later 😎")
    }

    func didTapOnFav(id: Int) {
        self.showToast(message: "WIll be Implemented later 😎")
    }

    func didTapOnEdit(id: Int) {
        self.showToast(message: "WIll be Implemented later 😎")
    }

    func didTapOnBack() {
        self.navigationController?.popViewController(animated: true)
    }

    func didTapOnProduct(id: Int) {
        let vc = initViewControllerWith(identifier: ProductViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! ProductViewController
        show(vc)
    }
}
