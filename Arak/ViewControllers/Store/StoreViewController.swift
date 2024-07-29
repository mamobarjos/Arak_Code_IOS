//
//  StoreViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 12/02/2022.
//

import UIKit

class StoreViewController: UIViewController {
    enum StoreType {
        case regularStore
        case myStore
    }

    let contentView = StoreContentView()
    lazy var scrollView = ScrollContainerView(contentView: contentView)
    let bottomView = BottomBarItemView()

    private var storeViewModel: StoreViewModel = StoreViewModel()

    var storeId: Int?
    var storeType: StoreType = .regularStore
    private var storeDetails: SingleStore?

    public var mode: StoreMode = .add
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
//        view.addSubview(bottomView)
//        bottomView.layout
//            .leading(to: .superview)
//            .trailing(to: .superview)
//            .bottom(to: .superview)

//        view.bringSubviewToFront(bottomView)

        scrollView.layout.fill(.superview)
        scrollView.scrollView.contentInset.bottom = 10

        contentView.delegate = self
        configration(storeId: storeId ?? 1)
        if mode == .edit {
//            contentView.favButton.isHidden = false
//            contentView.favButton.setImage(UIImage(named: "Icon material-edit"), for: .normal)
//            contentView.addButton.isHidden = false
//            contentView.addReviewContainer.isHidden = true
        }
        connectAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: true)
    }

    func configration(storeId: Int) {
        self.showLoading()
        if mode == .edit {
            storeViewModel.getUserStore { [weak self] error in
                defer {
                    self?.stopLoading()
                }

                if let error = error {
                    self?.showToast(message: error)
                }

                self?.contentView.storeDetails = self?.storeViewModel.getStoreDetails()

                if let storeDetails = self?.storeViewModel.getStoreDetails() {
                    self?.storeDetails = storeDetails
                }

                self?.contentView.products = self?.storeViewModel.getStoreProduct() ?? []
                self?.contentView.reviews = self?.storeViewModel.getReviews() ?? []
            }
        } else {

            storeViewModel.getStore(stroeId: storeId, complition: {[weak self] error in
                defer {
                    self?.stopLoading()
                }

                if let error = error {
                    self?.showToast(message: error)
                }

                self?.contentView.storeDetails = self?.storeViewModel.getStoreDetails()

                if let storeDetails = self?.storeViewModel.getStoreDetails() {
                    self?.storeDetails = storeDetails
                }

                self?.contentView.products = self?.storeViewModel.getStoreProduct() ?? []
                self?.contentView.reviews = self?.storeViewModel.getReviews() ?? []
            })
        }
    }

   private func connectAction() {
        bottomView.webAction = { [weak self] in
            if let url = URL(string: self?.storeDetails?.website ?? "") {
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

        bottomView.locationAction = { [weak self] in
            if let latDouble = Double(self?.storeDetails?.lat ?? "") , let lngDouble = Double(self?.storeDetails?.lon ?? "") {
              Helper.OpenMap(latDouble, lngDouble)
            } else {
                self?.showToast(message: "Can't open the Map ")
            }
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
        let vc = initViewControllerWith(identifier: AddServiceViewController.className, and: "\(storeDetails?.name ?? "Add Product")", storyboardName: Storyboard.MainPhase.rawValue) as! AddServiceViewController
        show(vc)
    }

    func didTapViewAllProduct() {
        let vc = initViewControllerWith(identifier: StoreProductsViewController.className, and: "\(storeDetails?.name ?? "All Products")", storyboardName: Storyboard.MainPhase.rawValue) as! StoreProductsViewController
        if mode == .edit {
            vc.storeId = storeDetails?.id
            vc.mode = .edit
        } else {
            vc.storeId = storeId
        }

        show(vc)
    }

    func didTapOnFav(id: Int) {
       let vc = self.initViewControllerWith(identifier: SignUpStoreViewController.className, and: "Your Store", storyboardName: Storyboard.storeAuth.rawValue) as! SignUpStoreViewController
        vc.mode = .edit
        show(vc)
    }

    func didTapOnEdit(id: Int) {
        self.showToast(message: "WIll be Implemented later 😎")
    }

    func didTapOnBack() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    func didTapOnProduct(id: Int) {
        if storeType == .myStore {
            let vc = initViewControllerWith(identifier: AddServiceViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! AddServiceViewController
            vc.mode = .edit
            let product = self.storeViewModel.getStoreProduct().filter{$0.id == id}.first
            vc.product = product
            show(vc)
        } else {
            let vc = initViewControllerWith(identifier: ProductViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! ProductViewController
            vc.storeId = storeId
            vc.storeName = storeDetails?.name
            vc.productId = id
            show(vc)
        }

    }

    func submiteReview(_ message: String, _ rating: Int) {
        self.showLoading()
        storeViewModel.submitReview(review: message, rate: rating, stroeId: storeId ?? 0) {[weak self] error in
            defer {
                self?.stopLoading()
            }

            if let error = error {
                self?.showToast(message: error)
            }

            if let review = self?.storeViewModel.getReview() {
                self?.contentView.reviews.append(review)
            }

//            self?.contentView.addReviewContainer.isHidden = true
        }
    }

    func showTostMessage(with error: String) {
        self.showToast(message: error)
    }

    func deleteReview(id: Int) {
        self.showLoading()
        self.storeViewModel.deleteStoreReview(reviewId: id) { [weak self] error in
            defer {
                self?.stopLoading()
            }

            if let error = error {
                self?.showToast(message: error)
                return
            }

//            self?.contentView.addReviewContainer.isHidden = false
            self?.showToast(message: "Review deleted successfully")
            self?.contentView.reviews = self?.storeViewModel.getReviews().filter{
                $0.id != id
            } ?? []
        }
    }
}
