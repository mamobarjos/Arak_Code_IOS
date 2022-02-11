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
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var numberOfSecoundsTextField: UITextField!
    @IBOutlet weak var numberOfSecoundsLabel: UILabel!
    @IBOutlet weak var numberOfImageLabel: UILabel!
    @IBOutlet weak var numberOfImageTextField: UITextField!
    @IBOutlet weak var numberOfReachTextField: UITextField!
    @IBOutlet weak var numberOfReachLabel: UILabel!
    
    private var cityPickerView = ToolbarPickerView()
    private var countryPickerView = ToolbarPickerView()
    private var genderPickerView = ToolbarPickerView()
    private var numberOfSecondPickerView = ToolbarPickerView()
    private var numberOfImagePickerView = ToolbarPickerView()
    private var numberOfReachPickerView = ToolbarPickerView()
    private var adCategory:AdsCategory?

    private var viewModel = SignUpViewModel()
    var countryId = -1
    var cityId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func confige(adCategory: AdsCategory?) {
      self.adCategory = adCategory
    }
    
    private func setup() {
        getCountry()
        localization()
        setupPickerViews()
        genderCustomization()
    }
    
    private func getCountry() {
      viewModel.getCountry { _ in
        self.countryPickerView.reloadAllComponents()
      }
    }

    private func genderCustomization() {
        if Helper.appLanguage != "en" && Helper.appLanguage != nil  {
          genderTextField.setLeftImage(image: #imageLiteral(resourceName: "arrow_down"))
          cityTextField.setLeftImage(image: #imageLiteral(resourceName: "arrow_down"))
          countryTextField.setLeftImage(image: #imageLiteral(resourceName: "arrow_down"))
      } else {
          genderTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
          cityTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
          countryTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
      }
    }
    
    private func getCity() {
      viewModel.getCity(by: countryId) { _ in
        self.cityPickerView.reloadAllComponents()
      }
    }
    
    private func setupPickerViews() {
        genderTextField.inputView = genderPickerView
        genderTextField.delegate = self
        genderPickerView.toolbarDelegate = self
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        genderTextField.inputAccessoryView = genderPickerView.toolbar

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
    
    private func localization() {
        if adCategory?.id == AdsTypes.image.rawValue {
            title = "Image Ads/Custom".localiz()
        } else if adCategory?.id == AdsTypes.video.rawValue {
            title = "Video Ads/Custom".localiz()
        } else if adCategory?.id == AdsTypes.videoWeb.rawValue {
            title = "Website Ads/Custom".localiz()
        }
        contiueButton.setTitle("Continue".localiz(), for: .normal)
        cityLabel.text = "City".localiz()
        cityTextField.placeholder = "Select City".localiz()
        countyLabel.text = "Country".localiz()
        countryTextField.placeholder = "Select Country".localiz()
        genderTextField.placeholder = "Select Gender".localiz()
        genderLabel.text = "Gender".localiz()
        numberOfSecoundsLabel.text = "Number Of Secounds".localiz()
        numberOfSecoundsTextField.placeholder = "Select Number Of Secounds".localiz()
        numberOfImageLabel.text = "Number Of Image".localiz()
        numberOfImageTextField.placeholder = "Select Number Of Image".localiz()
        numberOfReachLabel.text = "Number Of Reach".localiz()
        numberOfReachTextField.placeholder = "Select Number Of Reach".localiz()
        
        genderTextField.textAligment()
        cityTextField.textAligment()
        countryTextField.textAligment()
        numberOfSecoundsTextField.textAligment()
        numberOfImageTextField.textAligment()
        numberOfReachTextField.textAligment()
    }
    
    
    @IBAction func Continue(_ sender: Any) {
    }
    


}
extension CustomPackageViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == genderTextField {
      genderPickerView.reloadAllComponents()
    } else if textField == cityTextField {
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
extension CustomPackageViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {

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
      if (countryTextField.text ?? "").isEmpty {
        if !viewModel.countryList.isEmpty {
          countryTextField.text = viewModel.countryList[0].name
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
    return viewModel.genderList[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if genderPickerView == pickerView {
      if !viewModel.genderList.isEmpty {
        genderTextField.text = viewModel.genderList[row]
      }
    } else if countryPickerView == pickerView {
      if !viewModel.countryList.isEmpty {
          countryTextField.text = viewModel.countryList[row].name
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
