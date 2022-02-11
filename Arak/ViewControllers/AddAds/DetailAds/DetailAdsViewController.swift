//
//  DetailAdsViewController.swift
//  Arak
//
//  Created by Abed Qassim on 27/02/2021.
//

import UIKit  
import FSPagerView
import BSImagePicker
import Photos
import AVKit
class DetailAdsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var companyStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var websiteStackView: UIStackView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var individualButton: UIButton!
    @IBOutlet weak var slider: FSPagerView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var contactView: UIView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var typeAdsView: UIView!
    
    private var imagePicker = UIImagePickerController()
    private var mediaList: [UIImage] = []
    private var videoUrl: URL?
    private var categoryType: AdsTypes = .image
    private var adCategory: AdsCategory?
    private var packageSelect: Package?
    private var error = ""
    private var typeAds = 1 // 1 for individual , 2 company
    private var currentLocation:CLLocation?
    private var currentLocatioTitle:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.coloredNavigationBar()
        
    }
    
    private func setup() {
        self.setupHideKeyboardOnTap()
        // phoneNumberStackView.semanticContentAttribute = .forceLeftToRight
        phoneTextField.semanticContentAttribute = .forceLeftToRight
        phoneTextField.textAlignment = .left
        
        pageControl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        pageControl.addRoundedCorners(cornerRadius: 10)
        pageControl.transform = Helper.appLanguage ?? "en" == "ar" ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
        title = adCategory?.categoryTitle ?? ""
        if adCategory?.id == AdsTypes.image.rawValue {
            categoryType =  AdsTypes.image
            websiteStackView.isHidden = true
        }else if adCategory?.id == AdsTypes.video.rawValue {
            categoryType =  AdsTypes.video
            websiteStackView.isHidden = true
        }else if adCategory?.id == AdsTypes.videoWeb.rawValue {
            categoryType =  AdsTypes.videoWeb
            websiteStackView.isHidden = false
        }
        sliderView.addShadow(position: .all)
        infoView.addShadow(position: .all)
        typeAdsView.addShadow(position: .all)
        contactView.addShadow(position: .all)
        continueButton.addShadow(position: .all)
        phoneTextField.setRightImage(image: #imageLiteral(resourceName: "edit"))
        locationTextField.setRightImage(image: #imageLiteral(resourceName: "Pin"))
        websiteTextField.setRightImage(image: #imageLiteral(resourceName: "world-wide-web"))
        
        companyTextField.addDoneButtonOnKeyboard()
        titleTextField.addDoneButtonOnKeyboard()
        descriptionTextView.addDoneButtonOnKeyboard()
        websiteTextField.addDoneButtonOnKeyboard()
        phoneTextField.addDoneButtonOnKeyboard()
        loclization()
        setupDescription()
        setupSlider()
        typeAds = 1
        companyStackView.isHidden = true
        
        
    }
    
    private func setupDescription() {
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.text = "Description".localiz()
        descriptionTextView.textAlignment()
        descriptionTextView.delegate = self
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            descriptionTextView.text = "Description".localiz()
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    private func loclization() {
        companyButton.setTitle("Company".localiz(), for: .normal)
        individualButton.setTitle("Individual".localiz(), for: .normal)
        companyTextField.placeholder = "Company Name".localiz()
        
        descriptionTextView.text = "Description".localiz()
        continueButton.setTitle("Continue".localiz(), for: .normal)
        titleTextField.placeholder = "Title".localiz()
        let phoneNo = Helper.currentUser?.phoneNo ?? ""
        phoneTextField.text = phoneNo.replacingOccurrences(of: "+962", with: "")
        locationTextField.text = ""
        
    }
    func confige(adCategory: AdsCategory?,packageSelect: Package?) {
        self.adCategory = adCategory
        self.packageSelect = packageSelect
        
    }
    
    private func setupSlider() {
        let nib = UINib(nibName: "UploadCell", bundle: Bundle.main)
        slider.register(nib, forCellWithReuseIdentifier: "cell")
        slider.automaticSlidingInterval = 0
        slider.transformer = FSPagerViewTransformer(type: .linear)
        slider.delegate = self
        slider.dataSource = self
        pageControl.hidesForSinglePage = true
    }
    @IBAction func PickLocation(_ sender: Any) {
        let vc = initViewControllerWith(identifier: MapViewController.className, and: "") as! MapViewController
        vc.configue {
        } confrimLocation: { (currentLocation, city) in
            self.currentLocation = currentLocation
            self.currentLocatioTitle = city
            self.locationTextField.text = city?.isEmpty ?? false == true ? "\(currentLocation?.coordinate.latitude ?? 0.0) ,\(currentLocation?.coordinate.longitude ?? 0.0) " : city ?? ""
        }
        show(vc)
        
    }
    
    @IBAction func Company(_ sender: Any) {
        typeAds = 2
        companyButton.setTitleColor(#colorLiteral(red: 0.1402117312, green: 0.2012455165, blue: 0.4366841316, alpha: 1), for: .normal)
        individualButton.setTitleColor(#colorLiteral(red: 0.1402117312, green: 0.2012455165, blue: 0.4366841316, alpha: 0.35), for: .normal)
        companyStackView.isHidden = false
    }
    
    @IBAction func Individual(_ sender: Any) {
        typeAds = 1
        companyButton.setTitleColor(#colorLiteral(red: 0.1402117312, green: 0.2012455165, blue: 0.4366841316, alpha: 0.35), for: .normal)
        individualButton.setTitleColor(#colorLiteral(red: 0.1402117312, green: 0.2012455165, blue: 0.4366841316, alpha: 1), for: .normal)
        companyStackView.isHidden = true
    }
    
    @IBAction func Continue(_ sender: Any) {
        if !valid() {
            self.showToast(message: error)
            return
        }
        
        var adsImages:[AdImage] = []
        var adsImagesPrepareing: [AdImagePrepare] = []
        
        if videoUrl != nil {
            if let cell:UploadCell = slider.cellForItem(at: 0) as? UploadCell  {
                videoUrl?.absoluteString.getDuration(compliation: { duration in
                    adsImages.append(AdImage(id: 0, path: self.videoUrl?.absoluteString, adID: -1, createdAt: nil, updatedAt: nil,thumbnilData: cell.photoImageView.image,duration: duration))
                    self.continueProcess(adsImagesPrepareing: adsImagesPrepareing, adsImages: adsImages)
                })
                
            } else {
                videoUrl?.absoluteString.getDuration(compliation: { duration in
                    adsImages.append(AdImage(id: 0, path: self.videoUrl?.absoluteString, adID: -1, createdAt: nil, updatedAt: nil,thumbnilData:UIImage(named: "Summery Image-2"),duration: duration))
                    self.continueProcess(adsImagesPrepareing: adsImagesPrepareing, adsImages: adsImages)
                })
            }
            
        } else {
            for index in 0...mediaList.count - 1 {
                adsImagesPrepareing.append(AdImagePrepare(id: index, path: mediaList[index]))
            }
            self.continueProcess(adsImagesPrepareing: adsImagesPrepareing, adsImages: adsImages)
        }
        
        
    }
    
    private func continueProcess(adsImagesPrepareing:[AdImagePrepare] , adsImages:[AdImage] ) {
        var totalAmount = ""
        totalAmount = "\(packageSelect?.price ?? 0) \("JOD".localiz())"
        
        let ads = Adverisment(id: -1, title: titleTextField.text, desc: descriptionTextView.text, lon: "\(currentLocation?.coordinate.longitude ?? 0.0)", lat: "\(currentLocation?.coordinate.latitude ?? 0.0)",locationTitle: locationTextField.text, phoneNo:  "+962" + (phoneTextField.text ?? ""), alternativePhoneNo: "\(packageSelect?.noOfImgs ?? 0)", companyName: companyTextField.text, adCategoryID: adCategory?.id, packageID: packageSelect?.id, userID: Helper.currentUser?.id, createdAt:  packageSelect?.seconds ?? "", updatedAt: packageSelect?.reach, duration: videoUrl != nil ? "\(adsImages.first?.duration ?? 5)" : "\(TimeInterval(((Int(self.packageSelect?.seconds ?? "1") ?? 1) )))",totalAmount: totalAmount, adImages: adsImages,adFileImagesPreparing: adsImagesPrepareing, websiteURL: websiteTextField.text)
        let vc = initViewControllerWith(identifier: SummaryViewController.className, and: "") as! SummaryViewController
        
        vc.confige(ads: ads)
        
        show(vc)
    }
    
    private func valid() -> Bool {
        error = ""
        if adCategory?.id != AdsTypes.video.rawValue {
            if mediaList.count == 0 {
                error = "Please Select one image at least".localiz()
                return error.isEmpty
            }
        } else {
            if videoUrl == nil {
                error = "Please Select video".localiz()
                return error.isEmpty
            }
        }
        
        if adCategory?.id == AdsTypes.videoWeb.rawValue {
            guard let website = websiteTextField.text else {
                error = "Please enter website".localiz()
                websiteTextField.becomeFirstResponder()
                return error.isEmpty
            }
            if website.validator(type: .Required) == .Required {
                error = "Please enter website".localiz()
                websiteTextField.becomeFirstResponder()
                return error.isEmpty
            }
            
            if !Helper.verifyUrl(urlString: website) {
                error = "Please enter valid url for website".localiz()
                websiteTextField.becomeFirstResponder()
                return error.isEmpty
            }
            
        }
        
        
        if typeAds == 2 {
            guard let companyName = companyTextField.text else {
                error = "Please enter company name".localiz()
                companyTextField.becomeFirstResponder()
                return error.isEmpty
            }
            if companyName.validator(type: .Required) == .Required {
                error = "Please enter company name".localiz()
                companyTextField.becomeFirstResponder()
                return error.isEmpty
            }
        }
        
        guard let title = titleTextField.text else {
            error = "Please enter title".localiz()
            titleTextField.becomeFirstResponder()
            return error.isEmpty
        }
        if title.validator(type: .Required) == .Required {
            error = "Please enter title".localiz()
            titleTextField.becomeFirstResponder()
            return error.isEmpty
        }
        guard let descripition = descriptionTextView.text else {
            error = "Please enter description".localiz()
            descriptionTextView.becomeFirstResponder()
            return error.isEmpty
        }
        if descripition.validator(type: .Required) == .Required {
            error = "Please enter description".localiz()
            descriptionTextView.becomeFirstResponder()
            return error.isEmpty
        }
        
        guard let phone = phoneTextField.text else {
            error = "Please insert your phone number".localiz()
            phoneTextField.becomeFirstResponder()
            return error.isEmpty
        }
        if phone.validator(type: .Required) == .Required {
            error = "Please insert your phone number".localiz()
            phoneTextField.becomeFirstResponder()
            return error.isEmpty
        }
        
        //      guard let location = locationTextField.text else {
        //        error = "Please insert location".localiz()
        //        locationTextField.becomeFirstResponder()
        //        return error.isEmpty
        //      }
        //      if location.validator(type: .Required) == .Required {
        //        error = "Please insert location".localiz()
        //        locationTextField.becomeFirstResponder()
        //        return error.isEmpty
        //      }
        
        
        return error.isEmpty
    }
    
}
extension DetailAdsViewController : FSPagerViewDelegate ,  FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if videoUrl != nil {
            return 1
        }
        return self.mediaList.count == (packageSelect?.noOfImgs ?? 1) ? self.mediaList.count : self.mediaList.count + 1
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as? UploadCell else {
            return FSPagerViewCell()
        }
        if videoUrl != nil {
            cell.setupVideo(type: .video, path: videoUrl) { (action) in
                switch action {
                case .upload:
                    break
                case .play:
                    let player = AVPlayer(url: self.videoUrl!)
                    try? AVAudioSession.sharedInstance().setCategory(.playback, options: [])
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        DispatchQueue.main.async {
                            playerViewController.player?.play()
                        }
                    }
                    break
                case .delete:
                    self.videoUrl = nil
                    self.pageControl.numberOfPages = 0
                    self.slider.reloadData()
                    break
                    
                }
            }
            
        }else {
            if index == mediaList.count {
                var buttonTitle = ""
                if adCategory?.id == AdsTypes.image.rawValue ||  adCategory?.id == AdsTypes.videoWeb.rawValue {
                    buttonTitle = "Upload Images".localiz()
                }else if adCategory?.id == AdsTypes.video.rawValue {
                    buttonTitle = "Upload Video".localiz()
                }
                cell.setup(type: .empty, title: buttonTitle, path: nil) { (action) in
                    switch action {
                    case .upload:
                        if self.categoryType != .video {
                            if self.packageSelect?.noOfImgs ?? 0 == 0 {
                                self.showToast(message: "The number of images in this package is 0 You cannot upload images".localiz())
                                return
                            }
                            self.fetchImages()
                        }else {
                            self.pickVideo()
                        }
                        break
                    case .play:
                        break
                    case .delete:
                        break
                    }
                }
            }else {
                cell.setup(type: .image, title: "", path: mediaList[index]) { (action) in
                    switch action {
                    case .upload:
                        if self.categoryType != .video {
                            if self.packageSelect?.noOfImgs ?? 0 == 0 {
                                self.showToast(message: "The number of images in this package is 0 You cannot upload images".localiz())
                                return
                            }
                            self.fetchImages()
                        }
                        break
                    case .play:
                        break
                    case .delete:
                        if index < self.mediaList.count {
                            self.mediaList.remove(at: index)
                            self.pageControl.numberOfPages = self.mediaList.count == (self.packageSelect?.noOfImgs ?? 1) ? self.mediaList.count : self.mediaList.count + 1
                            self.slider.reloadData()
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pageControl.currentPage = index
    }
    
    func pickVideo() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
            print("Galeria Video")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.videoQuality = .typeMedium
            imagePicker.videoExportPreset = AVAssetExportPresetMediumQuality
            imagePicker.allowsEditing = true
            imagePicker.videoMaximumDuration = TimeInterval(((Int(self.packageSelect?.seconds ?? "1") ?? 1)))
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func fetchImages() {
        let imagePicker = ImagePickerController()
        let settings = Settings()
        settings.selection.max = (self.packageSelect?.noOfImgs ?? 1)
        settings.selection.min = 1
        imagePicker.settings = settings
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            
            self.mediaList = self.getAssetThumbnail(assets: assets)
            self.pageControl.numberOfPages = self.mediaList.count == (self.packageSelect?.noOfImgs ?? 1) ? self.mediaList.count : self.mediaList.count + 1
            self.slider.reloadData()
        })
    }
    
    func getAssetThumbnail(assets: [PHAsset]) -> [UIImage] {
        var arrayOfImages = [UIImage]()
        for asset in assets {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            manager.requestImageData(for: asset, options: option) { (data, error, option,itemOption) in
                if let data = data ,  let image = UIImage(data: data) {
                    arrayOfImages.append(image)
                }
            }
        }
        
        return arrayOfImages
    }
    
    
}
extension DetailAdsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let movieUrl = info[.mediaURL] as? URL else { return }
        self.videoUrl = movieUrl
        VideoEncode.sheard.encodeVideo(at: movieUrl, completionHandler: { url,error  in
            DispatchQueue.main.async {
                if error != nil {
                    self.videoUrl = movieUrl
                }else if url != nil{
                    self.videoUrl = url
                }
                self.slider.reloadData()
            }
            
        })
        self.slider.reloadData()
        // work with the video URL
    }
}

