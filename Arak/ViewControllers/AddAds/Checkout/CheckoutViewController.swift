//
//  CheckoutViewController.swift
//  Arak
//
//  Created by Abed Qassim on 28/02/2021.
//

import UIKit

class CheckoutViewController: UIViewController {
  @IBOutlet weak var cardLabel: UILabel!
  @IBOutlet weak var myWalletLabel: UILabel!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var walletView: UIView!
  @IBOutlet weak var doublePaymentView: UIView!
  @IBOutlet weak var doublePaymentLabel: UILabel!
    
  private var viewModel: CheckoutViewModel = CheckoutViewModel()
  private var ads:Adverisment?
  private var error = ""
  private var type = 1 //0 wallet , 1 visa , 2 both

  override func viewDidLoad() {
    super.viewDidLoad()

  }
  func confige(ads:Adverisment?)  {
    self.ads = ads
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setup()
  }

  private func setup() {
    loclization()
    setupUI()
  }

  private func setupUI()  {
    cardView.addShadow(position: .all)
    walletView.addShadow(position: .all)
  }

    
  
  private func loclization() {
    title = "Checkout".localiz()
    myWalletLabel.text = "My Wallet".localiz()
    doublePaymentLabel.text = "Double Payment".localiz()
    cardLabel.text = "Card".localiz()
  }

  @IBAction func MyWallet(_ sender: Any) {
    type = 0
    let vc = initViewControllerWith(identifier: WallatPayViewController.className, and: "My Wallet".localiz()) as! WallatPayViewController
    vc.confige(ads: ads)
    show(vc)

  }
  @IBAction func Card(_ sender: Any) {
    type = 1
    uploadData()
  }
    
    @IBAction func DoublePayment(_ sender: Any) {
        let vc = initViewControllerWith(identifier: WalletInsufficientViewController.className, and: "") as! WalletInsufficientViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.confige(confirmBlock: { confirm in
            vc.dismiss(animated: true, completion: nil)
            if confirm {
                self.type = 2
                self.uploadData()
            }
        },title: "Payment combined".localiz(), description: "In this type, payment using wallet and credit card is combined. Would you like to continue?".localiz(), buttonTitle: "Continue".localiz())
        self.present(vc, animated: true, completion: nil)
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
                HomeViewController.goToMyAds = true
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
        
      showLoading()
      var data: [String : Any] = [:]

      data["title"] = ads?.title ?? ""
      data["desc"] = ads?.desc ?? ""
      data["phone_no"] = ads?.phoneNo ?? ""
      data["alternative_phone_no"] = ""
      data["company_name"] = ads?.companyName ?? ""
      data["lon"] = ads?.lon ?? ""
      data["lat"] = ads?.lat ?? ""
      data["ad_category_id"] = ads?.adCategoryID
      data["package_id"] = ads?.packageID
      data["website_url"] = ads?.websiteURL ?? ""
      data["type"] = type
      data["duration"] = Int(Double(ads?.duration ?? "0") ?? 0)


      if (ads?.adImages?.count ?? 0 != 0) {
        if let urlString = ads?.adImages?.first?.path , let url = URL(string: urlString) , let userId = Helper.currentUser?.id, let thumbnilUIImage = ads?.adImages?.first?.thumbnilData {

          UploadMedia.uploadVideo(userId: "\(userId)", videoURL: url) { (firebasePath) in
            data["files[0][url]"] = firebasePath
            self.uploadThumbnil(thumbnilUIImage, data: data)
          }

        }
      } else if let imageAds = (ads?.adFileImagesPreparing) , imageAds.count != 0 , let userId = Helper.currentUser?.id {
        let imageArray:[UIImage?] = imageAds.map { (obj) -> UIImage? in
          return obj.path
        }
        UploadMedia.saveImages(userId: "\(userId)", imagesArray: imageArray) { (urlsPath) in
          for index in 0...urlsPath.count - 1 {
            data["files[\(index)][url]"] = urlsPath[index]
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
