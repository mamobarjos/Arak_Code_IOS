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

    @IBOutlet weak var relatedProductTitleLabel: UILabel!
//    @IBOutlet weak var rateThisProviderTitleLabel: UILabel!
    @IBOutlet weak var reviewTitleLabel: UILabel!
//    @IBOutlet weak var submitButton: UIButton!

//    @IBOutlet weak var vistStoreButton: UIButton!
    @IBOutlet weak var favButton: UIButton!

    @IBOutlet weak var viewAllProducts: UIButton!
//    @IBOutlet weak var addReviewContainer: UIView!

    var homeViewModel = HomeViewModel()

    private(set) var rating: Int?
    
    weak var delegate: ProductContentViewDelegate?
    var storeProduct: SingleProduct?  {
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
  
    @IBAction func favAction(_ sender: Any) {
        delegate?.userDidTapFavIcon(id: "1")
    }
    
    
    @IBAction func viewAllAction(_ sender: Any) {
        delegate?.didTapOnViewAllproducts()
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
         reviewTitleLabel.text = "label.Review".localiz()
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
         reviewsTableView.register(ReviewTableViewCell.self)
//         editedCosmosView.rating = 0
//         editedCosmosView.didFinishTouchingCosmos = { [weak self] rating in
//             self?.rating = Int(rating)
//         }
         viewAllProducts.addTapGestureRecognizer {[weak self] in
             self?.delegate?.didTapOnViewAllproducts()
         }
    }

    private func updateUI(product: SingleProduct) {
        productNameLabel.text = product.storeProduct?.name
        shopNameLabel.text = product.storeProduct?.store?.name
        descLable.text = product.storeProduct?.desc
        priceLabel.text = product.storeProduct?.priceformated
        cosmosView.rating = product.storeProduct?.totalRates ?? 0
        ratingLabelText.text = "(\(product.storeProduct?.totalRates ?? 0.0))"
//        self.reviews = product.storeProduct?.reviews ?? []
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
            return CGSize(width: 250, height: 81)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            self.delegate?.didTapOnBanner(productImagesFile: storeProduct?.storeProduct?.storeProductFiles ?? [])
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
        cell.setup(images: storeProduct?.storeProduct?.storeProductFiles ?? [])
        cell.delegate = self
        
        cell.showImages = { [weak self] in
            self?.delegate?.didTapOnBanner(productImagesFile: self?.storeProduct?.storeProduct?.storeProductFiles ?? [])
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func displayedCellIndex(index: Int) {
       
    }
}
