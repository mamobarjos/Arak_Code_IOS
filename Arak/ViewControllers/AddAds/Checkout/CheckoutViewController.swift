//
//  CheckoutViewController.swift
//  Arak
//
//  Created by Abed Qassim on 28/02/2021.
//

import UIKit
var Ad_category_id: Int = 4
var Ad_package_id: Int = 1
var package_Price: String = ""
var package_reach: Int = 1

class CheckoutViewController: UIViewController {
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var myWalletLabel: UILabel!
//    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var doublePaymentView: UIView!
    @IBOutlet weak var doublePaymentLabel: UILabel!
    
    
    
    @IBOutlet weak var walletArrowImageView: UIImageView!
    @IBOutlet weak var cardArrowImageView: UIImageView!
    @IBOutlet weak var cliQArrowImageView: UIImageView!
    private var viewModel: CheckoutViewModel = CheckoutViewModel()
  private var ads:Adverisment?
  private var error = ""
  private var type = 1 //0 wallet , 1 visa , 2 both

  override func viewDidLoad() {
    super.viewDidLoad()
//      cardView.isHidden = true
  }
  func confige(ads:Adverisment?)  {
    self.ads = ads
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      hiddenNavigation(isHidden: false)
    setup()
  }

  private func setup() {
    loclization()
    setupUI()
  }

  private func setupUI()  {
//    cardView.addShadow(position: .all)
//    walletView.addShadow(position: .all)
  }

    
  
  private func loclization() {
    title = "Checkout".localiz()
    myWalletLabel.text = "My Wallet".localiz()
    doublePaymentLabel.text = "CLIQ".localiz()
    cardLabel.text = "Card".localiz()
      
      if Helper.appLanguage != "en" {
          [walletArrowImageView, cardArrowImageView, cliQArrowImageView].forEach { image in
              image?.transform = .init(scaleX: -1, y: 1)
          }
      }
  }

  @IBAction func MyWallet(_ sender: Any) {
    type = 0
    let vc = initViewControllerWith(identifier: WallatPayViewController.className, and: "My Wallet".localiz()) as! WallatPayViewController
    vc.confige(ads: ads)
    show(vc)

  }
    
    @IBAction func cardButtonAction(_ sender: Any) {
        type = 1
        uploadData()
    }
    
    
    @IBAction func DoublePayment(_ sender: Any) {
        let vc = initViewControllerWith(identifier: CliQViewController.className, and: "CliQ".localiz()) as! CliQViewController
        vc.ads = ads
        show(vc)
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
                data["payment_type"] = "CARD"
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

      data["payment_type"] = "CARD"
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
