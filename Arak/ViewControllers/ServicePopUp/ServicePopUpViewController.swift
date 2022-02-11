//
//  ServicePopUpViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 13/07/2021.
//

import UIKit

class ServicePopUpViewController: UIViewController {
    typealias ConfirmBlock = () -> Void

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    private var confirmBlock: ConfirmBlock?
    private var serviceId: Int = -1
    private var serviceViewModel = ServiceViewModel()
    private var error = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.29)
        //addGesture()
        localization()
    }
    
    private func localization() {
        phoneNumberTextField.semanticContentAttribute = .forceLeftToRight
        phoneNumberTextField.textAlignment = .left
        emailLabel.text = "Email".localiz()
        emailTextField.placeholder = "Enter Email".localiz()
        nameLabel.text = "Full Name".localiz()
        nameTextField.placeholder = "Enter Name".localiz()
        phoneNumberLabel.text = "Phone Number".localiz()
        phoneNumberTextField.placeholder = "Enter Phone Number".localiz()
        titleLabel.text = "Contact Info".localiz()
        descriptionLabel.text = "Once the details below are completed, one of our expert advisors will contact you".localiz()
        sendButton.setTitle("Send".localiz(), for: .normal)
        titleLabel.textAligment()
        descriptionLabel.textAligment()
        
        emailTextField.text = Helper.currentUser?.email ?? ""
        nameTextField.text = Helper.currentUser?.fullname ?? ""
        let phoneNo = Helper.currentUser?.phoneNo ?? ""
        phoneNumberTextField.text = phoneNo.replacingOccurrences(of: "+962", with: "")
        
    }
    @IBAction func Send(_ sender: Any) {
        if !validation() {
            return
        }
        showLoading()
        serviceViewModel.requestService(name: nameTextField.text ?? "", email: emailTextField.text ?? "", phoneNo: "+962" + (phoneNumberTextField.text ?? ""), serviceId: "\(serviceId)") { [weak self] (error) in
            defer {
              self?.stopLoading()
            }

            if error != nil {
              self?.showToast(message: error)
              return
            }
            self?.showToast(message: "Your request has been successfully sent".localiz())
            self?.confirmBlock?()
        }
        
    }
    
    @IBAction func Close(_ sender: Any) {
        dismissViewController()
    }
    func confige(serviceId: Int,confirmBlock: ConfirmBlock?) {
        self.confirmBlock = confirmBlock
        self.serviceId = serviceId
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
extension ServicePopUpViewController {
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
