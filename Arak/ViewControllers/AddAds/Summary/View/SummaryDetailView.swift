//
//  SummaryDetailView.swift
//  Arak
//
//  Created by Osama Abu Hdba on 08/09/2024.
//

import UIKit
import FSPagerView
import AVKit
import Cosmos

class SummaryDetailView: UIView {
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
    

    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionValueLabel: UILabel!
    
    @IBOutlet weak var titleValueLabel: UILabel!
    @IBOutlet weak var titleTaxtField: UITextField!
    
    @IBOutlet weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var websiteTextField: UITextField!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationTextfield: UITextField!
    
    @IBOutlet weak var sliderPageView: FSPagerView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBOutlet weak var totalAmountValueLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cartDetailsLabel: UILabel!

    
    @IBOutlet weak var numberOfImagesView: UIView!
    @IBOutlet weak var numberOfImagesLabel: UILabel!
   
    
    
    private var actionType: ActionBlock?
    private var ads: Adverisment?
    private var viewMode: ViewMode = .detail
    private var mediaList: [AdFile] = []
    private var mediaListPreparing: [AdImagePrepare] = []
    private(set) var rating: Int?
    
    var sender: DetailViewController?
    
    
    func configeUI(ads: Adverisment? ,viewMode: ViewMode, viewController: DetailViewController? ,actionType: ActionBlock?) {
        self.ads = ads
        self.actionType = actionType
        self.viewMode = viewMode
        self.setup()
        self.sender = viewController
    }
    
  
    private func setup() {
        guard let ads = ads else {
            return
        }
        
        numberOfImagesView.isHidden = viewMode == .view

        
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

        [titleTaxtField, phoneNumberTextField, locationTextfield, websiteTextField].forEach { field in
            field.cornerRadius = 8
            field.borderColor = .lightGray
            field.borderWidth = 1
            field.setLeftPaddingPoints(5)
            field.setRightPaddingPoints(5)
        }
        
        locationTextfield.text = (ads.locationTitle ?? "")
        titleTaxtField.text = (ads.title ?? "")
        descriptionValueLabel.text =  (ads.desc ?? "")
        phoneNumberTextField.text = (ads.phoneNo ?? "")
        totalAmountValueLabel.text = (ads.totalAmount ?? "")
        websiteTextField.text = ads.websiteURL
        
    }
    
    
    private func localiztion() {
        descriptionTitleLabel.text = "Description".localiz()
        titleValueLabel.text = "Title".localiz()
        phoneNumberTitleLabel.text = "Phone Number".localiz()
        locationNameLabel.text = "Location".localiz()
        totalAmountLabel.text = "Total Amount".localiz()
        websiteLabel.text = "Website".localiz()
        
        descriptionTitleLabel.font = .font(for: .bold, size: 16)
        titleValueLabel.font = .font(for: .bold, size: 16)
        phoneNumberTitleLabel.font = .font(for: .bold, size: 16)
        locationNameLabel.font = .font(for: .bold, size: 16)
        websiteLabel.font = .font(for: .bold, size: 16)
        
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
        if (mediaListPreparing.count != 0) {
            pageControl.numberOfPages = mediaListPreparing.count
        } else {
            pageControl.numberOfPages = mediaList.count
        }
    }
   

    @IBAction func Checkout(_ sender: Any) {
        actionType?(.checkout)
    }
}

extension SummaryDetailView : FSPagerViewDelegate ,  FSPagerViewDataSource {
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

extension SummaryDetailView: RateViewControllerDelegate {
    func submiteReview(_ sender: RateViewController, context: String, rating: Double) {
        sender.dismiss(animated: true)
        self.sender?.submiteReview(context: context, rating: Int(rating))
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
