//
//  SocialMediaAuthViewController.swift
//  Joyin
//
//  Created by Abed Qassim on 28/05/2021.
//

import UIKit

class SocialMediaAuthViewController: UIViewController,UITextFieldDelegate {
  // MARK: - Outlets
  @IBOutlet weak var continueLabel: UILabel!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var fullNameTextField: UITextField!
  private var soicalMedia: SocialMedia?
  var viewModel: SignUpViewModel = SignUpViewModel()
  var error = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    phoneTextField.delegate = self
    phoneTextField.semanticContentAttribute = .forceLeftToRight
    phoneTextField.textAlignment = .left
    setupUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hiddenNavigation(isHidden: false)
    navigationController?.navigationBar.transparentNavigationBar()
  }
  func confige(soicalMedia: SocialMedia?)  {
    self.soicalMedia = soicalMedia
  }

  // MARK: - Protected Methods
  private func setupUI() {
    locaization()
    emailTextField.text = soicalMedia?.email != SocialError.EmailNotFound.rawValue ? soicalMedia?.email : ""
    fullNameTextField.text = soicalMedia?.displayName ?? ""
  }

  private func locaization() {
    var titleContinue = "Continue With".localiz()
    if soicalMedia?.type == .Apple {
      titleContinue = titleContinue + " " + "Apple".localiz()
    } else if soicalMedia?.type == .Facebook {
      titleContinue = titleContinue + " " + "Facebook".localiz()
    } else if soicalMedia?.type == .Google {
      titleContinue = titleContinue + " " + "Google".localiz()
    }
    continueLabel.text =  titleContinue

    fullNameTextField.placeholder = "Full Name".localiz()
    emailTextField.placeholder = "Email".localiz()
    phoneTextField.placeholder = "Phone Number".localiz()
    nextButton.setTitle("Next".localiz(), for: .normal)
    nextButton.addRoundedCorners(cornerRadius: 10)
  }

  @IBAction func Next(_ sender: Any) {
    if !validation() {
      showToast(message: error)
      return
    }
    showLoading()
    var data:[String : String] = [:]
    data["fullname"] = fullNameTextField.text ?? ""
    data["email"] = emailTextField.text ?? ""
    data["phone_no"] = "+962" + (phoneTextField.text ?? "")
    data["social_token"] = soicalMedia?.socialId ?? ""
    viewModel.register(data: data) { [weak self] (error) in
      defer {
        self?.stopLoading()
      }

      if error != nil {
        self?.showToast(message: error)
        return
      }

      let vc = self?.initViewControllerWith(identifier: BubbleTabBarController.className, and: "") as! BubbleTabBarController
      self?.show(vc)
    }
  }
  private func validation() -> Bool {
    error = ""
    guard let name = fullNameTextField.text else {
      error = "Please insert your full name".localiz()
      self.fullNameTextField.becomeFirstResponder()
      return error.isEmpty
    }

    if name.validator(type: .Required) == .Required {
      error = "Please insert your full name".localiz()
      self.fullNameTextField.becomeFirstResponder()
      return error.isEmpty
    }
  
    guard let email = emailTextField.text else {
      error = "Please insert your email".localiz()
      self.emailTextField.becomeFirstResponder()

      return error.isEmpty
    }
    if email.validator(type: .Email) == .Required {
      error = "Please insert your email".localiz()
      self.emailTextField.becomeFirstResponder()
      return error.isEmpty
    }
    if email.validator(type: .Email) == .Email {
      error = "You have entered an invalid email address!".localiz()
      self.emailTextField.becomeFirstResponder()

      return error.isEmpty
    }
    
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

    if phone.count != 9 {
      error = "Phone Number Should not been less than 9 digits".localiz()
      self.phoneTextField.becomeFirstResponder()
      return error.isEmpty
    }

    return true
  }

}
extension SocialMediaAuthViewController {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      if textField == phoneTextField {
        let maxLength = 9
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
               currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
      }
   return true
  }
}
