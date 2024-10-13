//
//  ProfileViewController.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//  
//

import UIKit
import Foundation
import SwiftUI


class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
//    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var myDetailLabel: UILabel!
    @IBOutlet weak var myAdsLabel: UILabel!
    @IBOutlet weak var signOutLabel: UILabel!
//    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var favorateLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
//    @IBOutlet weak var generalLabel: UILabel!
    @IBOutlet weak var myStoreLabel: UILabel!
    @IBOutlet weak var myStoreView: UIView!
    @IBOutlet weak var myStoreStackView: UIStackView!
    @IBOutlet weak var myProductsStackView: UIStackView!
    @IBOutlet weak var myProductsLabel: UILabel!
    @IBOutlet weak var arakServicesLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var followUsLabel: UILabel!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var linkedInImageView: UIImageView!
    @IBOutlet weak var youTubeImageView: UIImageView!
    @IBOutlet weak var instagramImageView: UIImageView!
    @IBOutlet weak var twitterImageView: UIImageView!
    
    
    // MARK: - Properties
    var viewModel: ProfileViewModel = ProfileViewModel()
    var storeViewModel: StoreViewModel = StoreViewModel()

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
        if Helper.currentUser?.hasStore == true || Helper.store != nil {
            myStoreStackView.isHidden = false
//            myProductsStackView.isHidden = false
        } else {
            myStoreStackView.isHidden = true
//            myProductsStackView.isHidden = true
        }

        if Helper.userType == Helper.UserType.GUEST.rawValue  {
            showLogin()
            Helper.resetLoggingData()
            return
        }
//        usernameLabel.text = Helper.currentUser?.fullname ?? ""
//        profileImageView.getAlamofireImage(urlString: Helper.currentUser?.imgAvatar)
        if NewHomeViewController.goToMyAds {
            NewHomeViewController.goToMyAds = false
            let vc = initViewControllerWith(identifier: MyAdsViewController.className, and: "My Ads".localiz()) as! MyAdsViewController
            show(vc)
        }
       
        youTubeImageView.addTapGestureRecognizer {[weak self] in
            self?.openYouTube()
        }
        facebookImageView.addTapGestureRecognizer {[weak self] in
            self?.openFacebook()
        }
        
        linkedInImageView.addTapGestureRecognizer {[weak self] in
            self?.openLinkedIn()
        }
        
        twitterImageView.addTapGestureRecognizer {[weak self] in
            self?.openTwitter()
        }
        
        instagramImageView.addTapGestureRecognizer {[weak self] in
            self?.openInstagram()
        }
    }
    
    func openYouTube() {
        let youtubeAppURL = URL(string: "youtube://")!
        guard let youtubeWebURL = URL(string: Helper.arakLinks?.youtube ?? "") else {return}
        
        if UIApplication.shared.canOpenURL(youtubeAppURL) {
            // Open the YouTube app
            UIApplication.shared.open(youtubeAppURL, options: [:], completionHandler: nil)
        } else {
            // Open the YouTube website
            UIApplication.shared.open(youtubeWebURL, options: [:], completionHandler: nil)
        }
    }
    
    func openFacebook() {
        let facebookAppURL = URL(string: "fb://")!
        guard let facebookWebURL = URL(string: Helper.arakLinks?.facebook ?? "") else {return}
        
        if UIApplication.shared.canOpenURL(facebookAppURL) {
            // Open the Facebook app
            UIApplication.shared.open(facebookAppURL, options: [:], completionHandler: nil)
        } else {
            // Open the Facebook website
            UIApplication.shared.open(facebookWebURL, options: [:], completionHandler: nil)
        }
    }
    
    func openInstagram() {
        let instagramAppURL = URL(string: "instagram://")!
        guard let instagramWebURL = URL(string: Helper.arakLinks?.instagram ?? "") else {return}
        
        if UIApplication.shared.canOpenURL(instagramAppURL) {
            // Open the Instagram app
            UIApplication.shared.open(instagramAppURL, options: [:], completionHandler: nil)
        } else {
            // Open the Instagram website
            UIApplication.shared.open(instagramWebURL, options: [:], completionHandler: nil)
        }
    }
    
    func openLinkedIn() {
        let linkedInAppURL = URL(string: "linkedin://")!
        guard let linkedInWebURL = URL(string: Helper.arakLinks?.linkedin ?? "") else { return }
        
        if UIApplication.shared.canOpenURL(linkedInAppURL) {
            // Open the LinkedIn app
            UIApplication.shared.open(linkedInAppURL, options: [:], completionHandler: nil)
        } else {
            // Open the LinkedIn website
            UIApplication.shared.open(linkedInWebURL, options: [:], completionHandler: nil)
        }
    }
    
    func openTwitter() {
        let twitterAppURL = URL(string: "twitter://")!
        guard let twitterWebURL = URL(string: Helper.arakLinks?.x ?? "") else {return}
        
        if UIApplication.shared.canOpenURL(twitterAppURL) {
            // Open the Twitter app
            UIApplication.shared.open(twitterAppURL, options: [:], completionHandler: nil)
        } else {
            // Open the Twitter website
            UIApplication.shared.open(twitterWebURL, options: [:], completionHandler: nil)
        }
    }
    // MARK: - IBAction
    
    @IBAction func Favorite(_ sender: Any) {
        let vc = initViewControllerWith(identifier: FavoriteViewController.className, and: "Favorite".localiz()) as! FavoriteViewController
        vc.source = .Favrate
        show(vc)
    }
    
    @IBAction func History(_ sender: Any) {
        let vc = initViewControllerWith(identifier: FavoriteViewController.className, and: "History".localiz()) as! FavoriteViewController
        vc.source = .History
        show(vc)
    }
    
    @IBAction func arakServicesAction(_ sender: Any) {
        let vc = initViewControllerWith(identifier: ServiceViewController.className, and: "" ) as! ServiceViewController
        show(vc)
        
    }
    
    @IBAction func MyDetail(_ sender: Any) {
        let vc = initViewControllerWith(identifier: EditProfileViewController.className, and: "Edit Profile".localiz()) as! EditProfileViewController
        show(vc)
//        let vc = initViewControllerWith(identifier: AdStatusViewController.className, and: "Edit Profile".localiz(), storyboardName: Storyboard.MainPhase.rawValue) as! AdStatusViewController
//        show(vc)
    }
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        let vc = initViewControllerWith(identifier: SettingsViewController.className, and: "Settings".localiz()) as! SettingsViewController
        show(vc)
    }
    
    @IBAction func MyAds(_ sender: Any) {
        let vc = initViewControllerWith(identifier: MyAdsViewController.className, and: "My Ads".localiz()) as! MyAdsViewController
        show(vc)
    }
    
    @IBAction func NewAdd(_ sender: Any) {
        let vc = initViewControllerWith(identifier: AdsViewController.className, and: "") as! AdsViewController
        show(vc)
    }
    
    @IBAction func MyStore(_ sender: Any) {
        storeViewModel.getUserStore {[weak self] error in
            defer {
                self?.stopLoading()
            }
            
            if let err = error {
                self?.showToast(message: err)
                return
            }
            
            let vc = self?.initViewControllerWith(identifier: UserStoreViewController.className, and: "", storyboardName: Storyboard.storeAuth.rawValue) as! UserStoreViewController
            self?.show(vc)
        }
    }

    @IBAction func myProductsAction(_ sender: Any) {
        let vc = initViewControllerWith(identifier: StoreProductsViewController.className, and: "label.My Products".localiz(), storyboardName: Storyboard.MainPhase.rawValue) as! StoreProductsViewController
        vc.mode = .edit
        vc.storeId = -1
        show(vc)
    }

    @IBAction func SignOut(_ sender: Any) {
        logout()
    }
    
    // MARK: - Protected Methods
    
    private func logout() {
        let cartManager = CartManager()
        cartManager.clearCart()
        Helper.store = nil
        Helper.resetLoggingData()
        let vc = self.initViewControllerWith(identifier: "LoginViewController", and: "",storyboardName: Storyboard.Auth.rawValue) as! LoginViewController
        self.presentWithNavigation(vc, animated: true, configure: nil, completion: nil)
        
    }
    
    private func setupUI() {
        myDetailLabel.text = "My profile".localiz()
        myAdsLabel.text = "My Ads".localiz()
        signOutLabel.text = "Sign out".localiz()
        favorateLabel.text = "Favorite".localiz()
        historyLabel.text = "History".localiz()
//        generalLabel.text = "General".localiz()
        myStoreLabel.text = "label.My Store".localiz()
        myProductsLabel.text = "label.My Products".localiz()
        followUsLabel.text = "Follow Us".localiz()
        arakServicesLabel.text = "Arak Service".localiz()
        settingsLabel.text = "Settings".localiz()
    }
    
}
