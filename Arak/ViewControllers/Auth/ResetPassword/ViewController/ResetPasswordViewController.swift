//
//  ResetPasswordViewController.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//  
//

import UIKit
import Foundation


class ResetPasswordViewController: UIViewController {
    
    enum TypeProcess {
        case change
        case reset
    }
    // MARK: - Outlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordStackView: UIStackView!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    // MARK: - Properties
    
    
    var viewModel: ResetPasswordViewModel = ResetPasswordViewModel()
    private var error = ""
    private var typeProcess:TypeProcess = .reset
    private var otpCode = ""
    private var email = ""
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordStackView.isHidden = typeProcess == .reset
        self.setupHideKeyboardOnTap()
        setupUI()
        setupBinding()
    }
    
    
    func config(type: TypeProcess = .reset,email:String = "" , otpCode: String = "") {
      self.typeProcess = type
      self.otpCode = otpCode
      self.email = email
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: typeProcess == .reset)
        navigationController?.navigationBar.transparentNavigationBar()
    }
    
    // MARK: - Protected Methods
    private func setupUI() {
        locaization()
    }
    
    private func setupBinding() {
        
    }
    
    private func validation() -> Bool {
        error = ""
        
        if typeProcess == .change {
            guard let oldPassword = oldPasswordTextField.text else {
                error = "Please insert your old password".localiz()
                return error.isEmpty
            }
            
            if oldPassword.validator(type: .Required) == .Required {
                error = "Please insert your old password".localiz()
                return error.isEmpty
            }
        }
        
        guard let password = passwordTextField.text else {
            error = "Please insert your password".localiz()
            self.passwordTextField.becomeFirstResponder()
            
            return error.isEmpty
        }
        
        if password.validator(type: .Required) == .Required {
            error = "Please insert your password".localiz()
            self.passwordTextField.becomeFirstResponder()
            return error.isEmpty
        }
        
        if password.count < 6 {
            error = "Password must contain at least 6 characters".localiz()
            self.passwordTextField.becomeFirstResponder()
            return error.isEmpty
        }
        
        guard let confirm = confirmPasswordTextField.text else {
            error = "Please insert your confirm password".localiz()
            self.confirmPasswordTextField.becomeFirstResponder()
            
            return error.isEmpty
        }
        
        if confirm.validator(type: .Required) == .Required {
            error = "Please insert your confirm password".localiz()
            self.confirmPasswordTextField.becomeFirstResponder()
            return error.isEmpty
        }
        
        if confirm.count < 6 {
            error = "Password must contain at least 6 characters".localiz()
            self.confirmPasswordTextField.becomeFirstResponder()
            return error.isEmpty
        }
        
        if confirm.validator(type: .NotMatching, otherString: password) == .NotMatching {
            error = "Please make sure the password matches".localiz()
            self.confirmPasswordTextField.becomeFirstResponder()
            return error.isEmpty
        }
        return error.isEmpty
    }
    
    private func locaization() {
        welcomeLabel.text = "Change Your Password".localiz()
        messageLabel.text = "Please enter a new password and confirm password".localiz()
        passwordTextField.placeholder = "Password".localiz()
        confirmPasswordTextField.placeholder = "Confirm password".localiz()
        oldPasswordTextField.placeholder = "Old Password".localiz()
        if typeProcess == .reset {
            nextButton.setTitle("Confirm".localiz(), for: .normal)
        } else {
            nextButton.setTitle("Submit".localiz(), for: .normal)
        }
        
        passwordTextField.textAligment()
        confirmPasswordTextField.textAligment()
        messageLabel.textAligment()
    }
    
    
    @IBAction func Submit(_ sender: Any) {
        if !validation() {
            showToast(message: error)
            return
        }
        var data: [String : String]  = [:]
        if typeProcess == .change {
          data = [:]
          data["old_password"] = oldPasswordTextField.text ?? ""
          data["new_password"] = passwordTextField.text ?? ""
          data["confirmed_password"] = confirmPasswordTextField.text ?? ""

          viewModel.editPassword(data: data) { [weak self] (error) in
            defer {
              self?.stopLoading()
            }

            if error != nil {
              self?.showToast(message: error)
              return
            }
            self?.showToast(message: "Edit Password has been Successfully".localiz())
            self?.navigationController?.popViewController(animated: true)
            
          }
        } else {
          data = [:]
          data["otp_code"] = otpCode
          data["password1"] = passwordTextField.text ?? ""
          data["password2"] = confirmPasswordTextField.text ?? ""
          data["phone_no"] = email

          viewModel.resetPassword(data: data) { [weak self] (error) in
            defer {
              self?.stopLoading()
            }

            if error != nil {
              self?.showToast(message: error)
              return
            }
            let successViewController =  self?.initViewControllerWith(identifier: SuccessViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! SuccessViewController
            successViewController.confige(source: .reset)
            self?.show(successViewController)
          }
        }
    }
}
