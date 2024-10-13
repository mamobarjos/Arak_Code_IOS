//
//  ProductContentView.swift
//  Arak
//
//  Created by Osama Abu hdba on 13/02/2022.
//

import UIKit
import FSPagerView
import Cosmos

protocol ProductContentViewDelegate: AnyObject {
    func didTapOnProduct(id: Int)
    func userDidTapFavIcon(id: String)
    func userDidTapShare(id: String)
    func userDidTapBack()
    func didTapOnViewAllproducts()
    func didTapOnViewAllReviews()
    func submiteReview(_ message: String, _ rating: Int)
    func showTostMessage(with error: String)
    func deleteReview(id: Int)
    func visatStoreTapped()
    func didTapOnBanner(productImagesFile: [StoreProductFile])
}

class ProductContentView: UIView, FeaturedCelldelegate {
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    //    @IBOutlet weak var pagerView: FSPagerView!

    @IBOutlet weak var descLable: UILabel!
    @IBOutlet weak var ratingLabelText: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
//    @IBOutlet weak var editedCosmosView: CosmosView!
    @IBOutlet weak var relatedProductCollectionView: UICollectionView!
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var productNameLabel: UILabel!
//    @IBOutlet weak var rateTextView: UITextView!

    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    
    @IBOutlet weak var relatedProductTitleLabel: UILabel!
//    @IBOutlet weak var rateThisProviderTitleLabel: UILabel!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var viewAllReviewsButton: UIButton!
    @IBOutlet weak var viewAllReviewsStackView: UIStackView!
    //    @IBOutlet weak var submitButton: UIButton!

//    @IBOutlet weak var vistStoreButton: UIButton!
    @IBOutlet weak var favButton: UIButton!

    @IBOutlet weak var addReviewButton: UIButton!
    @IBOutlet weak var viewAllProducts: UIButton!
//    @IBOutlet weak var addReviewContainer: UIView!
    @IBOutlet weak var barButtonItemView: BottomBarItemView!
    
    var homeViewModel = HomeViewModel()

    private(set) var rating: Int?
    
    weak var delegate: ProductContentViewDelegate?
    var storeProduct: StoreProduct?  {
        didSet {
            guard let storeProduct = storeProduct else {
                return
            }
            self.updateUI(product: storeProduct)
            self.bannerCollectionView.reloadData()
        }
    }

    var panner: [AdBanner] = [] {
        didSet {
            bannerCollectionView.reloadData()
        }
    }

    var relatedProducts: [RelatedProducts] = [] {
        didSet {
            relatedProductCollectionView.reloadData()
        }
    }

    var reviews: [ReviewResponse] = [] {
        didSet {
            if reviews.isEmpty {
                viewAllReviewsStackView.isHidden = true
                reviewsTableView.isHidden = true
            } else {
                viewAllReviewsStackView.isHidden = false
                reviewsTableView.isHidden = false
            }
            reviewsTableView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
//    @IBAction func vistStoreAction(_ sender: Any) {
//        self.delegate?.visatStoreTapped()
//    }
  
    @IBAction func addReviewButtonAction(_ sender: Any) {
        let vc = UIApplication.shared.topViewController?.initViewControllerWith(identifier: RateViewController.className, and: "", storyboardName: "Main") as! RateViewController
        vc.delegate = self
        UIApplication.shared.topViewController?.present(vc)
       
    }
    
    @IBAction func favAction(_ sender: Any) {
        delegate?.userDidTapFavIcon(id: "1")
    }
    
    
    @IBAction func viewAllAction(_ sender: Any) {
        delegate?.didTapOnViewAllproducts()
    }
    
    @IBAction func viewAllReviewsButtonAction(_ sender: Any) {
        delegate?.didTapOnViewAllReviews()
    }
    
//    @IBAction func submitButton(_ sender: Any) {
//        if rateTextView.text == "placeHolder.Enter your review for this service provider...".localiz() || rateTextView.text.isEmpty {
//            self.delegate?.showTostMessage(with: "please add your review")
//            return
//        }
//
//        guard let rating = rating else {
//            self.delegate?.showTostMessage(with: "please rate this product")
//            return
//        }
//
//        delegate?.submiteReview(rateTextView.text, rating)
//    }

     func setup() {
        guard let view = self.loadViewFromNip(nipName: "ProductContentView") else {return}
        view.frame = self.bounds
        self.addSubview(view)

         relatedProductTitleLabel.text = "label.Related Products".localiz()
         reviewTitleLabel.text = "label.Reviews".localiz()
         viewAllReviewsButton.setTitle("See All".localiz(), for: .normal)
         viewAllProducts.setTitle("See All".localiz(), for: .normal)
         
//         rateThisProviderTitleLabel.text = "label.Rate this service Provider".localiz()
//         submitButton.setTitle("action.Submit".localiz(), for: .normal)
//         vistStoreButton.setTitle("action.Visit Store".localiz(), for: .normal)
//         rateTextView.text = "placeHolder.Enter your review for this service provider...".localiz()
//         rateTextView.textAlignment = Helper.appLanguage ?? "en" == "en" ? .left : .right

             homeViewModel.getBannerList(page: 1, search: "") { [weak self] (error) in
             defer {
//                 self?.stopLoading()
                 self?.bannerCollectionView.reloadData()
             }

             if error != nil {
//                 self?.showToast(message: error)
                 return
             }
         }

//         rateTextView.delegate = self
//         rateTextView.text = "placeHolder.Enter your review for this service provider...".localiz()
//         rateTextView.textColor = UIColor.lightGray

         relatedProductCollectionView.delegate = self
         relatedProductCollectionView.dataSource = self
         relatedProductCollectionView.register(ProductCollectionViewCell.self)
         relatedProductCollectionView.reloadData()

         bannerCollectionView.contentInsetAdjustmentBehavior = .always
         bannerCollectionView.delegate = self
         bannerCollectionView.dataSource = self
         bannerCollectionView.register(FeaturedCell.self)

         reviewsTableView.delegate = self
         reviewsTableView.dataSource = self
         reviewsTableView.rowHeight = 150
         reviewsTableView.estimatedRowHeight = 150
         reviewsTableView.separatorColor = .clear
         reviewsTableView.isScrollEnabled = false
         reviewsTableView.register(ReviewTableViewCell.self)
//         editedCosmosView.rating = 0
//         editedCosmosView.didFinishTouchingCosmos = { [weak self] rating in
//             self?.rating = Int(rating)
//         }
         viewAllProducts.addTapGestureRecognizer {[weak self] in
             self?.delegate?.didTapOnViewAllproducts()
         }
    }

    private func updateUI(product: StoreProduct) {
        productNameLabel.text = product.name
        shopNameLabel.text = product.store?.name
        descLable.text = product.desc
        priceLabel.text = product.priceformated
        cosmosView.rating = Double(product.totalRates ?? 5.0)
        ratingLabelText.text = "[\(product.totalRates?.rounded(toPlaces: 1) ?? 5.0)]"
        addReviewButton.isHidden = product.isReviewed ?? false
        priceLabel.text = product.priceformated
        salePriceLabel.text = (product.salePrice ?? "") + " " + (Helper.currencyCode ?? "JOD")
        priceLabel.textColor = .lightGray
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.lightGray
        ]

        let attributedText = NSAttributedString(string: priceLabel.text ?? "", attributes: strokeTextAttributes)
        priceLabel.attributedText = attributedText
        
        priceLabel.isHidden = product.price == product.salePrice
        
//        self.reviews = product.storeProduct?.reviews ?? []
        
        barButtonItemView.webAction = { [weak self] in
            if let url = URL(string: "https://\(self?.storeProduct?.store?.website ?? "")") {
                UIApplication.shared.open(url)
            }
        }

        barButtonItemView.phoneAction = { [weak self] in
            if let phoneCallURL = URL(string: "tel://\(self?.storeProduct?.store?.phoneNo ?? "")") {

                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
              }
        }

        barButtonItemView.locationAction = { [weak self] in
            if let latDouble = Double(self?.storeProduct?.store?.lat ?? "") , let lngDouble = Double(self?.storeProduct?.store?.lon ?? "") {
              Helper.OpenMap(latDouble, lngDouble)
            } else {
//                self?.showToast(message: "Can't open the Map ")
            }
        }

        barButtonItemView.whatsAppAction = { [weak self] in
            let urlWhats = "whatsapp://send?phone=\(self?.storeProduct?.store?.phoneNo ?? "")"
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

extension ProductContentView: RateViewControllerDelegate {
    func submiteReview(_ sender: RateViewController, context: String, rating: Double) {
        sender.dismiss(animated: true)
        delegate?.submiteReview(context, Int(rating))
    }
}

extension ProductContentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "placeHolder.Enter your review for this service provider...".localiz() {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            textView.text = "placeHolder.Enter your review for this service provider...".localiz()
            textView.textColor = .lightGray
        }
    }
}


extension ProductContentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:ReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let review = reviews[indexPath.row]
        cell.cosumizeCell(review: review)
        cell.onDeleteAction = { [weak self] in
            self?.delegate?.deleteReview(id: review.id ?? 0)
        }
            return cell

    }
}

extension ProductContentView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return 1
        } else {
            return relatedProducts.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            return makeFeatured(indexPath: indexPath, isBanner: true)
        } else {
            let cell:ProductCollectionViewCell = relatedProductCollectionView.dequeueReusableCell(forIndexPath: indexPath)
            let product = relatedProducts[indexPath.item]
            cell.setup(product: product)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return CGSize(width: bannerCollectionView.bounds.width, height: bannerCollectionView.bounds.height)
        } else {
            return CGSize(width: 275, height: 81)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            self.delegate?.didTapOnBanner(productImagesFile: storeProduct?.storeProductsFile ?? [])
        } else {
            let product = relatedProducts[indexPath.item]
            self.delegate?.didTapOnProduct(id: product.id ?? 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    }

    func makeFeatured(indexPath:IndexPath,isBanner: Bool) -> FeaturedCell {
            let cell:FeaturedCell = bannerCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.ImageCornerRadius = 0
        cell.setup(images: storeProduct?.storeProductsFile ?? [])
        cell.delegate = self
        
        cell.showImages = { [weak self] in
            self?.delegate?.didTapOnBanner(productImagesFile: self?.storeProduct?.storeProductsFile ?? [])
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func displayedCellIndex(index: Int) {
       
    }
}
