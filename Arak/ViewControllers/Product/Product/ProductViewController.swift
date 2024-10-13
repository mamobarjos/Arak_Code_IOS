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
    
    let favouritButton = UIButton(type: .custom)
    let shareButton = UIButton(type: .custom)
    let cartButton = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationButtons()
        view.addSubview(scrollView)
//        view.addSubview(bottomView)

//        view.bringSubviewToFront(bottomView)

//        bottomView.layout
//            .leading(to: .superview)
//            .trailing(to: .superview)
//            .bottom(to: .superview)

        scrollView.layout.fill(.safeArea)
        scrollView.scrollView.contentInset.bottom = 150

        contentView.delegate = self

        configration(productId: productId ?? 0)
//        visitStoreButtom.addTarget(self, action: #selector(handleVisitStoreTap), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
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
            self?.contentView.reviews = self?.productViewModel.getStoreProduct()?.storeProductReviews ?? []
        })
        
        productViewModel.getRelatedProduct(productId: productId) {[weak self] error in
            defer {
                self?.stopLoading()
            }

            if let error = error {
                self?.showToast(message: error)
            }
            
            self?.contentView.relatedProducts = self?.productViewModel.getRelatedProducts() ?? []
        }
    }
    
    private func setupNavigationButtons() {
               
               // Create the custom view
               let customView = UIView()
               
               // Create buttons with images
              
        favouritButton.setImage(UIImage(named: "favorite_heart_like_love_icon"), for: .normal)
        favouritButton.addTarget(self, action: #selector(favouritButtonAction), for: .touchUpInside)
               
               
               shareButton.setImage(UIImage(named: "share_social_icon"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
               
              
               cartButton.setImage(UIImage(named: "cart_nav_new"), for: .normal)
        cartButton.addTarget(self, action: #selector(cartButtonAction), for: .touchUpInside)
               
               // Add buttons to the custom view
//               customView.addSubview(favouritButton)
               customView.addSubview(shareButton)
//               customView.addSubview(cartButton)
               
               // Add constraints to position the buttons
        customView.translatesAutoresizingMaskIntoConstraints = false
        favouritButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            cartButton.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
//            cartButton.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
//            cartButton.widthAnchor.constraint(equalToConstant: 30),
            
            shareButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: 3),
            shareButton.topAnchor.constraint(equalTo: customView.topAnchor),
            shareButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 30),
            
//            favouritButton.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 3),
//            favouritButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor),
//            favouritButton.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
//            favouritButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        customView.widthAnchor.constraint(equalToConstant: 96).isActive = true // Adjust as needed
        customView.heightAnchor.constraint(equalToConstant: 40).isActive = true // Adjust as
               // Create a UIBarButtonItem with the custom view
               let customBarButtonItem = UIBarButtonItem(customView: customView)
               
               // Add the custom view to the right side of the navigation bar
               self.navigationItem.rightBarButtonItem = customBarButtonItem
    }

    @objc func favouritButtonAction() {
          print("Button 1 tapped")
      }

      @objc func shareButtonAction() {
          let textToShare = [self.productViewModel.getStoreProduct()?.store?.website ?? ""]
          let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
          
          // For iPads, you need to specify the popover presentation controller
          if let popoverController = activityViewController.popoverPresentationController {
              popoverController.sourceView = self.view
          }
          
          self.present(activityViewController, animated: true, completion: nil)
      }

      @objc func cartButtonAction() {
          print("Button 3 tapped")
      }
    
    func shareText(text: String, viewController: UIViewController) {
      
    }
//    @objc func handleVisitStoreTap() {
//
//        let vc = initViewControllerWith(identifier: StoreViewController.className, and: "", storyboardName: Storyboard.MainPhase.rawValue) as! StoreViewController
//        vc.storeId = storeId
//        show(vc)
//    }

}


extension ProductViewController {
    private func updateUI(product: StoreProduct?) {
        guard let product = product else {
            return
        }
        self.title = product.store?.name
        contentView.storeProduct = product
    }
}

extension ProductViewController :ProductContentViewDelegate {
    func didTapOnViewAllReviews() {
        let vc = AllReviewsViewController.loadFromNib()
        vc.reviewsType = .product(self.productViewModel.getStoreProduct())
        self.show(vc)
    }
    
    func submiteReview(_ message: String, _ rating: Int) {
        self.showLoading()
        productViewModel.submitReview(review: message, rate: rating, storeProductId: productViewModel.getStoreProduct()?.id ?? 0) {[weak self] error in
            defer {
                self?.stopLoading()
            }

            if let error = error {
                self?.showToast(message: error)
            }

            self?.configration(productId: self?.productId ?? 0)
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

            self?.configration(productId: self?.productId ?? 0)
        }
    }

    func didTapOnViewAllproducts() {
        let vc = initViewControllerWith(identifier: StoreProductsViewController.className, and: "\(storeName ?? "All Products")", storyboardName: Storyboard.MainPhase.rawValue) as! StoreProductsViewController
        vc.categoryId = self.productViewModel.getStoreProduct()?.store?.storeCategoryID
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
//        let text = productViewModel.getStoreProduct()?.storeProduct?.shareLink
//
//               // set up activity view controller
//               let textToShare = [ text ]
//               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//
//               // exclude some activity types from the list (optional)
//               activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
//
//               // present the view controller
//               self.present(activityViewController, animated: true, completion: nil)
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
