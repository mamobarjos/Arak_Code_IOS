//
//  CliQViewController.swift
//  Arak
//
//  Created by Osama Abu Hdba on 01/08/2024.
//

import UIKit

class CliQViewController: UIViewController {

    @IBOutlet weak var uploadImageLabel: UILabel!
    @IBOutlet weak var uploadedImageView: UIImageView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    public var ads:Adverisment?
    public var type: Int = 3
    private var imagePicker = UIImagePickerController()
    private(set) var imageData: Data?
    private(set) var imageUrl: String?
    
    let viewModel = CheckoutViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountLabel.text = "\(ads?.totalAmount ?? "")"
        totalAmountTextField.placeholder = "Total Amount".localiz()
        uploadedImageView.contentMode = .scaleToFill
        aliasTextField.text = "ARAKCO"
        amountTextField.placeholder = "Amount".localiz()
        uploadImageLabel.text = "upload receipt of transaction".localiz()
        saveButton.setTitle("Save".localiz(), for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
    }
    
    func copyTextToClipboard(text: String) {
           UIPasteboard.general.string = text
        showToast(message: "Alias copied".localiz())
       }

    @IBAction func saveButttonAction(_ sender: Any) {
        guard let imageUrl = imageUrl else {
            showToast(message: "Please upload receipt of transaction")
            return
        }
        
        guard let amount = amountTextField.text else {
            return
        }
        
        if amount.isEmpty {
            showToast(message: "Enter Amount".localiz())
            return
        }
        
        viewModel.createCliQTransaction(amount: amount, imageURL: imageUrl) {[weak self] error in
            if error != nil {
                self?.showToast(message: error)
                return
            }
            
            self?.uploadData()
        }
        
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
                        self?.type = 3
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
        data["duration"] =  Int(Double(ads?.duration ?? "0") ?? 0)
        
        
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

    @IBAction func uploadImageAction(_ sender: Any) {
        fetchImage()
    }
    
    @IBAction func coppyAliasButtonAction(_ sender: Any) {
        copyTextToClipboard(text: aliasTextField.text!)
    }
}

extension CliQViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {

            uploadedImageView.image = image
            imageData = image.jpegData(compressionQuality: 0.8)
            uploadToImageFirebase()

        }else if let image = info[.originalImage] as? UIImage {
            uploadedImageView.image = image
            imageData = image.jpegData(compressionQuality: 0.8)
            uploadToImageFirebase()
        }
    }

    func fetchImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
            print("Galeria Image")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
            imagePicker.mediaTypes = ["public.image"]
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
        }
    }

    private func uploadToImageFirebase() {
        showLoading()
        let url = (Helper.currentUser?.imgAvatar ?? "")
        if url.contains("firebasestorage") {
            UploadMedia.deleteMedia(dataArray: [url]) {
                self.compliationUpload()
            }
        } else {
            self.compliationUpload()
        }
    }

    private func compliationUpload() {
        let userId = Helper.currentUser?.id ?? -1
        if userId != -1  && imageData != nil {
            let id = "\(userId)"
            UploadMedia.saveImages(userId: id, imagesArray: [UIImage(data: imageData!)], completionHandler: { [weak self] url in
                if let firstUrl: String = url.first {
                    self?.imageUrl = firstUrl
                    self?.stopLoading()
                }
            })
        }
    }
}
