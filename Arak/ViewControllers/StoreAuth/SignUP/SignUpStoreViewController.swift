//
//  SignUpStoreViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 18/02/2022.
//

import UIKit
import CoreLocation
import Kingfisher

enum StoreMode {
    case add
    case edit
}

class SignUpStoreViewController: UIViewController {

    enum ImageType {
        case personalPhoto
        case coverPhoto
    }

    @IBOutlet weak var uploadCoverphotoLabel: UILabel!
    @IBOutlet weak var storeInformationLabel: UILabel!
    @IBOutlet weak var pickPhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!

    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var storeDesTextField: UITextView!
   
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!

    @IBOutlet weak var addSocialMediaLinksButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var chooseCategoryView: UIView!
    @IBOutlet weak var categoryName: UITextField!

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var chooseCategoryButton: UIButton!
    private var imagePicker = UIImagePickerController()
    private var currentLocation: CLLocation?
    private var currentLocatioTitle: String?
    
    @IBOutlet weak var linkedInView: UIView!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var instaView: UIView!
    @IBOutlet weak var youtubeView: UIView!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var twitterView: UIView!
    
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var instaTextField: UITextField!
    @IBOutlet weak var YouTubeTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var linkidInTextField: UITextField!
    @IBOutlet weak var phoneExtentionButton: UIButton!
    
    
    private(set) var imageData: Data?
    private(set) var imageUrl: String?
    private(set) var coverImageData: Data?
    private(set) var coverImageUrl: String?
    private(set) var categoryId: Int?
    private(set) var imageType: ImageType = .personalPhoto

    var availbleSocialMedia: Set<SocialMediaType> = []
    public var mode: StoreMode = .add
    private var viewModel = CreateStoreViewModel()
    
    private var countryPickerView = ToolbarPickerView()
    private var cityPickerView = ToolbarPickerView()
    
    var countryId = -1
    var cityId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeDesTextField.delegate = self
        companyNameTextField.placeholder = "placeHolder.Company Name".localiz()
        storeDesTextField.text = "placeHolder.Description".localiz()
        categoryName.text = "title.Choose Store Category".localiz()
        websiteTextField.placeholder = "placeHolder.Website".localiz()
        phoneNumberTextField.placeholder = "placeHolder.Phone Number".localiz()
        locationTextField.placeholder = "placeHolder.Location".localiz()
        submitButton.setTitle("action.Continue".localiz(), for: .normal)
        uploadCoverphotoLabel.text = "Upload Cover Image".localiz()
        uploadCoverphotoLabel.font = .font(for: .bold, size: 16)
        storeInformationLabel.text = "Store Information".localiz()
        addSocialMediaLinksButton.setTitle("Add social link".localiz(), for: .normal)
        cityTextField.placeholder = "City".localiz()
        
       
        setupPickerView()
        storeDesTextField.textAlignment = Helper.appLanguage ?? "en" == "en" ? .left : .right
        if Helper.appLanguage ?? "en" == "en" {
            self.chooseCategoryButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        } else {
            self.chooseCategoryButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        }


        chooseCategoryView.addTapGestureRecognizer {[weak self] in
            let vc = CategoriesViewController()
            vc.delegate = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        coverImageView.contentMode = .center
        imageView.contentMode = .scaleToFill

        if mode == .edit {
            fillViewWithData()
        }
        
        getCountry()
        getCity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: true)
    }

    private func setupPickerView() {
        countryTextField.inputView = countryPickerView
        countryTextField.delegate = self
        countryPickerView.toolbarDelegate = self
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryTextField.inputAccessoryView = countryPickerView.toolbar
        
        cityTextField.inputView = cityPickerView
        cityTextField.delegate = self
        cityPickerView.toolbarDelegate = self
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        cityTextField.inputAccessoryView = cityPickerView.toolbar
    }
    
    private func getCity() {
        viewModel.getCity(by: countryId) {[weak self] _ in
            guard let self else { return }
            self.cityTextField.text = viewModel.cityList.first(where: {$0.id ?? 1 == Helper.currentUser?.cityID})?.name
            self.cityPickerView.reloadAllComponents()
        }
    }
    
    private func getCountry() {
        viewModel.getCountry { [weak self] _ in
            guard let self else {return}
          countryTextField.text = viewModel.countryList.first(where: {$0.id ?? 1 == Helper.currentUser?.countryID})?.name
            phoneExtentionButton.setTitle( viewModel.countryList.first(where: {$0.id ?? 1 == Helper.currentUser?.countryID})?.countryCode, for: .normal)
            self.countryPickerView.reloadAllComponents()
            getCity()
      }
    }

    
    private func fillViewWithData() {
        guard let store = Helper.store else {
            self.showToast(message:"Error Can't find your store")
            return
        }

        if let coverUrl = URL(string:store.cover ?? "") {
            self.coverImageUrl = store.cover
            coverImageView.kf.setImage(with: coverUrl, placeholder: UIImage(named: "Summery Image"))
        }

        if let imageUrl = URL(string:store.img ?? "") {
            self.imageUrl = store.img
            imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "Summery Image"))
        }

        companyNameTextField.text = store.name
        storeDesTextField.text = store.desc
        websiteTextField.text = store.website
        phoneNumberTextField.text = store.phoneNo
        locationTextField.text = store.locationName
        categoryName.text = "Current Category: " + "\(store.storeCategory?.name ?? "")"
        categoryId = store.storeCategory?.id
        countryId = store.countryID ?? 1
        currentLocatioTitle = "\(store.lat ?? "") , \(store.lon ?? "")"
        let phoneNo = Helper.currentUser?.phoneNo ?? ""
        phoneNumberTextField.text = phoneNo.replacingOccurrences(of: "+962", with: "")
              
        if store.website?.isEmpty == false {
            websiteView.isHidden = false
            websiteTextField.text = store.website
        }
        
        if store.linkedin?.isEmpty == false {
            linkedInView.isHidden = false
            linkidInTextField.text = store.linkedin
        }
        
        if store.instagram?.isEmpty == false {
            instaView.isHidden = false
            instaTextField.text = store.instagram
        }
        
        if store.youtube?.isEmpty == false {
            youtubeView.isHidden = false
            YouTubeTextField.text = store.youtube
        }
        
        if store.facebook?.isEmpty == false {
            facebookView.isHidden = false
            facebookTextField.text = store.facebook
        }
        
        if store.x?.isEmpty == false {
            twitterView.isHidden = false
            twitterTextField.text = store.x
        }
    
        currentLocation = CLLocation(
            latitude: Double(store.lat ?? "") ?? 0.0,
            longitude: Double(store.lon ?? "") ?? 0.0)

    }
    
    @IBAction func addSocialButtonAction(_ sender: Any) {
        let vc = initViewControllerWith(identifier: AvailableSucialMediaViewController.className, and: "", storyboardName: Storyboard.storeAuth.rawValue) as! AvailableSucialMediaViewController
        vc.selectedSocialMedia = self.availbleSocialMedia
        vc.delegate = self
        self.present(vc)
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func locatioAction(_ sender: Any) {
        let vc = initViewControllerWith(identifier: MapViewController.className, and: "") as! MapViewController
        vc.configue {
        } confrimLocation: { (currentLocation, city) in
            self.currentLocation = currentLocation
            self.currentLocatioTitle = city
            self.locationTextField.text = city?.isEmpty ?? false == true ? "\(currentLocation?.coordinate.latitude ?? 0.0) ,\(currentLocation?.coordinate.longitude ?? 0.0) " : city ?? ""
        }
        show(vc)
    }
    @IBAction func picPhotoAction(_ sender: Any) {
        imageType = .personalPhoto
        fetchImage()
    }

    @IBAction func coverPhotoAction(_ sender: Any) {
        imageType = .coverPhoto
        fetchImage()
    }

    @IBAction func submitAction(_ sender: Any) {
        guard let content = validateContent() else {
            return
        }
        
        self.showLoading()
        if mode == .add {
        viewModel.createStore(data: content, compliation: { [weak self] error in
            defer {
                self?.stopLoading()
            }
            if error != nil {
                self?.showToast(message: error)
                return
            }
            
            
            let vc = self?.initViewControllerWith(identifier: CongretsStoreViewController.className, and: "", storyboardName: Storyboard.storeAuth.rawValue) as! CongretsStoreViewController
            Helper.currentUser?.hasStore = true
            
            self?.show(vc)
        })
        } else {
            viewModel.updateStore(id: Helper.store?.id ?? -1, data: content, compliation: { [weak self] error in
                defer {
                    self?.stopLoading()
                }
                if error != nil {
                    self?.showToast(message: error)
                    return
                }
                self?.showToast(message: "Your Store Updated Successfully")
                for controller in (self?.navigationController!.viewControllers ?? []) as Array {
                    if controller.isKind(of: StoreViewController.self) {
                        self?.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            })
        }
    }

    private func validateContent() -> [String:Any]? {
        guard let companyName = companyNameTextField.text else {
            self.showToast(message: "error.Please Enter Store Name".localiz())
            return nil
        }
        guard let description = storeDesTextField.text else {
            self.showToast(message: "error.Please Enter Store Description".localiz())
            return nil
        }

        if storeDesTextField.text == "Description" {
            self.showToast(message: "error.Please Enter Store Description".localiz())
            return nil
        }

        guard let phoneNumber = phoneNumberTextField.text else {
            self.showToast(message: "error.Please Enter Store Phone Number".localiz())
            return nil
        }
        
        if phoneNumber.isEmpty {
            self.showToast(message: "error.Please Enter Store Phone Number".localiz())
            return nil
        }
        
//        guard let currentLocation = currentLocation else {
//            self.showToast(message: "error.Please Enter your Store Location".localiz())
//            return nil
//        }

        guard let categoryId = categoryId else {
            self.showToast(message: "error.Please Choose Store Category Type".localiz())
            return nil
        }

        guard let imageUrl = imageUrl else {
            self.showToast(message: "error.Please Add Your Store Image".localiz())
            return nil
        }

        guard let coverImageUrl = coverImageUrl else {
            self.showToast(message: "error.Please Add Your Store Cover Image".localiz())
            return nil
        }



        let lat = currentLocation?.coordinate.latitude
        let lon = currentLocation?.coordinate.longitude
        let validePhone = (phoneExtentionButton.titleLabel?.text ?? "+962") + phoneNumber
        
        let data: [String: Any] = [
            "name":companyName,
            "description":description,
            "phone_no": validePhone,
            "store_category_id":categoryId,
            "lon":"\(lon ?? 0)",
            "lat":"\(lat ?? 0)",
            "img_url":imageUrl,
            "cover_img_url":coverImageUrl,
            "website":websiteTextField.text ?? "",
            "facebook":"\(facebookTextField.text ?? "")",
            "x":"\(twitterTextField.text ?? "")",
            "instagram":"\(instaTextField.text ?? "")",
            "linkedin":"\(linkidInTextField.text ?? "")",
            "youtube":"\(YouTubeTextField.text ?? "")",
            "location_name": locationTextField.text ?? ""
        ]
        return data
    }
}

// MARK: - Fetch image methods

extension SignUpStoreViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {

            if imageType == .personalPhoto {
                imageView.image = nil
                imageData = image.jpegData(compressionQuality: 0.8)
                imageView.image = image
            } else {
                coverImageView.image = nil
                coverImageData = image.jpegData(compressionQuality: 0.8)
                coverImageView.image = image
                coverImageView.contentMode = .scaleToFill
            }
            uploadToImageFirebase()

        }else if let image = info[.originalImage] as? UIImage {


            if imageType == .personalPhoto {
                imageView.image = nil
                imageData = image.jpegData(compressionQuality: 0.8)
                imageView.image = image
            } else {
                coverImageView.image = nil
                coverImageData = image.jpegData(compressionQuality: 0.8)
                coverImageView.image = image
                coverImageView.contentMode = .scaleToFill
            }
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
        if imageType == .personalPhoto {
            if userId != -1  && imageData != nil {
                let id = "\(userId)"
                UploadMedia.saveImages(userId: id, imagesArray: [UIImage(data: imageData!)], completionHandler: { [weak self] url in
                    if let firstUrl: String = url.first {
                        self?.imageUrl = firstUrl
                        self?.stopLoading()
                    }
                })
            }
        } else {
            if userId != -1  && coverImageData != nil {
                let id = "\(userId)"
                UploadMedia.saveImages(userId: id, imagesArray: [UIImage(data: coverImageData!)], completionHandler: { [weak self] url in
                    if let firstUrl: String = url.first {
                        self?.coverImageUrl = firstUrl
                        self?.stopLoading()
                    }
                })
            }
        }
    }
}

extension SignUpStoreViewController: CategoriesViewControllerDelegate {
    func didFinishWithCategory(categoryId: Int, categoryName: String) {
        self.categoryId = categoryId
        self.categoryName.text = categoryName
    }

}


extension SignUpStoreViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "placeHolder.Description".localiz() {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            textView.text = "placeHolder.Description".localiz()
            textView.textColor = .lightGray
        }
    }
}

extension SignUpStoreViewController: AvailableSucialMediaViewControllerDelegate{
    func didSelectSocialMedia(type: Set<SocialMediaType>) {
        self.availbleSocialMedia = type
        linkedInView.isHidden = true
        instaView.isHidden = true
        youtubeView.isHidden = true
        websiteView.isHidden = true
        facebookView.isHidden = true
        twitterView.isHidden = true
        
        type.forEach({
            type in
            switch type {
            case .LinkedIn:
                linkedInView.isHidden = false
            case .instagram:
                instaView.isHidden = false
            case .youtube:
                youtubeView.isHidden = false
            case .website:
                websiteView.isHidden = false
            case .facebook:
                facebookView.isHidden = false
            case .twitter:
                twitterView.isHidden = false
            }
        })

    }
}

extension SignUpStoreViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == cityTextField {
      cityPickerView.reloadAllComponents()
    } else if textField == countryTextField {
      countryPickerView.reloadAllComponents()
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension SignUpStoreViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView {
            return viewModel.countryList.count
        } else if pickerView == cityPickerView {
            return viewModel.cityList.count
        }
        return 0
    }
    
    @objc func didTapDone(toolbar: UIToolbar?) {
       if countryPickerView.toolbar == toolbar {
            if (countryTextField.text ?? "").isEmpty {
                if !viewModel.countryList.isEmpty {
                    countryTextField.text = viewModel.countryList[0].name
                    phoneExtentionButton.setTitle( viewModel.countryList[0].countryCode, for: .normal)

                    self.countryId = viewModel.countryList[0].id ?? -1
                    self.cityTextField.text = ""
                    self.cityId = -1
                    self.getCity()
                }
            }
        } else if cityPickerView.toolbar == toolbar {
            if (cityTextField.text ?? "").isEmpty {
                if !viewModel.cityList.isEmpty {
                    cityTextField.text = viewModel.cityList[0].name
                    cityId = viewModel.cityList[0].id ?? -1
                }
            }
        }
        countryTextField.endEditing(true)
        cityTextField.endEditing(true)
    }
    
    // return string from picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView {
            return viewModel.cityList[row].name
        } else if pickerView == countryPickerView {
            return viewModel.countryList[row].name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if countryPickerView == pickerView {
            if !viewModel.countryList.isEmpty {
                countryTextField.text = viewModel.countryList[row].name
                phoneExtentionButton.setTitle( viewModel.countryList[row].countryCode, for: .normal)
                cityTextField.text = ""
                self.countryId = viewModel.countryList[row].id ?? -1
                self.cityId = -1
                self.getCity()
            }
        } else if cityPickerView == pickerView {
            if !viewModel.cityList.isEmpty {
                cityTextField.text = viewModel.cityList[row].name
                cityId = viewModel.cityList[row].id ?? -1
            }
        }
    }
}
