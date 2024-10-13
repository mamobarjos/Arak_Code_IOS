//
//  EditPhoneNumberViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 06/07/2021.
//

import UIKit

class EditPhoneNumberViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var error = ""
    private var signUpViewModel = SignUpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        localization()
    }
    
    private func localization() {
        nextButton.setTitle("Next".localiz(), for: .normal)
        phoneNumberTextField.placeholder = "xxxxxxxxx"
        messageLabel.text = "Please enter new phone number".localiz()
        titleLabel.text = "Change Phone Number".localiz()
        phoneNumberTextField.delegate = self
        phoneNumberTextField.semanticContentAttribute = .forceLeftToRight
        phoneNumberTextField.textAlignment = .left
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      hiddenNavigation(isHidden: false)
      navigationController?.navigationBar.transparentNavigationBar()
    }
    
    @IBAction func Next(_ sender: Any) {
        if !validation() {
          self.showToast(message: error)
          return
        }
        var data:[String : String] = [:]
        data["phone_no"] = "+962" + (phoneNumberTextField.text ?? "")
//        data["old_phone"] = Helper.currentUser?.phoneNo ?? ""

        signUpViewModel.otp(data: data) {  [weak self] (error) in
          defer {
            self?.stopLoading()
          }

          if error != nil {
            self?.showToast(message: error)
            return
          }
          let vc = self?.initViewControllerWith(identifier: OtpViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! OtpViewController
          vc.confige(email: "", processType: .changePhone, data: data)
          self?.show(vc)

        }
    }
    private func validation() -> Bool {
      error = ""

      guard let phone = phoneNumberTextField.text else {
        error = "Please insert your phone number".localiz()
        self.phoneNumberTextField.becomeFirstResponder()

        return error.isEmpty
      }

      if phone.validator(type: .Required) == .Required {
        error = "Please insert your phone number".localiz()
        self.phoneNumberTextField.becomeFirstResponder()
        return error.isEmpty
      }

      if phone.count != 9 {
        error = "Phone Number Should not been less than 9 digits".localiz()
        self.phoneNumberTextField.becomeFirstResponder()
        return error.isEmpty
      }

      return error.isEmpty
    }
}
extension EditPhoneNumberViewController:UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      if textField == phoneNumberTextField {
        let maxLength = 9
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
               currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
      }
   return true
  }
}
