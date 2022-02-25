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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var myDetailLabel: UILabel!
    @IBOutlet weak var myAdsLabel: UILabel!
    @IBOutlet weak var signOutLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var favorateLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var generalLabel: UILabel!
    // MARK: - Properties
    var viewModel: ProfileViewModel = ProfileViewModel()

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Helper.userType == Helper.UserType.GUEST.rawValue  {
            showLogin()
            Helper.resetLoggingData()
            return
        }
        usernameLabel.text = Helper.currentUser?.fullname ?? ""
        profileImageView.getAlamofireImage(urlString: Helper.currentUser?.imgAvatar)
        if HomeViewController.goToMyAds {
            HomeViewController.goToMyAds = false
            let vc = initViewControllerWith(identifier: MyAdsViewController.className, and: "My Ads".localiz()) as! MyAdsViewController
            show(vc)
        }
       
    }
    
    // MARK: - IBAction
    
    @IBAction func Favorite(_ sender: Any) {
        let vc = initViewControllerWith(identifier: HomeViewController.className, and: "Favorite".localiz()) as! HomeViewController
        vc.config(screenType: .Favrate)
        show(vc)
    }
    
    @IBAction func History(_ sender: Any) {
        let vc = initViewControllerWith(identifier: HomeViewController.className, and: "History".localiz()) as! HomeViewController
        vc.config(screenType: .History)
        show(vc)
    }
    
    @IBAction func MyDetail(_ sender: Any) {
//        let vc = initViewControllerWith(identifier: Main.className, and: "Edit Profile".localiz()) as! EditProfileViewController
//        show(vc)
        let vc = initViewControllerWith(identifier: AdStatusViewController.className, and: "Edit Profile".localiz(), storyboardName: Storyboard.MainPhase.rawValue) as! AdStatusViewController
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
    
    
    @IBAction func SignOut(_ sender: Any) {
        logout()
    }
    
    // MARK: - Protected Methods
    
    private func logout() {
        showLoading()
        viewModel.logout { [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            let vc = self?.initViewControllerWith(identifier: "LoginViewController", and: "",storyboardName: Storyboard.Auth.rawValue) as! LoginViewController
            self?.presentWithNavigation(vc, animated: true, configure: nil, completion: nil)
        }
    }
    
    private func setupUI() {
        myDetailLabel.text = "My Detail".localiz()
        myAdsLabel.text = "My Ads".localiz()
        signOutLabel.text = "Sign out".localiz()
        favorateLabel.text = "Favorite".localiz()
        historyLabel.text = "History".localiz()
        generalLabel.text = "General".localiz()
    }
    
}
