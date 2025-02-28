//
//  LoginViewController.swift
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

class LoginViewController: UIViewController, SocialDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    @IBOutlet weak var loginFacebookLabel: UILabel!
    @IBOutlet weak var loginGoogleLabel: UILabel!
    @IBOutlet weak var loginAppleLabel: UILabel!
    @IBOutlet weak var loginGuestLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var faceIdImageView: UIImageView!
    @IBOutlet weak var orButton: UIButton!
    @IBOutlet weak var hasAccountLabel: UILabel!
    @IBOutlet weak var phoneNumberExtention: UITextField!
    
    // MARK: - Properties
    let keyChain = KeychainPasswordStoreService()
    let faceIDAuthenticatorService = DefaultFaceIDAuthenticatorService()
    var viewModel: LoginViewModel = LoginViewModel()
    var signUpViewModel: SignUpViewModel = SignUpViewModel()
    var notificationViewModel: NotificationViewModel = NotificationViewModel()
    private var countryPickerView = ToolbarPickerView()
    var error = ""
    fileprivate var currentNonce: String?
    
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        socialDelegate = self
        setupUI()
        getCountry() 
        setupPickerView() 
        self.setupHideKeyboardOnTap()
        notificationViewModel.getStaticLinks { _ in }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: true)
    }
    
    // MARK: - Protected Methods
    private func setupUI() {
        localization()
//        GIDSignIn.sharedInstance().presentingViewController = self
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
    
    private func localization() {
        welcomeLabel.text = "Welcome".localiz()
        phoneNumberTextField.placeholder = "Phone Number".localiz()
        passwordTextField.placeholder = "Password".localiz()
        logInButton.setTitle("Log in".localiz(), for: .normal)
        forgetPasswordLabel.text = "Forgot password?".localiz()
        orButton.setTitle("OR".localiz(), for: .normal)
        loginFacebookLabel.text = "Log in with Facebook".localiz()
        loginGoogleLabel.text = "Log in with Google".localiz()
        loginAppleLabel.text = "Sign in with Apple".localiz()
        hasAccountLabel.text = "Don't have an account? ".localiz() + "Sign up".localiz()
        
        hasAccountLabel.setSubTextColor(pSubString: "Sign up".localiz(), pColor: #colorLiteral(red: 1, green: 0.431372549, blue: 0.1803921569, alpha: 1))
        loginGuestLabel.text = "Login as a guest".localiz()
        alertLabel.text = "Join us and be one of the thousands of registered members".localiz()
        
        welcomeLabel.textAligment()
        phoneNumberTextField.textAligment()
        passwordTextField.textAligment()
        
        print(keyChain.retriveCredentials()?.password)
        print(keyChain.retriveCredentials()?.phoneNumber)
        if keyChain.retriveCredentials()?.phoneNumber.isEmpty == true || keyChain.retriveCredentials() == nil {
            faceIdImageView.isHidden = true
        } else {
            faceIdImageView.isHidden = false
        }
        
        faceIdImageView.addTapGestureRecognizer {[weak self] in
            self?.faceIDAuthenticatorService.evaluate(completion: {pass, _ in
                guard pass else {return}
                
                self?.showLoading()
                
                let credentials = self?.keyChain.retriveCredentials()
                self?.viewModel.login(phone: credentials?.phoneNumber ?? "", password: credentials?.password ?? "" ) { [weak self] (error) in
                    
                    defer {
                        self?.stopLoading()
                    }
                    
                    if error != nil {
                        self?.showToast(message: error)
                        return
                    }
                    let tabBarViewController = self?.initViewControllerWith(identifier: BubbleTabBarController.className, and: "") as! BubbleTabBarController
                    tabBarViewController.modalPresentationStyle = .fullScreen
                    let navigationRoot = UINavigationController(rootViewController: tabBarViewController)
                    navigationRoot.modalPresentationStyle = .fullScreen
                    self?.present(navigationRoot)
                }
            })
        }
    }
    
    private func validation() -> Bool {
        error = ""
        
        guard let phone = phoneNumberTextField.text else {
            error = "Please insert your phone number".localiz()
            self.phoneNumberTextField.becomeFirstResponder()
            
            return error.isEmpty
        }
        if phone.validator(type: .PhoneNumber) == .Required {
            error = "Please insert your phone number".localiz()
            self.phoneNumberTextField.becomeFirstResponder()
            return error.isEmpty
        }
        if phone.validator(type: .PhoneNumber) == .Email {
            error = "Phone Number Should not been less than 9 digits".localiz()
            self.phoneNumberTextField.becomeFirstResponder()
            
            return error.isEmpty
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
        
        
        return true
    }
    @IBAction func LoginGuest(_ sender: Any) {
        Helper.userType = Helper.UserType.GUEST.rawValue
        let tabBarViewController = self.initViewControllerWith(identifier: BubbleTabBarController.className, and: "") as! BubbleTabBarController
        tabBarViewController.modalPresentationStyle = .fullScreen
        let navigationRoot = UINavigationController(rootViewController: tabBarViewController)
        navigationRoot.modalPresentationStyle = .fullScreen
        self.present(navigationRoot)
    }
    
    
    
    @IBAction func Login(_ sender: Any) {
        if !validation() {
            self.showToast(message: error)
            return
        }
        showLoading()
        var validPhone = phoneNumberTextField.text!
        if validPhone.starts(with: "00") {
            validPhone = "\(validPhone.dropFirst(2))"
        }
        if validPhone .starts(with: "0") {
            validPhone = "\(validPhone.dropFirst(1))"
        }
        
        if  validPhone.count <= 9 {
            validPhone = (phoneNumberExtention.text ?? "+962") + validPhone
        }
        viewModel.login(phone: validPhone, password: passwordTextField.text!) { [weak self] (error) in
            
            defer {
                self?.stopLoading()
            }
            
            if error != nil {
                self?.showToast(message: error)
                return
            }
            let tabBarViewController = self?.initViewControllerWith(identifier: BubbleTabBarController.className, and: "") as! BubbleTabBarController
            tabBarViewController.modalPresentationStyle = .fullScreen
            let navigationRoot = UINavigationController(rootViewController: tabBarViewController)
            navigationRoot.modalPresentationStyle = .fullScreen
            self?.present(navigationRoot)
            self?.keyChain.save(credentials: .init(
                phoneNumber: validPhone,
                password: self?.passwordTextField.text ?? ""))
        }
    }
    
    @IBAction func ForgetPassword(_ sender: Any) {
        let forget = initViewControllerWith(identifier: ForgetPasswordViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue)
        show(forget)
    }


    @IBAction func FaceebookLogin(_ sender: Any) {
//        signInFacebook()
    }
    @IBAction func GoogleLogin(_ sender: Any) {
        signInGoogle()
    }
    @available(iOS 13, *)
    @IBAction func Apple(_ sender: Any) {
        startSignInWithAppleFlow()
    }
    
    @IBAction func Register(_ sender: Any) {
        let signUp = initViewControllerWith(identifier: SignUpViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue)
        show(signUp)
    }
    
    
}


extension LoginViewController {
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
    
    func signInGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            
            // If sign-in succeeded, display the app's main content View.
            if let user = signInResult?.user {
                print("User signed in: \(user.userID ?? "No name")")

                    let soicalMedia = SocialMedia(socialId: user.userID ?? "", email: user.profile?.email ?? "", phone: SocialError.PhoneNotFound.rawValue, displayName: user.profile?.name ?? "", imageUrl: "", socialToken: user.userID ?? "", type: .Google)
                    socialDelegate?.signIn(socialMedia: soicalMedia)
            }
        }   
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
extension LoginViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
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
                let soicalMedia = SocialMedia(socialId: appleIDCredential.user, email: email, phone: SocialError.PhoneNotFound.rawValue, displayName: "", imageUrl: "", socialToken: idTokenString, type: .Apple)
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

extension LoginViewController {
    func checkSocialUser(socialMedia: SocialMedia?) {
        var data:[String : String] = [:]
        data["idToken"] = socialMedia?.socialId ?? ""
        showLoading()
        signUpViewModel.socialRegisterLogin(data: data) { [weak self] (error) in
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

extension LoginViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
        countryPickerView.reloadAllComponents()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension LoginViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return signUpViewModel.countryList.count
  }

  @objc func didTapDone(toolbar: UIToolbar?) {
      if phoneNumberExtention.text?.isEmpty ?? false {
          phoneNumberExtention.text = signUpViewModel.countryList.first?.countryCode
      }
      phoneNumberExtention.endEditing(true)
  }

  // return string from picker
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      signUpViewModel.countryList[row].countryCode
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      phoneNumberExtention.text = signUpViewModel.countryList[row].countryCode
  }
}
