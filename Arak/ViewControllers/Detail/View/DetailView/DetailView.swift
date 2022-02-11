//
//  DetailView.swift
//  Arak
//
//  Created by Abed Qassim on 27/02/2021.
//

import UIKit
import FSPagerView
import AVKit

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
    
    @IBOutlet weak var companyNameValueLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var companyStackView: UIStackView!
    @IBOutlet weak var phoneNumberStackView: UIStackView!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var websiteStackView: UIStackView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var websiteValueLabel: UILabel!
    @IBOutlet weak var websiteImageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var phoneNumberValueLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var descriptionValueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sliderPageView: FSPagerView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBOutlet weak var whatsappImageView: UIImageView!
    @IBOutlet weak var totalAmountValueLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cartDetailsLabel: UILabel!
    @IBOutlet weak var favoriateButton: UIButton!
    
    @IBOutlet weak var backToHome: UIButton!
    
    @IBOutlet weak var numberOfImagesView: UIView!
    @IBOutlet weak var numberOfImagesLabel: UILabel!
    
    private var actionType: ActionBlock?
    private var ads: Adverisment?
    private var viewMode: ViewMode = .detail
    private var mediaList: [AdImage] = []
    private var mediaListPreparing: [AdImagePrepare] = []
    
    func configeUI(ads: Adverisment? ,viewMode: ViewMode ,actionType: ActionBlock?) {
        self.ads = ads
        self.actionType = actionType
        self.viewMode = viewMode
        self.setup()
    }
    

    private func setup() {
        
        guard let ads = ads else {
            return
        }
        
        numberOfImagesView.isHidden = viewMode == .view
        phoneImageView.addTapGestureRecognizer {
            if (self.viewMode == .view) {
                return
            }
            self.actionType?(.call(phone: self.ads?.phoneNo ?? ""))
        }
        websiteLabel.addTapGestureRecognizer {
            if (self.viewMode == .view) {
                return
            }
            self.actionType?(.website(url:  self.ads?.websiteURL ?? "")) //To Do...
        }
        
        websiteImageView.addTapGestureRecognizer {
            if (self.viewMode == .view) {
                return
            }
            self.actionType?(.website(url:  self.ads?.websiteURL ?? "")) //To Do...
        }
        
        if (viewMode == .view) {
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
        phoneImageView.isHidden = viewMode == .view
        locationImageView.isHidden = viewMode == .view
        websiteImageView.isHidden = viewMode == .view
        websiteStackView.isHidden = ads.adCategoryID != AdsTypes.videoWeb.rawValue
        
        titleValueLabel.text = ads.title ?? ""
        descriptionValueLabel.text = ads.desc ?? ""
        
        phoneNumberValueLabel.text = ads.phoneNo ?? ""
        
        locationValueLabel.text = (ads.locationTitle ?? "").isEmpty ?   "\(ads.lon ?? ""), \(ads.lat ?? "")" :  (ads.locationTitle ?? "")
        websiteValueLabel.text = ads.websiteURL ?? ""
        companyStackView.isHidden = ads.companyName?.isEmpty ?? false
        companyNameValueLabel.text = ads.companyName ?? ""
        totalAmountValueLabel.text = ads.totalAmount ?? ""
        favoriateButton.isHidden = ads.isMe
        favoriateButton.setImage(ads.isFav ? #imageLiteral(resourceName: "Icon awesome-heart") : #imageLiteral(resourceName: "Icon awesome-heart-1"), for: .normal)
        whatsappImageView.isHidden = viewMode == .view
        backToHome.isHidden  = viewMode == .view
    }
    
    
    private func localiztion() {
        titleLabel.text = "Title".localiz()
        descriptionLabel.text = "Description".localiz()
        phoneNumberLabel.text = "Phone Number".localiz()
        locationLabel.text = "Location".localiz()
        websiteLabel.text = "Website".localiz()
        companyLabel.text = "Company".localiz()
        totalAmountLabel.text = "Total Amount".localiz()
        cartDetailsLabel.text = "Cart Details".localiz()
        checkoutButton.setTitle("Check Out".localiz(), for: .normal)
        backToHome.setTitle("Back To Ads".localiz(), for: .normal)
    
        
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
    
    @IBAction func BackToHome(_ sender: Any) {
        if (viewMode == .view) {
            return
        }
        actionType?(.backToHome)
        
    }
    @IBAction func Whatsapp(_ sender: Any) {
        if (viewMode == .view) {
            return
        }
        actionType?(.whatsapp(phone: ads?.phoneNo ?? ""))
    }
    
    @IBAction func Favorite(_ sender: Any) {
        if (viewMode == .view) {
            return
        }
        actionType?(.favorite(id: ads?.id ?? -1))
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
    
    @IBAction func OpenMap(_ sender: Any) {
        if (viewMode == .view) {
            return
        }
        actionType?(.website(url:  ads?.websiteURL ?? "")) //To Do...
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
