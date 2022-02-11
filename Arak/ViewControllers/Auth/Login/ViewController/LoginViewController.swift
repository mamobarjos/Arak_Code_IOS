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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    @IBOutlet weak var loginFacebookLabel: UILabel!
    @IBOutlet weak var loginGoogleLabel: UILabel!
    @IBOutlet weak var loginAppleLabel: UILabel!
    @IBOutlet weak var loginGuestLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var orButton: UIButton!
    @IBOutlet weak var hasAccountLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: LoginViewModel = LoginViewModel()
    var signUpViewModel: SignUpViewModel = SignUpViewModel()
    var error = ""
    fileprivate var currentNonce: String?
    
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        socialDelegate = self
        setupUI()
        self.setupHideKeyboardOnTap()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: true)
    }
    
    // MARK: - Protected Methods
    private func setupUI() {
        localization()
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    
    private func localization() {
        welcomeLabel.text = "Welcome".localiz()
        emailTextField.placeholder = "Email".localiz()
        passwordTextField.placeholder = "Password".localiz()
        logInButton.setTitle("Log in".localiz(), for: .normal)
        forgetPasswordLabel.text = "Forgot password?".localiz()
        orButton.setTitle("OR".localiz(), for: .normal)
        loginFacebookLabel.text = "Log in with Facebook".localiz()
        loginGoogleLabel.text = "Log in with Google".localiz()
        loginAppleLabel.text = "Log in with Apple".localiz()
        hasAccountLabel.text = "Don't have an account? ".localiz() + "Sign up".localiz()
        hasAccountLabel.setSubTextColor(pSubString: "Sign up".localiz(), pColor: #colorLiteral(red: 1, green: 0.431372549, blue: 0.1803921569, alpha: 1))
        loginGuestLabel.text = "Login as a guest".localiz()
        alertLabel.text = "Join us and be one of the thousands of registered members".localiz()
        
        welcomeLabel.textAligment()
        emailTextField.textAligment()
        passwordTextField.textAligment()
    }
    
    private func validation() -> Bool {
        error = ""
        
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
        viewModel.login(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] (error) in
            
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
    }
    
    @IBAction func ForgetPassword(_ sender: Any) {
        let forget = initViewControllerWith(identifier: ForgetPasswordViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue)
        show(forget)
    }
    
    
    @IBAction func FaceebookLogin(_ sender: Any) {
        signInFacebook()
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
        data["social_token"] = socialMedia?.socialId ?? ""
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
