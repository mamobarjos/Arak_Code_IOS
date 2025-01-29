//
//  ForgetPasswordViewController.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//  
//

import UIKit
import Foundation


class ForgetPasswordViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var phoneNumberExtention: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!

  // MARK: - Properties

    private var error = ""
    private var viewModel: ForgetPasswordViewModel = ForgetPasswordViewModel()
    private var signUpViewModel: SignUpViewModel = SignUpViewModel()
    
    private var countryPickerView = ToolbarPickerView()
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.semanticContentAttribute = .forceLeftToRight
        phoneTextField.textAlignment = .left
        self.setupHideKeyboardOnTap()
        getCountry()
        setupPickerView()
        setupUI()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      hiddenNavigation(isHidden: false)
      navigationController?.navigationBar.transparentNavigationBar()
    }

    // MARK: - Protected Methods
    private func setupUI() {
        emailContainerView.isHidden = true
      locaization()
    }

    private func setupPickerView() {
        phoneNumberExtention.inputView = countryPickerView
        phoneNumberExtention.delegate = self
        countryPickerView.toolbarDelegate = self
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        phoneNumberExtention.inputAccessoryView = countryPickerView.toolbar
    }
    
    private func getCountry() {
      signUpViewModel.getCountry { _ in
        self.countryPickerView.reloadAllComponents()

      }
    }
    
    private func setupBinding() {

    }

    private func locaization() {
      welcomeLabel.text = "Forget Your Password".localiz()
      messageLabel.text = "Please insert your phone number".localiz()
      emailTextField.placeholder = "Email".localiz()
      phoneTextField.placeholder = "xxxxxxxxx".localiz()
      nextButton.setTitle("Next".localiz(), for: .normal)
      welcomeLabel.textAligment()
      messageLabel.textAligment()
        phoneTextField.textAligment()
    }

    private func validation() -> Bool {
        error = ""

        guard let phone = phoneTextField.text else {
          error = "Please insert your phone number".localiz()
          self.phoneTextField.becomeFirstResponder()

          return error.isEmpty
        }

        if phone.validator(type: .Required) == .Required {
          error = "Please insert your phone number".localiz()
          self.phoneTextField.becomeFirstResponder()
          return error.isEmpty
        }

//        if phone.count != 9 {
//          error = "Phone Number Should not been less than 9 digits".localiz()
//          self.phoneTextField.becomeFirstResponder()
//          return error.isEmpty
//        }
      return error.isEmpty
    }

    private func showEmailIfNeeded(isEnabled: Bool) {
        if isEnabled {
            emailContainerView.isHidden = false
        } else {
            emailContainerView.isHidden = true
        }
    }

  @IBAction func Forget(_ sender: Any) {
      if !validation() {
        self.showToast(message: error)
        return
      }

    var otpData:[String : String] = [:]
      otpData["phone_no"] = "\(phoneNumberExtention.text ?? "+962")" + (phoneTextField.text ?? "")
      otpData["email"] = emailTextField.text ?? ""
    signUpViewModel.otp(data: otpData) {  [weak self] (error) in
      defer {
        self?.stopLoading()
      }
      if error != nil {
        self?.showToast(message: error)
        return
      }
      let vc = self?.initViewControllerWith(identifier: OtpViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! OtpViewController
      vc.confige(email: "", processType: .forgot, data: otpData, registerData: otpData)
      self?.show(vc)
    }
  }

}

extension ForgetPasswordViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
        countryPickerView.reloadAllComponents()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension ForgetPasswordViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return signUpViewModel.countryList.count
  }

  @objc func didTapDone(toolbar: UIToolbar?) {
      if phoneNumberExtention.text?.isEmpty ?? false {
          phoneNumberExtention.text = signUpViewModel.countryList.first?.countryCode
          showEmailIfNeeded(isEnabled: signUpViewModel.countryList.first?.emailRequired ?? false)
      }
      phoneNumberExtention.endEditing(true)
  }

  // return string from picker
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      signUpViewModel.countryList[row].countryCode
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      phoneNumberExtention.text = signUpViewModel.countryList[row].countryCode
      showEmailIfNeeded(isEnabled: signUpViewModel.countryList[row].emailRequired ?? false)
  }
}
