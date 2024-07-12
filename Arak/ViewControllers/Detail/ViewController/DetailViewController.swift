//
//  DetailViewController.swift
//  Arak
//
//  Created by Abed Qassim on 27/02/2021.
//

import UIKit
import AVKit
class DetailViewController: UIViewController {
    
    private var id: Int = -1
    private var viewModel = DetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func confige(id: Int?) {
        self.id = id ?? -1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hiddenNavigation(isHidden: false)
        clearItemsBar()
        self.navigationController?.navigationBar.transparentNavigationBar()
        addBarItem(itemPostion: .Left, icon: #imageLiteral(resourceName: "closeButton"), tintColor: .black, isLogo: false, tag: 1, badgeCount: 0, leftCount: 0)
        fetchDetail()
    }
    
    
    override func leftTapped(itemBar: UIBarButtonItem) {
        navigationController?.popToViewController(ofClass: BubbleTabBarController.self)
    }
    
    private func fetchDetail() {
        showLoading()
        viewModel.adsDetail(id: id) { [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            self?.loadDetailView()
        }
    }
    
    private func whatsapp(number:String,isMe: Bool) {
        if isMe {
            showToast(message: "You cannot start chatting because the ad is for your ".localiz())
            return
        }
        if number.isEmpty {
            return
        }
        let urlWhats = "whatsapp://send?phone=\(number)"
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
                    self.showalert(title: "Please Install Whatsapp".localiz(), message: "", okTitleButton: "Done".localiz(), cancelTitleButton: "")
                }
            }
        }
        
    }
    private func loadDetailView() {
        
        title = viewModel.ad?.title ?? ""
        guard let detailView = Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)?.first as? DetailView else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        detailView.configeUI(ads: viewModel.ad,viewMode: .detail, viewController: self) { (action) in
            switch action {
            case .call(let phone):
                Helper.CellPhone(phone)
                break
            case .location(let lat , let lng):
                if let latDouble = Double(lat) , let lngDouble = Double(lng) {
                    Helper.OpenMap(latDouble, lngDouble)
                }
                break
            case .website(let url):
                let vc = self.initViewControllerWith(identifier: WebViewViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! WebViewViewController
                vc.confige(title: "", path: url, processType: .Other)
                self.show(vc)
                break
            case .empty:
                break
            case .playVideo(let path):
                DispatchQueue.main.async {
                    if let videoURL = URL(string: path ?? "") {
                        let player = AVPlayer(url: videoURL)
                        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [])
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        self.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                }
                
                break
            case .checkout:
                break
            case .viewFullScreen:
                let vc = self.initViewControllerWith(identifier: ImageSliderViewController.className, and: "") as! ImageSliderViewController
                vc.confige(imageNames: self.viewModel.adImages)
                self.show(vc)
            case .whatsapp(phone: let phone):
                self.whatsapp(number: phone, isMe: self.viewModel.ad?.isMe ?? false)
            case .favorite(id: let id):
                self.Favorite(id: id,isFavorate: !(self.viewModel.ad?.isFav ?? false))
            case .backToHome:
                self.navigationController?.popToViewController(ofClass: BubbleTabBarController.self)
            }
        }
        self.view.addSubview(detailView)
        detailView.bounds = self.view.frame
        
        detailView.center = self.view.center
    }
    
    func submiteReview(context: String, rating: Int) {
        self.showLoading()
        viewModel.submitReview(review: context, rate: rating, ad_id: id) { [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            
            self?.fetchDetail()
        }
    }
    
    func deleteReview(id: Int) {
        viewModel.deleteReview(reviewId: id) { [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            
            self?.fetchDetail()
        }
    }
    
    private func Favorite(id: Int,isFavorate: Bool) {
        showLoading()
        viewModel.favorite(id: id, isFavorate: isFavorate) { [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            self?.fetchDetail()
        }
    }
    
}
