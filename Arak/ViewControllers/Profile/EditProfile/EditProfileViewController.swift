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
    @IBOutlet weak var birthDateTextField: UITextField!
    //    @IBOutlet weak var companyStackView: UIStackView!
//    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var changePasswordStackView: UIStackView!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var birthOfDateStackView: UIStackView!
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var changePasswordLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var countryStackView: UIStackView!
    @IBOutlet weak var cityTextField: UITextField!
    private var imageData:Data?
    private var selectType = 1 // 1: Profile 2: Cover
    private var imagePicker = UIImagePickerController()
    private var currentLocation:CLLocation?
    private var currentLocatioTitle:String?
    
    
    private let datePicker = UIDatePicker()
    private var genderPickerView = ToolbarPickerView()
    private var countryPickerView = ToolbarPickerView()
    private var cityPickerView = ToolbarPickerView()
    
    var countryId = -1
    var cityId = -1
    
    private var viewModel = ProfileViewModel()
    
    private var error = ""
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupUI()
        setupBinding()
        self.setupHideKeyboardOnTap()
        getCountry()
        getCity()
        setupDatePicker()
        setupPickerView()
        
        if Helper.arakLinks?.isLive == false {
            birthOfDateStackView.isHidden = true
            genderStackView.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
        setupBinding()
    }
    
    private func setupPickerView() {
      genderTextField.inputView = genderPickerView
      genderTextField.delegate = self
      genderPickerView.toolbarDelegate = self
      genderPickerView.dataSource = self
      genderPickerView.delegate = self
      genderTextField.inputAccessoryView = genderPickerView.toolbar

        locationTextField.inputView = countryPickerView
        locationTextField.delegate = self
        countryPickerView.toolbarDelegate = self
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        locationTextField.inputAccessoryView = countryPickerView.toolbar

      cityTextField.inputView = cityPickerView
      cityTextField.delegate = self
      cityPickerView.toolbarDelegate = self
      cityPickerView.dataSource = self
      cityPickerView.delegate = self
      cityTextField.inputAccessoryView = cityPickerView.toolbar
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels // or .compact for a different style
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Create a toolbar with a "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: true)
        
        // Set the date picker as the input view for the text field
        birthDateTextField.inputView = datePicker
        
        // Set the toolbar as the input accessory view for the text field
        birthDateTextField.inputAccessoryView = toolbar
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
          locationTextField.text = viewModel.countryList.first(where: {$0.id ?? 1 == Helper.currentUser?.countryID})?.name
            self.countryPickerView.reloadAllComponents()
            getCity()
      }
    }
    
    @objc private func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func doneTapped() {
        // Dismiss the date picker
        birthDateTextField.resignFirstResponder()
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
        
        var data:[String : Any] = [:]
        data["fullname"] = nameTextField.text ?? ""
        data["birthdate"] = birthDateTextField.text ?? ""
        data["gender"] = genderTextField.text
        data["country_id"] = countryId
        data["city_id"] = cityId
        
//        data["country"] = locationTextField.text  ?? ""
        
//        data["company_name"] = companyNameTextField.text  ?? ""
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
    
//    @IBAction func Location(_ sender: Any) {
//        return //not editable
//        let vc = initViewControllerWith(identifier: MapViewController.className, and: "") as! MapViewController
//        vc.configue {
//            self.locationTextField.becomeFirstResponder()
//        } confrimLocation: { (currentLocation, city) in
//            self.currentLocation = currentLocation
//            self.currentLocatioTitle = city
//            self.locationTextField.text = city?.isEmpty ?? false == true ? "\(currentLocation?.coordinate.latitude ?? 0.0) ,\(currentLocation?.coordinate.longitude ?? 0.0) " : city ?? ""
//        }
//        show(vc)
//    }
    
    private func setupUI() {
        myDetailLabel.text = "My profile".localiz()
        changePasswordLabel.text = "Change Password".localiz()
        confirmButton.setTitle("Confirm".localiz(), for: .normal)
        locationTextField.placeholder = "Location".localiz()
        genderTextField.placeholder = "Gender".localiz()
//        companyNameTextField.placeholder = "Business Name".localiz()
        cityTextField.placeholder = "City".localiz()
        
        
//        genderStackView.isHidden = Helper.currentUser?.socialToken != nil
//        companyStackView.isHidden = Helper.currentUser?.socialToken != nil || (Helper.currentUser?.companyName == nil) || (Helper.currentUser?.companyName ?? "").isEmpty
//        cityStackView.isHidden = Helper.currentUser?.socialToken != nil
//        countryStackView.isHidden = Helper.currentUser?.socialToken != nil
//        changePasswordStackView.isHidden = Helper.currentUser?.socialToken != nil
    }
    
    
    private func setupBinding() {
        countryId = Helper.currentUser?.countryID ?? 1
        cityId = Helper.currentUser?.cityID ?? 1
        nameLabel.text = Helper.currentUser?.fullname ?? ""
        nameTextField.text = Helper.currentUser?.fullname ?? ""
//        emailTextField.text = Helper.currentUser?.email ?? ""
//        locationTextField.text = Helper.currentUser?.country ?? ""
        phoneLabel.text = Helper.currentUser?.phoneNo ?? ""
        genderTextField.text = Helper.currentUser?.gender ?? ""
//        companyNameTextField.text = Helper.currentUser?.companyName ?? ""
        profileImageView.getAlamofireImage(urlString: Helper.currentUser?.imgAvatar)
//        cityTextField.text = Helper.currentUser?.city ?? ""
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = inputFormatter.date(from: Helper.currentUser?.birthdate ?? "") {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            let outputDateString = outputFormatter.string(from: date)
            
            birthDateTextField.text = outputDateString
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
            UploadMedia.saveImages(userId: id, imagesArray: [UIImage(data: imageData!)], completionHandler: { url in
                if let firstUrl:String = url.first {
                    let data: [String: String] = self.selectType == 1 ? ["img_avatar" : firstUrl] : ["cover_avatar" : firstUrl]
                    
                    self.viewModel.editProfileImage(userId: userId, imageType: self.selectType, data: data) { [weak self] (error) in
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

extension EditProfileViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == genderTextField {
      genderPickerView.reloadAllComponents()
    } else if textField == cityTextField {
      cityPickerView.reloadAllComponents()
    } else if textField == locationTextField {
      countryPickerView.reloadAllComponents()
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension EditProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView {
            return viewModel.countryList.count
        } else if pickerView == cityPickerView {
            return viewModel.cityList.count
        }
        return viewModel.genderList.count
    }
    
    @objc func didTapDone(toolbar: UIToolbar?) {
        if genderPickerView.toolbar == toolbar {
            if (genderTextField.text ?? "").isEmpty {
                if !viewModel.genderList.isEmpty {
                    genderTextField.text = viewModel.genderList[0]
                }
            }
        } else if countryPickerView.toolbar == toolbar {
            if (locationTextField.text ?? "").isEmpty {
                if !viewModel.countryList.isEmpty {
                    locationTextField.text = viewModel.countryList[0].name
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
        genderTextField.endEditing(true)
        locationTextField.endEditing(true)
        cityTextField.endEditing(true)
    }
    
    // return string from picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView {
            return viewModel.cityList[row].name
        } else if pickerView == countryPickerView {
            return viewModel.countryList[row].name
        }
        return viewModel.genderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if genderPickerView == pickerView {
            if !viewModel.genderList.isEmpty {
                genderTextField.text = viewModel.genderList[row]
            }
        } else if countryPickerView == pickerView {
            if !viewModel.countryList.isEmpty {
                locationTextField.text = viewModel.countryList[row].name
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
