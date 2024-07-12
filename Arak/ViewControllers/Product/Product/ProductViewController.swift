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

    private var productViewModel = ProductViewModel()
    private var storeProduct: [Product] = []
    public var storeId: Int?
    public var storeName: String?
    public var productId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        view.addSubview(bottomView)

        view.bringSubviewToFront(bottomView)

        bottomView.layout
            .leading(to: .superview)
            .trailing(to: .superview)
            .bottom(to: .superview)

        scrollView.layout.fill(.superview)
        scrollView.scrollView.contentInset.bottom = 150

        contentView.delegate = self

        hiddenNavigation(isHidden: true)
        configration(productId: productId ?? 0)
        connectAction()
//        visitStoreButtom.addTarget(self, action: #selector(handleVisitStoreTap), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: true)
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


            self?.updateUI(product: self?.productViewModel.getStoreProduct())
            self?.contentView.relatedProducts = self?.productViewModel.getRelatedProducts() ?? []
            self?.contentView.reviews = self?.productViewModel.getStoreProduct()?.storeProduct?.reviews.map({.init(content: $0.content, rate: $0.rate, id: $0.id, createdAt: $0.createdAt, userid: $0.userid, updatedAt: $0.updatedAt, storeid: $0.storeProductid, user: nil)}) ?? []
        })
    }

//    @objc func handleVisitStoreTap() {
//
//        let vc = initViewControllerWith(identifier: StoreViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! StoreViewController
//        vc.storeId = storeId
//        show(vc)
//    }

    private func connectAction() {
        bottomView.webAction = { [weak self] in
            if let url = URL(string: "https://\(self?.productViewModel.getStoreProduct()?.storeProduct?.store?.website ?? "")") {
                UIApplication.shared.open(url)
            }
        }

        bottomView.phoneAction = { [weak self] in
            if let phoneCallURL = URL(string: "tel://\(self?.productViewModel.getStoreProduct()?.storeProduct?.store?.phoneNo ?? "")") {

                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
              }
        }

        bottomView.locationAction = { [weak self] in
            if let latDouble = Double(self?.productViewModel.getStoreProduct()?.storeProduct?.store?.lat ?? "") , let lngDouble = Double(self?.productViewModel.getStoreProduct()?.storeProduct?.store?.lon ?? "") {
              Helper.OpenMap(latDouble, lngDouble)
            } else {
                self?.showToast(message: "Can't open the Map ")
            }
        }

        bottomView.whatsAppAction = { [weak self] in
            let urlWhats = "whatsapp://send?phone=\(self?.productViewModel.getStoreProduct()?.storeProduct?.store?.website ?? "")"
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
    private func updateUI(product: SingleProduct?) {
        guard let product = product else {
            return
        }
        contentView.storeProduct = product
    }
}

extension ProductViewController :ProductContentViewDelegate {
    func submiteReview(_ message: String, _ rating: Int) {
        self.showLoading()
        productViewModel.submitReview(review: message, rate: rating, storeProductId: productViewModel.getStoreProduct()?.storeProduct?.id ?? 0) {[weak self] error in
            defer {
                self?.stopLoading()
            }

            if let error = error {
                self?.showToast(message: error)
            }

            if let review = self?.productViewModel.getReview() {
                self?.contentView.reviews.append(review)
            }

            self?.contentView.addReviewContainer.isHidden = true
        }
    }
    
    func showTostMessage(with error: String) {
        self.showToast(message: error)
    }

    func deleteReview(id: Int) {
        self.showLoading()
        self.productViewModel.deleteReview(reviewId: id) { [weak self] error in
            defer {
                self?.stopLoading()
            }

            if let error = error {
                self?.showToast(message: error)
                return
            }

            self?.contentView.addReviewContainer.isHidden = false
            self?.showToast(message: "Review deleted successfully")
            self?.contentView.reviews = self?.contentView.reviews.filter {$0.id != id
            } ?? []
        }
    }

    func didTapOnViewAllproducts() {
        let vc = initViewControllerWith(identifier: StoreProductsViewController.className, and: "\(storeName ?? "All Products")", storyboardName: Storyboard.MainPhase.rawValue) as! StoreProductsViewController
        vc.categoryId = self.productViewModel.getStoreProduct()?.storeProduct?.store?.storeCategoryid
        vc.storeId = -1
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
        let text = productViewModel.getStoreProduct()?.storeProduct?.shareLink

               // set up activity view controller
               let textToShare = [ text ]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

               // exclude some activity types from the list (optional)
               activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

               // present the view controller
               self.present(activityViewController, animated: true, completion: nil)
    }

    func didTapOnProduct(id: Int) {
        let vc = initViewControllerWith(identifier: ProductViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! ProductViewController
        vc.storeId = storeId
        vc.productId = id
        show(vc)
    }

    func visatStoreTapped() {
        let vc = initViewControllerWith(identifier: StoreViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! StoreViewController
               vc.storeId = storeId
               show(vc)
    }

    func didTapOnBanner(productImagesFile: [StoreProductFile]) {
        let vc = initViewControllerWith(identifier: PhotoViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! PhotoViewController
        vc.imagesFile = productImagesFile
        self.show(vc)
    }
}
