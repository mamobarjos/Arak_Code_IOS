//
//  WallatPayViewController.swift
//  Arak
//
//  Created by Abed Qassim on 09/06/2021.
//

import UIKit

class WallatPayViewController: UIViewController {
    @IBOutlet weak var earningValueLabel: UILabel!
    @IBOutlet weak var earningLabel: UILabel!
    @IBOutlet weak var earningView: UIView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var totalAmountValueLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cartDetailLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numbleValueLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var reachValueLabel: UILabel!
    @IBOutlet weak var reachLabel: UILabel!
    @IBOutlet weak var adsTypeValueLabel: UILabel!
    @IBOutlet weak var adsTypeLabel: UILabel!
    
    private var ads:Adverisment?
    private var viewModel: CheckoutViewModel = CheckoutViewModel()
    private var type: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
    }
    
    func confige(ads:Adverisment?)  {
        self.ads = ads
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBalance()
    }
    
    private func getBalance() {
        fetchBalance { error in
            if error == nil {
                self.earningValueLabel.text = "\(Helper.currentUser?.balanceTitle ?? "")"
            }
        }
    }
    
    private func localization() {
        earningLabel.text = "Earning".localiz()
        earningView.addShadow(position: .all)
        if ads?.adCategoryID == AdsTypes.image.rawValue {
            adsTypeValueLabel.text = "Image ads".localiz()
        }else if ads?.adCategoryID == AdsTypes.video.rawValue {
            adsTypeValueLabel.text = "Video ads".localiz()
        }else if ads?.adCategoryID == AdsTypes.videoWeb.rawValue {
            adsTypeValueLabel.text = "Website ads".localiz()
        }else if ads?.adCategoryID == AdsTypes.store.rawValue {
            adsTypeValueLabel.text = "Store ads".localiz()
        } else if ads == nil {
            adsTypeValueLabel.text = "Store ads".localiz()
        }
        
        adsTypeLabel.text = "Ads Type".localiz()
        reachLabel.text = "Reach".localiz()
        numberLabel.text = "Number".localiz()
        timeLabel.text = "Time".localiz()
        cartDetailLabel.text = "Cart Details".localiz()
        totalAmountLabel.text = "Total Amount".localiz()
        reachValueLabel.text = ads?.updatedAt ?? ""
        numbleValueLabel.text = ads?.alternativePhoneNo ?? ""
        timeValueLabel.text = ads?.createdAt ?? ""
        totalAmountValueLabel.text = ads?.totalAmount ?? ""
        payButton.setTitle("Pay".localiz() + " \(ads?.totalAmount ?? "")", for: .normal)
        
        if ads == nil {
            reachValueLabel.text = "\(package_reach)"
            totalAmountValueLabel.text = "\(package_Price)" + " " + (Helper.currencyCode ?? "JOD")
            numbleValueLabel.text = "1"
            timeLabel.isHidden = true
        }
        
    }
    
    @IBAction func Pay(_ sender: Any) {
        uploadData()
    }
    
    func completeUpload(data: [String : Any]) {
        viewModel.addAds(data: data) { [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            if error != nil {
                self?.showToast(message: error)
                return
            }
            if self?.viewModel.walletInsufficient ?? false {
                let vc = self?.initViewControllerWith(identifier: WalletInsufficientViewController.className, and: "") as! WalletInsufficientViewController
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.confige { [weak self] confirmed in
                    vc.dismiss(animated: true, completion: nil)
                    if confirmed {
                        self?.type = 2
                        self?.uploadData()
                    } else {
//                        self?.resetRequest(data: data)
                    }
                   
                }
                self?.present(vc, animated: true, completion: nil)
            } else {
                if self?.viewModel.url.isEmpty ?? false {
                    let vc = self?.initViewControllerWith(identifier: SuccessCheckoutViewController.className, and: "") as! SuccessCheckoutViewController
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.confige(title: "Success".localiz(), description: "Your ad will be post soon.".localiz(), goString: "Go to My Ads".localiz()) {
                        vc.dismiss(animated: true, completion: nil)
                        self?.navigationController?.popToViewController(ofClass: BubbleTabBarController.self)
                        NewHomeViewController.goToMyAds = true
                    }
                    self?.present(vc, animated: true, completion: nil)
                } else {
                    let vc = self?.initViewControllerWith(identifier: WebViewViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! WebViewViewController
                    vc.confige(title: "", path:self?.viewModel.url ?? "" , processType: .Payment, imageFirebasePath: "")
                    self?.show(vc)
                }
            }
        }
    }
    
    private func resetRequest(data: [String :Any]) {
        if (ads?.adImages?.count ?? 0 != 0) {
            if let urlString = ads?.adImages?.first?.path  {
                UploadMedia.deleteMedia(dataArray: [urlString]) { [weak self] in
                    self?.navigationController?.popToViewController(ofClass: HomeViewController.self)
                }
            }
        } else {
            
            self.navigationController?.popToViewController(ofClass: BubbleTabBarController.self)
        }
    }
    
    func uploadData() {
        if ads == nil { // then it's Store
           
            showLoading()
            viewModel.getUserStore {[weak self] error in
                guard let self else {return}
                if error != nil {
                    self.showToast(message: error)
                    self.stopLoading()
                  return
                }
                
                var data: [String : Any] = [:]
                data["payment_type"] = "WALLET"
                data["ad_category_id"] = Ad_category_id
                data["ad_package_id"] = Ad_package_id
                data["store_id"] = Helper.store?.id ?? 0
                self.viewModel.addStoreAds(data: data) { [weak self] (error) in
                    defer {
                        self?.stopLoading()
                    }
                    if error != nil {
                        self?.showToast(message: error)
                        return
                    }
                    if self?.viewModel.url.isEmpty ?? false {
                        let vc = self?.initViewControllerWith(identifier: SuccessCheckoutViewController.className, and: "") as! SuccessCheckoutViewController
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.modalTransitionStyle = .crossDissolve
                        vc.confige(title: "Success".localiz(), description: "Your ad will be post soon.".localiz(), goString: "Go to My Ads".localiz()) {
                            vc.dismiss(animated: true, completion: nil)
                            self?.navigationController?.popToViewController(ofClass: BubbleTabBarController.self)
                            NewHomeViewController.goToMyAds = true
                        }
                        self?.present(vc, animated: true, completion: nil)
                    } else {
                        let vc = self?.initViewControllerWith(identifier: WebViewViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! WebViewViewController
                        vc.confige(title: "", path:self?.viewModel.url ?? "" , processType: .Payment, imageFirebasePath: "")
                        self?.show(vc)
                    }
                }
            }
            
            return
        }
        
      showLoading()
      var data: [String : Any] = [:]

      data["payment_type"] = "WALLET"
      data["title"] = ads?.title ?? ""
      data["description"] = ads?.desc ?? ""
      data["phone_no"] = ads?.phoneNo ?? ""
      data["alternative_phone_no"] = ""
      data["lon"] = ads?.lon ?? ""
      data["lat"] = ads?.lat ?? ""
      data["ad_category_id"] = ads?.adCategoryID
      data["ad_package_id"] = ads?.adPackageID
        data["website_url"] = ads?.websiteURL
          if ads?.websiteURL?.isEmpty == true || ads?.websiteURL == nil {
              data["website_url"] = "https://example.com"
          }
//      data["type"] = type
      data["duration"] = Int(Double(ads?.duration ?? 0))

        var adFiles: [[String:String]] = []
      if (ads?.adImages?.count ?? 0 != 0) {
        if let urlString = ads?.adImages?.first?.path , let url = URL(string: urlString) , let userId = Helper.currentUser?.id, let thumbnilUIImage = ads?.adImages?.first?.thumbnilData {

          UploadMedia.uploadVideo(userId: "\(userId)", videoURL: url) { (firebasePath) in
//            data["files[0][url]"] = firebasePath
              adFiles.append(["url":firebasePath])
              data["ad_files"] = adFiles
            self.uploadThumbnil(thumbnilUIImage, data: data)
          }

        }
      } else if let imageAds = (ads?.adFileImagesPreparing) , imageAds.count != 0 , let userId = Helper.currentUser?.id {
        let imageArray:[UIImage?] = imageAds.map { (obj) -> UIImage? in
          return obj.path
        }
        UploadMedia.saveImages(userId: "\(userId)", imagesArray: imageArray) { (urlsPath) in
          for index in 0...urlsPath.count - 1 {
              adFiles.append(["url":urlsPath[index]])
              data["ad_files"] = adFiles
//            data["files[\(index)][url]"] = urlsPath[index]
          }
          self.completeUpload(data: data)
        }
      }
    }
    
    private func uploadThumbnil(_ thumbnil: UIImage?,data:[String : Any] ) {
        var continueData = data
        if let userId = Helper.currentUser?.id {
            let imageArray:[UIImage?] = [thumbnil]
            UploadMedia.saveImages(userId: "\(userId)", imagesArray: imageArray) { (urlsPath) in
                for index in 0...urlsPath.count - 1 {
                    continueData["thumb_url"] = urlsPath[index]
                    self.completeUpload(data: continueData)
                }
                
            }
        }
        
    }
    
    
}
