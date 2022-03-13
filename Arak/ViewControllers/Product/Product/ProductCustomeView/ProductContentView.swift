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
    func userDidTapFavIcon(id: String)
    func userDidTapShare(id: String)
    func userDidTapBack()
    func didTapOnViewAllproducts()
}

class ProductContentView: UIView, FeaturedCelldelegate {
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    //    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pagerConntainerView: UIView!

    @IBOutlet weak var descLable: UILabel!
    @IBOutlet weak var ratingLabelText: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var editedCosmosView: CosmosView!
    @IBOutlet weak var relatedProductCollectionView: UICollectionView!
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var rateTextView: UITextView!

    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favButton: UIButton!

    @IBOutlet weak var viewAllProducts: UIButton!

    var pageControl = PageControl()
    var homeViewModel = HomeViewModel()

    weak var delegate: ProductContentViewDelegate?
    var storeProduct: [Product] = [] {
        didSet {
            self.updateUI(product: storeProduct)
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    @IBAction func shareAction(_ sender: Any) {
        delegate?.userDidTapShare(id: "1")
    }
    @IBAction func favAction(_ sender: Any) {
        delegate?.userDidTapFavIcon(id: "1")
    }
    @IBAction func backAction(_ sender: Any) {
        delegate?.userDidTapBack()
    }
    @IBAction func submitButton(_ sender: Any) {

    }

     func setup() {
        guard let view = self.loadViewFromNip(nipName: "ProductContentView") else {return}
        view.frame = self.bounds
        self.addSubview(view)

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

         rateTextView.delegate = self
         rateTextView.text = "Enter your review for this service provider..."
         rateTextView.textColor = UIColor.lightGray

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
         reviewsTableView.rowHeight = UITableView.automaticDimension
         reviewsTableView.estimatedRowHeight = 150
         reviewsTableView.separatorColor = .clear
         reviewsTableView.register(ReviewTableViewCell.self)

         viewAllProducts.addTapGestureRecognizer {[weak self] in
             self?.delegate?.didTapOnViewAllproducts()
         }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        pagerConntainerView.backgroundColor = .clear
        pagerConntainerView.addSubview(pageControl)
        pagerConntainerView.bringSubviewToFront(pageControl)

        pageControl.layout
            .leading(.lessOrEqual, to: .superview, edge: .leading)
            .trailing(.lessOrEqual, to: .superview, edge: .trailing)
            .centerY(to: .superview)
            .centerX(to: .superview)

        bannerCollectionView.clipsToBounds = true
        bannerCollectionView.cornerRadius = 30
        bannerCollectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    private func updateUI(product: [Product]) {
        guard let product = product.first else { return }
        productNameLabel.text = product.name
        shopNameLabel.text = product.store?.name
        descLable.text = product.desc
        priceLabel.text = product.priceformated
        cosmosView.rating = product.totalRates ?? 0
        ratingLabelText.text = "(\(product.totalRates ?? 0.0))"
    }
}

extension ProductContentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your review for this service provider..." {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            textView.text = "Enter your review for this service provider..."
            textView.textColor = .lightGray
        }
    }
}


extension ProductContentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:ReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//            cell.setup()
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
            return CGSize(width: 143, height: 201)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    }

    func makeFeatured(indexPath:IndexPath,isBanner: Bool) -> FeaturedCell {
            let cell:FeaturedCell = bannerCollectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(bannerList: homeViewModel.getAllBanner())
        pageControl.numberOfPages = homeViewModel.getAllBanner().count
        pageControl.isHidden = homeViewModel.getAllBanner().count == 1
        print(homeViewModel.getAllBanner().count)
        cell.delegate = self
        cell.layoutIfNeeded()
        return cell
    }
    func displayedCellIndex(index: Int) {
        pageControl.selectedIndex = index
    }
}
