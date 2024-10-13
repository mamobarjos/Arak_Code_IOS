//
//  DetailView.swift
//  Arak
//
//  Created by Abed Qassim on 27/02/2021.
//

import UIKit
import FSPagerView
import AVKit
import Cosmos

class DetailView: UIView {
    enum Action {
        case call(phone: String)
        case whatsapp(phone: String)
        case location(lat: String , lng: String)
        case website(url: String)
        case playVideo(path: String?)
        case checkout
        case empty // no Action
        case favorite(id: Int)
        case viewFullScreen
        case backToHome
    }
    enum ViewMode {
        case view
        case detail
    }
    
    typealias ActionBlock = ((Action) -> ())
    
//    @IBOutlet weak var companyNameValueLabel: UILabel!
//    @IBOutlet weak var companyLabel: UILabel!
//    @IBOutlet weak var companyStackView: UIStackView!
//    @IBOutlet weak var phoneNumberStackView: UIStackView!
//    @IBOutlet weak var locationStackView: UIStackView!
//    @IBOutlet weak var websiteStackView: UIStackView!
//    @IBOutlet weak var websiteLabel: UILabel!
//    @IBOutlet weak var websiteValueLabel: UILabel!
//    @IBOutlet weak var websiteImageView: UIImageView!
//    @IBOutlet weak var locationImageView: UIImageView!
//    @IBOutlet weak var locationValueLabel: UILabel!
//    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var phoneImageView: UIImageView!
//    @IBOutlet weak var phoneNumberValueLabel: UILabel!
//    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var descriptionValueLabel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sliderPageView: FSPagerView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var checkoutButton: UIButton!
    
//    @IBOutlet weak var whatsappImageView: UIImageView!
    @IBOutlet weak var totalAmountValueLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cartDetailsLabel: UILabel!
//    @IBOutlet weak var favoriateButton: UIButton!
    
//    @IBOutlet weak var backToHome: UIButton!
    
    @IBOutlet weak var numberOfImagesView: UIView!
    @IBOutlet weak var numberOfImagesLabel: UILabel!
    
    
//    @IBOutlet weak var reviewrTableView: UITableView!

//    @IBOutlet weak var reviewStoreTitleLabel: UILabel!
//    @IBOutlet weak var rateThisProviderTitleLabel: UILabel!
//    @IBOutlet weak var submitButton: UIButton!
    
//    @IBOutlet weak var heightConst: NSLayoutConstraint!
//
//    @IBOutlet weak var addReviewContainer: UIView!
//    @IBOutlet weak var cosmosView: CosmosView!
//    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var quickAccessContainerView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var whatsButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    
    @IBOutlet weak var reviewsContainerView: UIView!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var viewAllReviewsButton: UIButton!
    @IBOutlet weak var viewAllReviewsStackView: UIStackView!
    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var addReviewButton: UIButton!
    
    private var actionType: ActionBlock?
    private var ads: Adverisment?
    private var viewMode: ViewMode = .detail
    private var mediaList: [AdFile] = []
    private var mediaListPreparing: [AdImagePrepare] = []
    private(set) var rating: Int?
    
    var sender: DetailViewController?
    var reviews: [ReviewResponse] = [] {
        didSet {
            if reviews.isEmpty {
                reviewsContainerView.isHidden = true
            } else {
                reviewsContainerView.isHidden = false
            }
            reviewsTableView.reloadData()
        }
    }
    
    func configeUI(ads: Adverisment? ,viewMode: ViewMode, viewController: DetailViewController? ,actionType: ActionBlock?) {
        self.reviews = ads?.reviews ?? []
        self.ads = ads
        self.actionType = actionType
        self.viewMode = viewMode
        self.setup()
        self.sender = viewController
        setupTableView()
    }
    
    
    private func setupTableView() {
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.rowHeight = 150
        reviewsTableView.isScrollEnabled = false
        reviewsTableView.estimatedRowHeight = 150
        reviewsTableView.separatorColor = .clear
        reviewsTableView.register(ReviewTableViewCell.self)
    }

    private func setup() {
        guard let ads = ads else {
            return
        }
        
        numberOfImagesView.isHidden = viewMode == .view

        
        if (viewMode == .view) {
            reviewsContainerView.isHidden = true
            addReviewButton.isHidden = true
            summaryView.isHidden = false
            if (ads.adImages?.count ?? 0 != 0) {
                self.mediaList = ads.adImages ?? []
            }else {
                self.mediaListPreparing = ads.adFileImagesPreparing ?? []
            }
        } else {
            summaryView.isHidden = true
            self.mediaList = ads.adImages ?? []
        }
        
        self.localiztion()
        self.setupSlider()
        quickAccessContainerView.isHidden = viewMode == .view
        websiteButton.isHidden = ads.adCategoryID != AdsTypes.videoWeb.rawValue
        addReviewButton.isHidden = ads.isReviewed ?? false
        locationNameLabel.text = ads.locationTitle
        titleValueLabel.text = ads.title ?? ""
        descriptionValueLabel.text = ads.desc ?? ""
        totalAmountValueLabel.text = ads.totalAmount ?? ""
        
       
        
//        whatsappImageView.isHidden = viewMode == .view
//        backToHome.isHidden  = viewMode == .view
    }
    
    
    private func localiztion() {
        reviewTitleLabel.text = "label.Reviews".localiz()
        viewAllReviewsButton.setTitle("See All".localiz(), for: .normal)
        cartDetailsLabel.text = "Cart Details".localiz()
        checkoutButton.setTitle("Check Out".localiz(), for: .normal)
//        backToHome.setTitle("Back To Ads".localiz(), for: .normal)
    }
    
    private func setupSlider() {
        
        let nib = UINib(nibName: "ImageCell", bundle: Bundle.main)
        sliderPageView.register(nib, forCellWithReuseIdentifier: "cell")
        sliderPageView.automaticSlidingInterval = 0
        sliderPageView.transformer = FSPagerViewTransformer(type: .linear)
        sliderPageView.delegate = self
        sliderPageView.dataSource = self
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = mediaList.count
    }
    
    @IBAction func addReviewButtonAction(_ sender: Any) {
        let vc = UIApplication.shared.topViewController?.initViewControllerWith(identifier: RateViewController.className, and: "", storyboardName: "Main") as! RateViewController
        vc.delegate = self
        self.sender?.present(vc)
    }
    
    @IBAction func Whatsapp(_ sender: Any) {
        if (viewMode == .view) {
            return
        }
        actionType?(.whatsapp(phone: ads?.phoneNo ?? ""))
    }
    
//    @IBAction func Favorite(_ sender: Any) {
//        if (viewMode == .view) {
//            return
//        }
//        actionType?(.favorite(id: ads?.id ?? -1))
//    }
    
    
    @IBAction func seeAllReviewsButtonAction(_ sender: Any) {
        let vc = AllReviewsViewController.loadFromNib()
        vc.reviewsType = .Ad(self.ads)
        self.sender?.show(vc)
    }
    
    @IBAction func CallPhone(_ sender: Any) {
        if (viewMode == .view) {
            return
        }
        actionType?(.call(phone: ads?.phoneNo ?? ""))
    }
    
    @IBAction func Checkout(_ sender: Any) {
        if (viewMode == .detail) {
            return
        }
        actionType?(.checkout)
    }
    
    @IBAction func OpenLocation(_ sender: Any) {
        if (viewMode == .view) {
            return
        }
        actionType?(.location(lat: ads?.lat ?? "", lng: ads?.lon ?? ""))
        
    }
    
    @IBAction func websiteAction(_ sender: Any) {
        self.actionType?(.website(url:  self.ads?.websiteURL ?? "")) //To Do...
    }
   
}

extension DetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return reviews.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell:ReviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let review = reviews[indexPath.row]
            cell.storeNameLabel.text = ""
            cell.cosumizeCell(review: review)
            cell.onDeleteAction = { [weak self] in
                self?.sender?.deleteReview(id: review.id ?? 0)
            }
            return cell
    }
}

extension DetailView : FSPagerViewDelegate ,  FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if (mediaListPreparing.count != 0) {
            return mediaListPreparing.count
        }
        return mediaList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as? ImageCell else {
            return FSPagerViewCell()
        }
        if viewMode == .view {
            if (mediaListPreparing.count != 0) {
                cell.photoImageView.image = mediaListPreparing[index].path
                cell.photoImageView.contentMode = .scaleAspectFill
                cell.photoImageView.clipsToBounds = true // If you want to crop
                cell.playVideoButton.isHidden = true
            } else {
                cell.setupVideo(path: mediaList[index].path) { (path) in
                    self.actionType?(.playVideo(path: path))
                }
                cell.photoImageView.contentMode = .scaleAspectFill
                cell.photoImageView.clipsToBounds = true // If you want to crop
            }
        } else {
            if mediaList[index].path?.isVideo() ?? false {
                cell.setupVideo(path: mediaList[index].path) { (path) in
                    self.actionType?(.playVideo(path: path))
                }
                cell.photoImageView.contentMode = .scaleAspectFill
                cell.photoImageView.clipsToBounds = true // If you want to crop
            }else {
                cell.photoImageView.addTapGestureRecognizer {
                    self.actionType?(.viewFullScreen)
                }
                cell.setup(path: mediaList[index].path)
                cell.photoImageView.contentMode = .scaleAspectFill
                cell.photoImageView.clipsToBounds = true // If you want to crop
            }
        }
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pageControl.currentPage = index
        if mediaListPreparing.count != 0 {
            numberOfImagesLabel.text = "\(index + 1)/\(mediaListPreparing.count)"
        } else {
            numberOfImagesLabel.text = "\(index + 1)/\(mediaList.count)"
        }
    }
    
    
}

extension DetailView: RateViewControllerDelegate {
    func submiteReview(_ sender: RateViewController, context: String, rating: Double) {
        sender.dismiss(animated: true)
        self.sender?.submiteReview(context: context, rating: Int(rating))
    }
}
