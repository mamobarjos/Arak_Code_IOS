//
//  EditPhoneNumberViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 06/07/2021.
//

import UIKit

class EditPhoneNumberViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneNumberExtention: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!

    private var error = ""
    private var signUpViewModel = SignUpViewModel()

    private var countryPickerView = ToolbarPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        localization()
        getCountry()
        setupPickerView()
        emailContainerView.isHidden = true
    }

    private func localization() {
        nextButton.setTitle("Next".localiz(), for: .normal)
        phoneTextField.placeholder = "xxxxxxxxx"
        messageLabel.text = "Please enter new phone number".localiz()
        titleLabel.text = "Change Phone Number".localiz()
        phoneTextField.delegate = self
        phoneTextField.semanticContentAttribute = .forceLeftToRight
        phoneTextField.textAlignment = .left
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
        navigationController?.navigationBar.transparentNavigationBar()
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

    @IBAction func Next(_ sender: Any) {
        if !validation() {
            self.showToast(message: error)
            return
        }
        var data:[String : String] = [:]
        data["phone_no"] = "\(phoneNumberExtention.text ?? "+962")" + (phoneTextField.text ?? "")
        //        data["old_phone"] = Helper.currentUser?.phoneNo ?? ""
        data["email"] = emailTextField.text ?? ""

        signUpViewModel.otp(data: data) {  [weak self] (error) in
            defer {
                self?.stopLoading()
            }

            if error != nil {
                self?.showToast(message: error)
                return
            }
            let vc = self?.initViewControllerWith(identifier: OtpViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! OtpViewController
            vc.confige(email: "", processType: .changePhone, data: data, registerData: data)
            self?.show(vc)

        }
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
//            error = "Phone Number Should not been less than 9 digits".localiz()
//            self.phoneTextField.becomeFirstResponder()
//            return error.isEmpty
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
}

extension EditPhoneNumberViewController:UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == phoneTextField {
//            let maxLength = 9
//            let currentString: NSString = (textField.text ?? "") as NSString
//            let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//            return newString.length <= maxLength
//        }
//        return true
//    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        countryPickerView.reloadAllComponents()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditPhoneNumberViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {

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
