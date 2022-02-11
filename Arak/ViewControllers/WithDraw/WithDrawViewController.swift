//
//  WithDrawViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 08/07/2021.
//

import UIKit

class WithDrawViewController: UIViewController {
    @IBOutlet weak var withDrawTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var walletTypeTextField: UITextField!
    @IBOutlet weak var walletTypeLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jodLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var earningValueLabel: UILabel!
    @IBOutlet weak var earningLabel: UILabel!
    
    var viewModel: withDrawViewModel = withDrawViewModel()
    private var walletTypePickerView = ToolbarPickerView()
    private var error = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        genderCustomization()
        walletTypeTextField.addDoneButtonOnKeyboard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localization()
        fetchDigital()
        getBalance()
    }
    
    private func fetchDigital() {
        showLoading()
        viewModel.digitalWallets {[weak self] (error) in
            
            defer {
              self?.stopLoading()
            }

            if error != nil {
              self?.showToast(message: error)
              return
            }
            
            self?.walletTypePickerView.reloadAllComponents()
        }
    }
    
    private func getBalance() {
        fetchBalance { error in
            if error == nil {
                self.earningValueLabel.text = "\(Helper.currentUser?.balanceTitle ?? "")"
            }
        }
    }
    
    private func localization() {
        amountLabel.text = "Amount".localiz()
        withDrawTitleLabel.text = "Withdraw".localiz()
        amountTextField.placeholder = "Enter Amount".localiz()
        earningLabel.text = "Earning".localiz()
        jodLabel.text = "JOD".localiz()
        nameLabel.text = "Name".localiz()
        nameTextField.placeholder = "Enter Name".localiz()
        phoneNumberLabel.text = "Phone Number".localiz()
        phoneTextField.placeholder = "Enter Phone Number".localiz()
        walletTypeLabel.text = "Wallet Type".localiz()
        walletTypeTextField.placeholder = "Select Wallet Type".localiz()
        continueButton.setTitle("Continue".localiz(), for: .normal)
        phoneTextField.delegate = self
    }
    
    @IBAction func Continue(_ sender: Any) {
        if !validation() {
            showToast(message: error)
            return
        }
        
        var data:[String : String] = [:]
        
        data["amount"] = amountTextField.text ?? ""
        data["phone_no"] = phoneTextField.text ?? ""
        data["name"] = nameTextField.text ?? ""
        data["wallet_type"] = walletTypeTextField.text ?? ""
        showLoading()
        viewModel.withDraw(data: data) { [weak self] (error) in
            
            defer {
              self?.stopLoading()
            }

            if error != nil {
              self?.showToast(message: "We apologize, the minimum amount for withdrawal is 5 dinars".localiz())
              return
            }
            
            let vc = self?.initViewControllerWith(identifier: SuccessCheckoutViewController.className, and: "") as! SuccessCheckoutViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.confige(title: "Withdrawal Request Successful".localiz(), description: "Your withdrawal request has been confirmed".localiz(), goString: "Go to My Wallet".localiz()) {
                vc.dismiss(animated: true, completion: nil)
                self?.navigationController?.popViewController(animated: true)
            }
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func validation() -> Bool {
      error = ""
        
        guard let amount = amountTextField.text else {
          error = "Please insert the amount".localiz()
          self.amountTextField.becomeFirstResponder()
          return error.isEmpty
        }

        if amount.validator(type: .Required) == .Required {
          error = "Please insert the amount".localiz()
          self.amountTextField.becomeFirstResponder()
          return error.isEmpty
        }
      guard let name = nameTextField.text else {
        error = "Please insert your name".localiz()
        self.nameTextField.becomeFirstResponder()
        return error.isEmpty
      }

      if name.validator(type: .Required) == .Required {
        error = "Please insert your name".localiz()
        self.nameTextField.becomeFirstResponder()
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
        
        
        return error.isEmpty
    }
    private func setupPickerView() {
       walletTypeTextField.inputView = walletTypePickerView
        walletTypeTextField.delegate = self
        walletTypePickerView.toolbarDelegate = self
        walletTypePickerView.dataSource = self
        walletTypePickerView.delegate = self
        walletTypeTextField.inputAccessoryView = walletTypePickerView.toolbar
        
    }
    
    private func genderCustomization() {
        phoneTextField.semanticContentAttribute = .forceLeftToRight
        phoneTextField.textAlignment = .left
        walletTypeTextField.setRightImage(image: #imageLiteral(resourceName: "arrow_down"))
        setupPickerView()
    }
}
extension WithDrawViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == walletTypeTextField {
      walletTypePickerView.reloadAllComponents()
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
extension WithDrawViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {

    1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return viewModel.walletTypeList.count
  }

  @objc func didTapDone(toolbar: UIToolbar?) {
    if walletTypePickerView.toolbar == toolbar {
      if (walletTypeTextField.text ?? "").isEmpty {
        if !viewModel.walletTypeList.isEmpty {
            walletTypeTextField.text = viewModel.walletTypeList[0].nameTitle
        }
      }
    }
    walletTypeTextField.endEditing(true)
  }

  // return string from picker
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
   
    return viewModel.walletTypeList[row].nameTitle
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if walletTypePickerView == pickerView {
      if !viewModel.walletTypeList.isEmpty {
        walletTypeTextField.text = viewModel.walletTypeList[row].nameTitle
      }
    }
  }

}
extension WithDrawViewController {
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
extension UITextField {

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
