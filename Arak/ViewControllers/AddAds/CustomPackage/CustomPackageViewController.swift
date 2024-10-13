//
//  CustomPackageViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 11/07/2021.
//

import UIKit

class CustomPackageViewController: UIViewController {

    @IBOutlet weak var contiueButton: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!

    @IBOutlet weak var numbersOfImagesStack: UIStackView!
    @IBOutlet weak var numberOfSecoundsTextField: UITextField!
    @IBOutlet weak var numberOfImageTextField: UITextField!
    @IBOutlet weak var numberOfReachTextField: UITextField!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalAmountValueLabel: UILabel!
    
    private var cityPickerView = ToolbarPickerView()
    private var countryPickerView = ToolbarPickerView()
    private var genderPickerView = ToolbarPickerView()
    private var agePickerView = ToolbarPickerView()
    private var numberOfSecondPickerView = ToolbarPickerView()
    private var numberOfImagePickerView = ToolbarPickerView()
    private var numberOfReachPickerView = ToolbarPickerView()
    private var adCategory:AdCategory?

    private var createAdViewModel = CreateAdViewModel()
    private var viewModel = SignUpViewModel()
    
    var genderId: Int?
    var ageId: Int?
    var numberId: Int?
    var numberOfImagesId: Int?
    var numberOfReachsId: Int?
    var countryId: Int?
    var cityId: Int?
    
    var genderPrice: Double = -1
    var agePrice: Double = -1
    var numberOfSeconds = -1
    var numberOfImages = -1
    var numberOfReachs = "-1"
    var countryPrice: Double = -1
    var cityPrice: Double = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func confige(adCategory: AdCategory?) {
      self.adCategory = adCategory
       
    }
    
    private func setup() {
        getPackageContentDate()
        localization()
        setupPickerViews()
        genderCustomization()
        numbersOfImagesStack.isHidden = adCategory?.id != 1
    }
    
    private func getPackageContentDate() {
        showLoading()
        createAdViewModel.getCutomeAdsContent(categoryId: adCategory?.id ?? 1) { [weak self] error in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                self?.navigationController?.popViewController(animated: true)
                return
            }
        }
    }

    private func genderCustomization() {
        if Helper.appLanguage != "en" {
            numberOfReachTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
            numberOfImageTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
            numberOfSecoundsTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
            ageTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
            genderTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
            cityTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
            countryTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
            
          
        } else {
            numberOfReachTextField.setLeftImage(image: #imageLiteral(resourceName: "arrow_down"))
            numberOfImageTextField.setLeftImage(image: #imageLiteral(resourceName: "arrow_down"))
            numberOfSecoundsTextField.setLeftImage(image: #imageLiteral(resourceName: "arrow_down"))
            ageTextField.setLeftImage(image: #imageLiteral(resourceName: "arrow_down"))
            genderTextField.setLeftImage(image: #imageLiteral(resourceName: "arrow_down"))
            cityTextField.setLeftImage(image: #imageLiteral(resourceName: "arrow_down"))
            countryTextField.setLeftImage(image: #imageLiteral(resourceName: "arrow_down"))
      }
    }
    
    
    private func setupPickerViews() {
        configurePicker(for: genderTextField, pickerView: genderPickerView)
        configurePicker(for: countryTextField, pickerView: countryPickerView)
        configurePicker(for: cityTextField, pickerView: cityPickerView)
        configurePicker(for: numberOfSecoundsTextField, pickerView: numberOfSecondPickerView)
        configurePicker(for: numberOfImageTextField, pickerView: numberOfImagePickerView)
        configurePicker(for: numberOfReachTextField, pickerView: numberOfReachPickerView)
        configurePicker(for: ageTextField, pickerView: agePickerView)
    }

    private func configurePicker(for textField: UITextField, pickerView: ToolbarPickerView) {
        textField.inputView = pickerView
        textField.delegate = self
        pickerView.toolbarDelegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        textField.inputAccessoryView = pickerView.toolbar
    }
    
    
    private func localization() {
        if adCategory?.id == AdsTypes.image.rawValue {
            title = "Image Ads/Custom".localiz()
        } else if adCategory?.id == AdsTypes.video.rawValue {
            title = "Video Ads/Custom".localiz()
        } else if adCategory?.id == AdsTypes.videoWeb.rawValue {
            title = "Website Ads/Custom".localiz()
        }
        
        totalAmountLabel.text = "Total Amount".localiz()
        totalAmountValueLabel.text = "0" + " " + "\(Helper.currencyCode ?? "JOD")"
        totalAmountValueLabel.textColor = .accentOrange
        totalAmountValueLabel.font = .font(for: .bold, size: 17)
        
        contiueButton.setTitle("Continue".localiz(), for: .normal)
//        cityLabel.text = "City".localiz()
        cityTextField.placeholder = "Select City".localiz()
//        countyLabel.text = "Country".localiz()
        countryTextField.placeholder = "Select Country".localiz()
        genderTextField.placeholder = "Select Gender".localiz()
//        genderLabel.text = "Gender".localiz()
//        numberOfSecoundsLabel.text = "Number Of Secounds".localiz()
        numberOfSecoundsTextField.placeholder = "Select Number Of Secounds".localiz()
//        numberOfImageLabel.text = "Number Of Image".localiz()
        numberOfImageTextField.placeholder = "Select Number Of Image".localiz()
//        numberOfReachLabel.text = "Number Of Reach".localiz()
        numberOfReachTextField.placeholder = "Select Number Of Reach".localiz()
        
        genderTextField.textAligment()
        cityTextField.textAligment()
        countryTextField.textAligment()
        numberOfSecoundsTextField.textAligment()
        numberOfImageTextField.textAligment()
        numberOfReachTextField.textAligment()
        ageTextField.textAligment()
        

    }
    
    private func calculateTotalPrice() {
        let imgsFactor = numberOfImages != -1 ? Double(numberOfImages) : 0.0
        let secondsFactor = numberOfSeconds != -1 ? Double(numberOfSeconds) : 0.0
        let reachFactor = numberOfReachs != "-1" ? Double(numberOfReachs) ?? 1 : 0.0
        
       
        let ageFactor = agePrice != -1 ? Double(agePrice) : 0.0
        
        let genderFactor = genderPrice != -1 ? Double(genderPrice) : 1.0
        let countryFactor =  countryPrice != -1 ? Double(countryPrice) : 1.0
        let cityFactor =  cityPrice != -1 ? Double(cityPrice) : 1.0
       
        print(imgsFactor)
        print(secondsFactor)
        print(reachFactor)
        print(ageFactor)
        print(genderFactor)
        print(countryFactor)
        print(cityFactor)
        

        if genderPrice == -1 && countryPrice == -1 && cityPrice == -1 {
            return
        }
        
        let sumTotal = (reachFactor + imgsFactor + secondsFactor + ageFactor)
        let finalFactor = sumTotal * countryFactor * cityFactor * genderFactor
        
        let price = String(format: "%.2f", finalFactor)
        totalAmountValueLabel.text = price + " " + "\(Helper.currencyCode ?? "JOD")"
    }
    
    private func createPackage() {
        guard let numberOfReachsId, let numberId, let ageId, let countryId, let cityId else {
            self.showToast(message: "Select City".localiz() + " & " + "Select Country".localiz() + " & " + "Select Number Of Secounds".localiz() + " & " + "Select Number Of Reach".localiz() + " " + "Requierd".localiz() + " "  )
            return
        }
        var data: [String : Any] = [:]
        data["ad_category_id"] = adCategory?.id ?? 1
        data["custom_reach_id"] = numberOfReachsId
        data["custom_second_id"] = numberId
        data["custom_img_id"] = numberOfImagesId
        data["custom_age_id"] = ageId
        data["custom_gender_id"] = genderId
        data["custom_country_id"] = countryId
        data["custom_city_id"] = cityId
        
        showLoading()
        createAdViewModel.createCustomePackage(data: data) { [weak self] error in
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            
            if self?.adCategory?.id == 4 {
                let vc = self?.initViewControllerWith(identifier: CheckoutViewController.className, and: "",storyboardName: Storyboard.Main.rawValue) as! CheckoutViewController
                Ad_category_id = 4
                Ad_package_id = self?.createAdViewModel.package?.id ?? 0
                package_Price = self?.createAdViewModel.package?.price ?? ""
                package_reach = self?.createAdViewModel.package?.reach ?? 0
                
                self?.show(vc)
            } else {
                let vc = self?.initViewControllerWith(identifier: DetailAdsViewController.className, and: "") as! DetailAdsViewController
                
                vc.confige(adCategory: self?.adCategory, packageSelect: self?.createAdViewModel.package)
                self?.show(vc)
            }
        }
    }
    

    
    @IBAction func Continue(_ sender: Any) {
        createPackage()
    
    }
    


}
extension CustomPackageViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case genderTextField:
            genderPickerView.reloadAllComponents()
            
        case cityTextField:
            cityPickerView.reloadAllComponents()
            
        case countryTextField:
            countryPickerView.reloadAllComponents()
            
        case numberOfSecoundsTextField:
            numberOfSecondPickerView.reloadAllComponents()
            
        case numberOfImageTextField:
            numberOfImagePickerView.reloadAllComponents()
            
        case numberOfReachTextField:
            numberOfReachPickerView.reloadAllComponents()
            
        case ageTextField:
            agePickerView.reloadAllComponents()
        default:
            break
        }
    }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension CustomPackageViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case countryPickerView:
            return createAdViewModel.customeAdData?.customCountries?.count ?? 0
        case cityPickerView:
            return createAdViewModel.customeAdData?.customCities?.count ?? 0
        case numberOfSecondPickerView:
            return createAdViewModel.customeAdData?.customSeconds?.count ?? 0
        case numberOfImagePickerView:
            return createAdViewModel.customeAdData?.customImgs?.count ?? 0
        case numberOfReachPickerView:
            return createAdViewModel.customeAdData?.customReachs?.count ?? 0
        case agePickerView:
            return createAdViewModel.customeAdData?.customAges?.count ?? 0
        default:
            return createAdViewModel.customeAdData?.customGenders?.count ?? 0
        }
    }

    @objc func didTapDone(toolbar: UIToolbar?) {
        switch toolbar {
        case agePickerView.toolbar:
            if (ageTextField.text?.isEmpty == true) , !(createAdViewModel.customeAdData?.customAges?.isEmpty ?? true) {
                ageTextField.text = "\(createAdViewModel.customeAdData?.customAges?[0].age ?? "")"
                agePrice = Double(createAdViewModel.customeAdData?.customAges?[0].price ?? "-1") ?? -1
                ageId = createAdViewModel.customeAdData?.customAges?[0].id
            }
            
        case genderPickerView.toolbar:
            if (genderTextField.text?.isEmpty == true) , !(createAdViewModel.customeAdData?.customGenders?.isEmpty ?? true) {
                genderTextField.text = "\(createAdViewModel.customeAdData?.customGenders?[0].gender ?? "")"
                genderPrice = Double(createAdViewModel.customeAdData?.customGenders?[0].price ?? "-1") ?? -1
                genderId = createAdViewModel.customeAdData?.customGenders?[0].id
            }
            
        case countryPickerView.toolbar:
            if  (countryTextField.text?.isEmpty == true) , !(createAdViewModel.customeAdData?.customCountries?.isEmpty ?? true) {
                countryTextField.text = "\(createAdViewModel.customeAdData?.customCountries?[0].country?.name ?? "")"
                countryPrice = Double(createAdViewModel.customeAdData?.customCountries?[0].price ?? "-1") ?? -1
                countryId = createAdViewModel.customeAdData?.customCountries?[0].id
            }
            
        case cityPickerView.toolbar:
            if (cityTextField.text?.isEmpty == true) , !(createAdViewModel.customeAdData?.customCities?.isEmpty ?? true) {
                cityTextField.text = "\(createAdViewModel.customeAdData?.customCities?[0].city?.name ?? "")"
                cityPrice = Double(createAdViewModel.customeAdData?.customCities?[0].price ?? "-1") ?? -1
                cityId = createAdViewModel.customeAdData?.customCities?[0].id
            }
            
        case numberOfSecondPickerView.toolbar:
            if (numberOfSecoundsTextField.text?.isEmpty == true) , !(createAdViewModel.customeAdData?.customSeconds?.isEmpty ?? true) {
                numberOfSecoundsTextField.text = "\(createAdViewModel.customeAdData?.customSeconds?[0].value ?? 0)"
                numberOfSeconds = createAdViewModel.customeAdData?.customSeconds?[0].value ?? -1
                numberId = createAdViewModel.customeAdData?.customSeconds?[0].id
            }
        case numberOfImagePickerView.toolbar:
            if (numberOfImageTextField.text?.isEmpty == true) , !(createAdViewModel.customeAdData?.customImgs?.isEmpty ?? true) {
                numberOfImageTextField.text = "\(createAdViewModel.customeAdData?.customImgs?[0].value ?? 0)"
                numberOfImages = createAdViewModel.customeAdData?.customImgs?[0].value ?? -1
                numberOfImagesId = createAdViewModel.customeAdData?.customImgs?[0].id
            }
            
        case numberOfReachPickerView.toolbar:
            if (numberOfReachTextField.text?.isEmpty == true) , !(createAdViewModel.customeAdData?.customReachs?.isEmpty ?? true) {
                numberOfReachTextField.text = "\(createAdViewModel.customeAdData?.customReachs?[0].value ?? 0)"
                numberOfReachs = createAdViewModel.customeAdData?.customReachs?[0].secondPrice ?? "-1"
                numberOfReachsId = createAdViewModel.customeAdData?.customReachs?[0].id
            }
            
        default:
            break
        }
        
        // End editing for all fields
        genderTextField.endEditing(true)
        countryTextField.endEditing(true)
        cityTextField.endEditing(true)
        numberOfSecoundsTextField.endEditing(true)
        numberOfImageTextField.endEditing(true)
        numberOfReachTextField.endEditing(true)
        ageTextField.endEditing(true)
        
        calculateTotalPrice()
    }

  // return string from picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case cityPickerView:
            return "\(createAdViewModel.customeAdData?.customCities?[row].city?.name ?? " ")"
        case countryPickerView:
            return "\(createAdViewModel.customeAdData?.customCountries?[row].country?.name ?? " ")"
        case numberOfSecondPickerView:
            return "\(createAdViewModel.customeAdData?.customSeconds?[row].value ?? 0)"
        case numberOfImagePickerView:
            return "\(createAdViewModel.customeAdData?.customImgs?[row].value ?? 0)"
        case numberOfReachPickerView:
            return "\(createAdViewModel.customeAdData?.customReachs?[row].value ?? 0)"
        case agePickerView:
            return "\(createAdViewModel.customeAdData?.customAges?[row].age ?? "0")"
        default:
            return createAdViewModel.customeAdData?.customGenders?[row].gender ?? ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case agePickerView:
            if  !(createAdViewModel.customeAdData?.customAges?.isEmpty ?? true) {
                ageTextField.text = "\(createAdViewModel.customeAdData?.customAges?[row].age ?? " ")"
                agePrice = Double(createAdViewModel.customeAdData?.customAges?[row].price ?? "-1") ?? -1
                ageId = createAdViewModel.customeAdData?.customAges?[row].id
            }
            
        case genderPickerView:
            if  !(createAdViewModel.customeAdData?.customGenders?.isEmpty ?? true) {
                genderTextField.text = "\(createAdViewModel.customeAdData?.customGenders?[row].gender ?? " ")"
                genderPrice = Double(createAdViewModel.customeAdData?.customGenders?[row].price ?? "-1") ?? -1
                genderId = createAdViewModel.customeAdData?.customGenders?[row].id
            }
            
        case countryPickerView:
            if  !(createAdViewModel.customeAdData?.customCountries?.isEmpty ?? true) {
                countryTextField.text = "\(createAdViewModel.customeAdData?.customCountries?[row].country?.name ?? " ")"
                countryPrice = Double(createAdViewModel.customeAdData?.customCountries?[row].price ?? "-1") ?? -1
                countryId = createAdViewModel.customeAdData?.customCountries?[row].id
            }
            
        case cityPickerView:
            if  !(createAdViewModel.customeAdData?.customCities?.isEmpty ?? true) {
                cityTextField.text = "\(createAdViewModel.customeAdData?.customCities?[row].city?.name ?? " ")"
                cityPrice = Double(createAdViewModel.customeAdData?.customCities?[row].price ?? "-1") ?? -1
                cityId = createAdViewModel.customeAdData?.customCities?[row].id
            }
            
        case numberOfSecondPickerView:
            if !(createAdViewModel.customeAdData?.customSeconds?.isEmpty ?? true) {
                numberOfSecoundsTextField.text = "\(createAdViewModel.customeAdData?.customSeconds?[row].value ?? 0)"
                numberOfSeconds = createAdViewModel.customeAdData?.customSeconds?[row].value ?? -1
                numberId = createAdViewModel.customeAdData?.customSeconds?[row].id
            }
            
        case numberOfImagePickerView:
            if  !(createAdViewModel.customeAdData?.customImgs?.isEmpty ?? true) {
                numberOfImageTextField.text = "\(createAdViewModel.customeAdData?.customImgs?[row].value ?? 0)"
                numberOfImages = createAdViewModel.customeAdData?.customImgs?[row].value ?? -1
                numberOfImagesId = createAdViewModel.customeAdData?.customImgs?[row].id
            }
            
        case numberOfReachPickerView:
            if !(createAdViewModel.customeAdData?.customReachs?.isEmpty ?? true) {
                numberOfReachTextField.text = "\(createAdViewModel.customeAdData?.customReachs?[row].value ?? 0)"
                numberOfReachs = createAdViewModel.customeAdData?.customReachs?[row].secondPrice ?? "-1"
                numberOfReachsId = createAdViewModel.customeAdData?.customReachs?[row].id
            }
            
        default:
            break
        }
    }
 
}

//        {\"custom_second_id\":7,
//            \"custom_reach_id\":6,
//            \"custom_age_id\":4,
//            \"ad_category_id\":1,
//            \"custom_country_id\":1,
//            \"custom_img_id\":5,
//            \"custom_gender_id\":2,
//            \"custom_city_id\":4}
            
        // reaches
//        {
//          "deleted_at" : null,
//          "id" : 6,
//          "value" : 150000,
//          "second_price" : "300",
//          "updated_at" : "2024-09-15T10:07:37.066Z",
//          "created_at" : "2024-09-15T10:07:37.066Z"
//        }
        // images
//        {
//          "deleted_at" : null,
//          "id" : 5,
//          "value" : 10,
//          "updated_at" : "2024-09-15T10:08:18.519Z",
//          "created_at" : "2024-09-15T10:08:18.519Z"
//        }
        // Secounds
//        {
//          "deleted_at" : null,
//          "id" : 7,
//          "value" : 60,
//          "updated_at" : "2024-09-15T10:09:56.089Z",
//          "price" : "0.01",
//          "created_at" : "2024-09-15T10:09:56.089Z"
//        },
        
        // Gender
//        {
//        "gender" : "FEMALE",
//        "id" : 2,
//        "deleted_at" : null,
//        "updated_at" : "2024-09-15T10:22:46.520Z",
//        "price" : "0.15",
//        "created_at" : "2024-09-15T10:04:40.408Z"
//      },
        
        // Gender
//        {
//        "gender" : "FEMALE",
//        "id" : 2,
//        "deleted_at" : null,
//        "updated_at" : "2024-09-15T10:22:46.520Z",
//        "price" : "0.15",
//        "created_at" : "2024-09-15T10:04:40.408Z"
//      },
        // Age
//        {
//          "age" : "56-75",
//          "id" : 4,
//          "deleted_at" : null,
//          "updated_at" : "2024-09-15T10:04:21.018Z",
//          "price" : "2",
//          "created_at" : "2024-09-15T10:04:21.018Z"
//        }
        // country
//        {
//          "country" : {
//            "id" : 2,
//            "name_en" : "Jordan",
//            "name_ar" : "الأردن"
//          },
//          "id" : 1,
//          "price" : "0.1",
//          "created_at" : "2024-09-15T10:04:51.176Z",
//          "deleted_at" : null,
//          "country_id" : 2,
//          "updated_at" : "2024-09-15T10:05:04.289Z"
//        }
        // city
//        {
//          "city" : {
//            "id" : 6,
//            "name_en" : "Al-mafraq",
//            "name_ar" : "المفرق"
//          },
//          "city_id" : 6,
//          "id" : 4,
//          "price" : "0.02",
//          "created_at" : "2024-09-15T10:05:47.167Z",
//          "deleted_at" : null,
//          "updated_at" : "2024-09-15T10:05:47.167Z"
//        }
