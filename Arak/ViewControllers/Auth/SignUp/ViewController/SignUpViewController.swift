
//  SignUpViewController.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//
//

import UIKit
import Foundation
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn
import JWTDecode
import FBSDKLoginKit

class SignUpViewController: UIViewController,SocialDelegate {

  // MARK: - Outlets

  @IBOutlet weak var joinArakLabel: UILabel!
  @IBOutlet weak var fullNameTextField: UITextField!
  @IBOutlet weak var dateTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var termsPrivacyLabel: UILabel!
  @IBOutlet weak var genderTextField: UITextField!
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var countryTextField: UITextField!

//    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var orButton: UIButton!
//  @IBOutlet weak var loginFacebookLabel: UILabel!
//  @IBOutlet weak var loginGoogleLabel: UILabel!
//  @IBOutlet weak var loginAppleLabel: UILabel!
  @IBOutlet weak var hasAccountLabel: UILabel!

    @IBOutlet weak var yesImage: UIImageView!
    @IBOutlet weak var noImage: UIImageView!
//    @IBOutlet weak var loginView: UIView!
    
  // MARK: - Properties
  private let datePicker = UIDatePicker()
  private var genderPickerView = ToolbarPickerView()
  private var countryPickerView = ToolbarPickerView()
  private var cityPickerView = ToolbarPickerView()

  private var error = ""
  fileprivate var currentNonce: String?
  var countryId = -1
  var cityId = -1

  var viewModel: SignUpViewModel = SignUpViewModel()
var haveWallet = -1

  // MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
//      if let token = AccessToken.current,
//          !token.isExpired {
//          let token = token.tokenString
//          let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: token,version: nil ,httpMethod: .get)
//          request.start {connection, result , error in
////              LoginManager().logOut()
////              print(result)
//          }
//      }else{
//          let facebookBtn = FBLoginButton()
//          facebookBtn.delegate = self
//          facebookBtn.permissions = ["public_profile", "email"]
//          loginView.addSubview(facebookBtn)
//          facebookBtn.translatesAutoresizingMaskIntoConstraints = false
//          facebookBtn.bottomAnchor.constraint(equalTo: loginView.bottomAnchor).isActive = true
//          facebookBtn.leadingAnchor.constraint(equalTo: loginView.leadingAnchor).isActive = true
//          facebookBtn.trailingAnchor.constraint(equalTo: loginView.trailingAnchor).isActive = true
//          facebookBtn.topAnchor.constraint(equalTo: loginView.topAnchor).isActive = true
//          facebookBtn.layer.masksToBounds = true
//          facebookBtn.layer.cornerRadius = 10
//          facebookBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
//          facebookBtn.setImage(nil, for: .normal)
//          
//      }
    socialDelegate = self
    phoneNumberTextField.semanticContentAttribute = .forceLeftToRight
    phoneNumberTextField.textAlignment = .left
    setupUI()
      setupDatePicker()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hiddenNavigation(isHidden: false)
    navigationController?.navigationBar.transparentNavigationBar()
  }

  // MARK: - Protected Methods
  private func setupUI() {
    setupPickerView()
    localization()
    gestureTermsAndPrivacy()
    genderCustomization()
    getCountry()
    self.setupHideKeyboardOnTap()
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
        dateTextField.inputView = datePicker
        
        // Set the toolbar as the input accessory view for the text field
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc private func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func doneTapped() {
        // Dismiss the date picker
        dateTextField.resignFirstResponder()
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
        if haveWallet == -1 {
            error = "Please insert your wallet status".localiz()
            return error.isEmpty
        }
        
//      guard let email = emailTextField.text else {
//        error = "Please insert your email".localiz()
//        self.emailTextField.becomeFirstResponder()
//
//        return error.isEmpty
//      }
        
//      if email.validator(type: .Email) == .Required {
//        error = "Please insert your email".localiz()
//        self.emailTextField.becomeFirstResponder()
//        return error.isEmpty
//      }
//      if email.validator(type: .Email) == .Email {
//        error = "You have entered an invalid email address!".localiz()
//        self.emailTextField.becomeFirstResponder()
//
//        return error.isEmpty
//      }

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
//        guard let gender = genderTextField.text else {
//          error = "Please insert your gender".localiz()
//          self.genderTextField.becomeFirstResponder()
//          return error.isEmpty
//        }

//        if gender.validator(type: .Required) == .Required {
//          error = "Please insert your gender".localiz()
//          self.genderTextField.becomeFirstResponder()
//          return error.isEmpty
//        }
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
        if countryId == -1 {
          error = "Please select country".localiz()
          return error.isEmpty
        }
        if cityId == -1 {
          error = "Please select city".localiz()
          return error.isEmpty
        }
        return error.isEmpty

    }

  private func setupPickerView() {
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

    joinArakLabel.text = "Join Arak".localiz()
    fullNameTextField.placeholder = "Full Name".localiz()
    dateTextField.placeholder = "Date of birth".localiz()
    passwordTextField.placeholder = "Password".localiz()
    confirmPasswordTextField.placeholder = "Confirm password".localiz()
    genderTextField.placeholder = "Gender".localiz()
    phoneNumberTextField.placeholder = "xxxxxxxxx"
    cityTextField.placeholder = "City".localiz()
    countryTextField.placeholder = "Country".localiz()
    termsPrivacyLabel.text = "By signing up, you agree to our Terms & Conditions and Privacy Policy .".localiz()
    signUpButton.setTitle("Sign up".localiz(), for: .normal)
    orButton.setTitle("OR".localiz(), for: .normal)
//    loginFacebookLabel.text = "Log in with Facebook".localiz()
//    loginGoogleLabel.text = "Log in with Google".localiz()
//    loginAppleLabel.text = "Sign in with Apple".localiz()
//    businessNameTextField.placeholder = "Business Name".localiz()
    hasAccountLabel.text = "Have an account? ".localiz() + "Log in".localiz()
    hasAccountLabel.setSubTextColor(pSubString: "Log in".localiz(), pColor: #colorLiteral(red: 1, green: 0.431372549, blue: 0.1803921569, alpha: 1))

    joinArakLabel.textAligment()
//    emailTextField.textAligment()
    passwordTextField.textAligment()
    confirmPasswordTextField.textAligment()
    fullNameTextField.textAligment()
    genderTextField.textAligment()
    phoneNumberTextField.textAligment()
    cityTextField.textAligment()
    countryTextField.textAligment()
//    businessNameTextField.textAligment()
    phoneNumberTextField.delegate = self

  }

  private func getCountry() {
    viewModel.getCountry { _ in

      self.countryPickerView.reloadAllComponents()

    }
  }

  private func getCity() {
    viewModel.getCity(by: countryId) { _ in
      self.cityPickerView.reloadAllComponents()
    }
  }

  @IBAction func SignUp(_ sender: Any) {
      print(haveWallet)

    if !validation() {
      showToast(message: error)
      return
    }
    let data: [String: String] =  [
        "fullname": fullNameTextField.text ?? "",
        "password": passwordTextField.text ?? "" ,
        "birthdate": dateTextField.text ?? "",
        "phone_no" : "+962" + (phoneNumberTextField.text ?? "")
                                   , "password_confirmation" : confirmPasswordTextField.text ?? "" , "gender" : genderTextField.text ?? "" , "city" : cityTextField.text ?? "" , "country" : countryTextField.text ?? "", "has_wallet": "\(haveWallet)"]
    print(data)
    var otpData:[String : String] = [:]
    otpData["phone_no"] = "+962" + (phoneNumberTextField.text ?? "")
    self.signUpButton.isUserInteractionEnabled = false
    showLoading()
    viewModel.otp(data: otpData) {  [weak self] (error) in
      defer {
        self?.stopLoading()
      }
      self?.signUpButton.isUserInteractionEnabled = true
      if error != nil {
        self?.showToast(message: error)
        return
      }
      let vc = self?.initViewControllerWith(identifier: OtpViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! OtpViewController
        print(data)
      vc.confige(email: "", processType: .register, data: data)
      self?.show(vc)
    }
  }

  @IBAction func Login(_ sender: Any) {
    dismissViewController()
  }
  
  private func gestureTermsAndPrivacy() {
    let attributedWithTextColor: NSAttributedString = "By signing up, you agree to our Terms & Conditions and Privacy Policy".localiz().attributedStringWithColor(["Terms & Conditions".localiz(), "Privacy Policy".localiz()], color: #colorLiteral(red: 1, green: 0.431372549, blue: 0.1803921569, alpha: 1))
    termsPrivacyLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
    termsPrivacyLabel.attributedText = attributedWithTextColor
    termsPrivacyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
  }

  @objc func handleTapOnLabel(_ gesture: UITapGestureRecognizer) {
    guard  let text = termsPrivacyLabel.text else {
      return
    }
    let termsRange = (text as NSString).range(of: "Terms & Conditions".localiz())
    let privacyRange = (text as NSString).range(of: "Privacy Policy".localiz())
    let arakStaticViewController = initViewControllerWith(identifier: ArakStaticViewController.className, and: "",storyboardName: Storyboard.Main.rawValue) as! ArakStaticViewController

    if gesture.didTapAttributedTextInLabel(label: termsPrivacyLabel, inRange: termsRange) {
      print("Tapped terms")
      arakStaticViewController.confige(descriptionText: Helper.arakLinks?.terms ?? "", arakStatic: .terms)
      show(arakStaticViewController)
    } else if gesture.didTapAttributedTextInLabel(label: termsPrivacyLabel, inRange: privacyRange) {

        arakStaticViewController.confige(descriptionText: Helper.arakLinks?.privacy ?? "", arakStatic: .privcy)
        show(arakStaticViewController)
    }
  }

    @IBAction func yesTapped(_ sender: Any) {
        yesImage.image = UIImage(named: "Check (1)")
        noImage.image = UIImage(named: "check 1")
        haveWallet = 1
    }
    
    @IBAction func noTapped(_ sender: Any) {
        yesImage.image = UIImage(named: "check 1" )
        noImage.image = UIImage(named: "Check (1)")
        haveWallet = 0
    }
}

extension SignUpViewController: UITextFieldDelegate {

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
extension SignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {

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
  @IBAction func FaceebookLogin(_ sender: Any) {
//    signInFacebook()
      
   
  }
  @IBAction func GoogleLogin(_ sender: Any) {
//    signInGoogle()
  }
  @available(iOS 13, *)
  @IBAction func Apple(_ sender: Any) {
    startSignInWithAppleFlow()
  }
}


extension SignUpViewController {
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }

      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }

        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }

    return result
  }

  @available(iOS 13, *)
  func startSignInWithAppleFlow() {
    let nonce = randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  @available(iOS 13, *)
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      return String(format: "%02x", $0)
    }.joined()

    return hashString
  }


}
@available(iOS 13.0, *)
extension SignUpViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    self.view.window!
  }


  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard currentNonce != nil else {
        print("Invalid state: A login callback was received, but no login request was sent.")
        socialDelegate?.error(socialError: .General)
        return
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        socialDelegate?.error(socialError: .General)
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        socialDelegate?.error(socialError: .General)
        return
      }
      do {
        let jwtToken:[String: Any] = try JWTDecode.decode(jwt: idTokenString).body
        let isPrivateEmail = jwtToken["is_private_email"] as? Bool ?? true
        var email:String = jwtToken["email"] as? String ?? SocialError.EmailNotFound.rawValue
        email = isPrivateEmail ? SocialError.EmailNotFound.rawValue : email
        let soicalMedia = SocialMedia(socialId: appleIDCredential.user, email: "", phone: "", displayName: "", imageUrl: "", socialToken: idTokenString, type: .Apple)
          print(soicalMedia)
        socialDelegate?.signIn(socialMedia: soicalMedia)
      } catch let err {
        print(err.localizedDescription)
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
extension SignUpViewController {
  func checkSocialUser(socialMedia: SocialMedia?) {
    var data:[String : String] = [:]
    data["social_token"] = socialMedia?.socialId ?? ""
    showLoading()
    viewModel.socialRegisterLogin(data: data) { [weak self] (error) in
      defer {
        self?.stopLoading()
      }

      guard let self = self else { return }
      if error != nil {
        if let email = socialMedia?.email , let phone = socialMedia?.phone {
          if email == SocialError.EmailNotFound.rawValue || phone   == SocialError.PhoneNotFound.rawValue {
            let vc = self.initViewControllerWith(identifier: SocialMediaAuthViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! SocialMediaAuthViewController
            vc.confige(soicalMedia: socialMedia)
            self.show(vc)
          }
        }
        return
      }
      let vc = self.initViewControllerWith(identifier: BubbleTabBarController.className, and: "") as! BubbleTabBarController
      self.show(vc)
    }
  }
  func signIn(socialMedia: SocialMedia?) {
    checkSocialUser(socialMedia: socialMedia)
  }

  func error(socialError: SocialError?) {
    print(socialError?.rawValue)
  }
}
extension SignUpViewController {
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
extension SignUpViewController : LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        print(token)
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: token,version: nil ,httpMethod: .get)
        request.start { connection, user, requestError in
//            if let tabBarVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar") as? MainTabBar {
//                if let accessToken = AccessToken.current?.tokenString {
//                    NetworkManager().FacebookloginRequest(access_token: accessToken) { (error, isSuccess, mess) in
//                        LoginManager().logOut()
//                        self.SetDeviceDataRegister()
//                        let nextVC = UINavigationController(rootViewController: tabBarVc)
//                        nextVC.modalPresentationStyle = .fullScreen
//                        self.present(nextVC, animated: true, completion: nil)
//                    }
//                }
//            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
}
