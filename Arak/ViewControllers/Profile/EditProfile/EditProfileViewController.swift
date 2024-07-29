//
//  EditProfileViewController.swift
//  Arak
//
//  Created by Abed Qassim on 11/06/2021.
//

import UIKit
import MapKit
class EditProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var myDetailLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var companyStackView: UIStackView!
    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var changePasswordStackView: UIStackView!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var changePasswordLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var countryStackView: UIStackView!
    @IBOutlet weak var cityTextField: UITextField!
    private var imageData:Data?
    private var selectType = 1 // 1: Profile 2: Cover
    private var imagePicker = UIImagePickerController()
    private var currentLocation:CLLocation?
    private var currentLocatioTitle:String?
    
    private var viewModel = ProfileViewModel()
    
    private var error = ""
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupUI()
        setupBinding()
        self.setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBinding()
    }
    
    @IBAction func ChangePassword(_ sender: Any) {
        let vc = initViewControllerWith(identifier: ResetPasswordViewController.className, and: "Change Password".localiz(),storyboardName: Storyboard.Auth.rawValue) as! ResetPasswordViewController
        vc.config(type: .change, email: "", otpCode: "")
        show(vc)
    }
    
    @IBAction func EditPhone(_ sender: Any) {
        let vc = initViewControllerWith(identifier: EditPhoneNumberViewController.className, and: "".localiz(),storyboardName: Storyboard.Auth.rawValue) as! EditPhoneNumberViewController
        show(vc)
    }
    
    // MARK: - IBAction
    
    @IBAction func Edit(_ sender: Any) {
        if !validation() {
            showToast(message: error)
            return
        }
        
        var data:[String : String] = [:]
        data["fullname"] = nameTextField.text ?? ""
        data["country"] = locationTextField.text  ?? ""
        data["company_name"] = companyNameTextField.text  ?? ""
        data["phone_no"] = phoneLabel.text  ?? ""

        viewModel.editProfile(data: data) {  [weak self] (error) in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            self?.showToast(message: "Edit Profile has been Successfully".localiz())
            self?.setupBinding()
        }
    }
    private func validation() -> Bool {
        error = ""
        guard let name = nameTextField.text else {
            error = "Please insert your full name".localiz()
            self.nameTextField.becomeFirstResponder()
            return error.isEmpty
        }
        
        if name.validator(type: .Required) == .Required {
            error = "Please insert your full name".localiz()
            self.nameTextField.becomeFirstResponder()
            return error.isEmpty
        }
        
        
        return error.isEmpty
    }
    @IBAction func EditProfileImage(_ sender: Any) {
        fetchImage()
    }
    
    @IBAction func Location(_ sender: Any) {
        return //not editable
        let vc = initViewControllerWith(identifier: MapViewController.className, and: "") as! MapViewController
        vc.configue {
            self.locationTextField.becomeFirstResponder()
        } confrimLocation: { (currentLocation, city) in
            self.currentLocation = currentLocation
            self.currentLocatioTitle = city
            self.locationTextField.text = city?.isEmpty ?? false == true ? "\(currentLocation?.coordinate.latitude ?? 0.0) ,\(currentLocation?.coordinate.longitude ?? 0.0) " : city ?? ""
        }
        show(vc)
    }
    
    private func setupUI() {
        myDetailLabel.text = "My Detail".localiz()
        changePasswordLabel.text = "Change Password".localiz()
        confirmButton.setTitle("Confirm".localiz(), for: .normal)
        locationTextField.placeholder = "Location".localiz()
        genderTextField.placeholder = "Gender".localiz()
        companyNameTextField.placeholder = "Business Name".localiz()
        cityTextField.placeholder = "City".localiz()
        
//        genderStackView.isHidden = Helper.currentUser?.socialToken != nil
//        companyStackView.isHidden = Helper.currentUser?.socialToken != nil || (Helper.currentUser?.companyName == nil) || (Helper.currentUser?.companyName ?? "").isEmpty
//        cityStackView.isHidden = Helper.currentUser?.socialToken != nil
//        countryStackView.isHidden = Helper.currentUser?.socialToken != nil
//        changePasswordStackView.isHidden = Helper.currentUser?.socialToken != nil
    }
    
    
    private func setupBinding() {
        nameLabel.text = Helper.currentUser?.fullname ?? ""
        nameTextField.text = Helper.currentUser?.fullname ?? ""
//        emailTextField.text = Helper.currentUser?.email ?? ""
//        locationTextField.text = Helper.currentUser?.country ?? ""
        phoneLabel.text = Helper.currentUser?.phoneNo ?? ""
        genderTextField.text = Helper.currentUser?.gender ?? ""
//        companyNameTextField.text = Helper.currentUser?.companyName ?? ""
        profileImageView.getAlamofireImage(urlString: Helper.currentUser?.imgAvatar)
//        cityTextField.text = Helper.currentUser?.city ?? ""
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
            UploadMedia.saveImages(userId: id, imagesArray: [UIImage(data: imageData!)], completionHandler: { url in
                if let firstUrl:String = url.first {
                    let data: [String: String] = self.selectType == 1 ? ["img_avatar" : firstUrl] : ["cover_avatar" : firstUrl]
                    
                    self.viewModel.editProfileImage(imageType: self.selectType, data: data) { [weak self] (error) in
                        defer {
                            self?.stopLoading()
                        }
                        
                        if error != nil {
                            self?.showToast(message: error)
                            return
                        }
                        Helper.currentUser?.imgAvatar = firstUrl
                        self?.setupBinding()
                    }
                }
            })
        }
    }
}
extension EditProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            imageData = image.jpegData(compressionQuality: 0.8)
            profileImageView.image = nil
            profileImageView.image = image
            uploadToImageFirebase()
            
        }else if let image = info[.originalImage] as? UIImage {
            imageData = image.jpegData(compressionQuality: 0.8)
            profileImageView.image = nil
            profileImageView.image = image
            uploadToImageFirebase()
        }
    }
}

