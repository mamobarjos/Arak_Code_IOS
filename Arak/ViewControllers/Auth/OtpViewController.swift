//
//  OtpViewController.swift
//  Joyin
//
//  Created by Abed Qassim on 04/04/2021.
//

import UIKit
import OTPFieldView
class OtpViewController: UIViewController {

  enum ProcessType {
    case register
    case forgot
    case changePhone
  }

  @IBOutlet weak var resendCodeLabel: UILabel!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var otpView: OTPFieldView!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var titleMessageLabel: UILabel!
  @IBOutlet weak var verificationCodeTitleLabel: UILabel!

  private var seconds = 90
  var countDownTimer = Timer()
  private var otpString = ""
  private var originalNumber = ""
  private var oldNumber: String = ""
  private var processType: ProcessType = .register
    private var data:[String : String] = [:]
    private var registerData:[String : Any] = [:]
    private var viewModel = SignUpViewModel()
  private var profileViewModel = ProfileViewModel()
    
    let keyChain = KeychainPasswordStoreService()
  override func viewDidLoad() {
        super.viewDidLoad()
    setup()
  }

  func confige(email: String,processType: ProcessType,data:[String : String] = [:], registerData:[String : Any] = [:]) {
    self.processType = processType
      print(data)
      self.data = data
      self.registerData = registerData
      self.data["phone_no"] = registerData["phone_no"] as? String
      self.oldNumber = data["old_phone"] ?? ""
  }

  private func setup() {
    clearItemsBar()
    if processType == .register || processType == .changePhone {
        let mobileNumer = data["phone_no"] ?? ""
        guard mobileNumer.count > 5 else {
          emailLabel.text = mobileNumer
          return
        }
        self.originalNumber = mobileNumer
        let startingIndex = mobileNumer.index(mobileNumer.startIndex, offsetBy: 3)
        let endingIndex = mobileNumer.index(mobileNumer.endIndex, offsetBy: -2)
        let stars = String(repeating: "*", count: mobileNumer.count - 5)
        let result = mobileNumer.replacingCharacters(in: startingIndex..<endingIndex,
                with: stars)
        emailLabel.text = result
        
    } else {
      let mobileNumer = data["phone_no"] ?? ""
      guard mobileNumer.count > 5 else {
        emailLabel.text = mobileNumer
        return
      }
        self.originalNumber = mobileNumer
      let startingIndex = mobileNumer.index(mobileNumer.startIndex, offsetBy: 3)
      let endingIndex = mobileNumer.index(mobileNumer.endIndex, offsetBy: -2)
      let stars = String(repeating: "*", count: mobileNumer.count - 5)
      let result = mobileNumer.replacingCharacters(in: startingIndex..<endingIndex,
              with: stars)
      emailLabel.text = result
    }
    resendCodeLabel.isHidden = true
    setupTimer()
    localization()
    setupOtpView()
    resendCodeLabel.addTapGestureRecognizer {
      if self.seconds > 0 {
        return
      }
      if self.processType == .register  {
        self.chageRegisterStatusButton(isEnable: false)
        self.showLoading()
        self.viewModel.otp(data: ["phone_no" : self.data["phone_no"] ?? ""]) { [weak self] (error) in
          defer {
            self?.chageRegisterStatusButton(isEnable: true)
            self?.stopLoading()
          }
          self?.setupTimer()
        }
      } else if self.processType == .changePhone  {
        self.showLoading()
        self.chageRegisterStatusButton(isEnable: false)
        self.viewModel.otp(data: ["phone_no" : self.data["phone_no"] ?? ""]) { [weak self] (error) in
          defer {
            self?.chageRegisterStatusButton(isEnable: true)
            self?.stopLoading()
          }
          self?.setupTimer()
        }
      }  else {
        self.showLoading()
        self.chageRegisterStatusButton(isEnable: false)
        self.viewModel.otp(data: ["phone_no" : self.data["phone_no"] ?? ""]) {  [weak self] (error) in
          defer {
            self?.chageRegisterStatusButton(isEnable: true)
            self?.stopLoading()
          }
          if error != nil {
            self?.showToast(message: error)
            return
          }
          self?.setupTimer()
        }
      }

    }
    submitButton.addTapGestureRecognizer {
      if self.otpString.isEmpty {
        self.showToast(message: "Please Insert the otp".localiz())
        return
      }
      if self.seconds <= 0 {
        self.showToast(message: "Please enter the verification code sent to your mobile number".localiz())
        return
      }
        self.chageRegisterStatusButton(isEnable: false)
      if self.processType == .register {
        self.registerData["otp_code"] = self.otpString
        self.viewModel.register(data: self.registerData) { [weak self] (error) in
          defer {
            self?.chageRegisterStatusButton(isEnable: true)
            self?.stopLoading()
          }
          if error != nil {
            self?.showToast(message: error)
            return
          }

            let vc = InterestsViewController.loadFromNib()
            self?.show(vc)
        }
      } else if self.processType == .changePhone  {
        self.showLoading()
        self.chageRegisterStatusButton(isEnable: false)
        self.viewModel.changePhone(data: ["phone_no" : self.originalNumber,"otp_code" : self.otpString]) { [weak self] (error) in
          defer {
            self?.chageRegisterStatusButton(isEnable: true)
            self?.stopLoading()
          }
            if error != nil {
                self?.showToast(message: error ?? "")
                return
            }
          self?.showToast(message: "The modification has been completed successfully".localiz())
          var user = Helper.currentUser
            user?.phoneNo = self?.originalNumber
          Helper.currentUser =  user
            
            self?.keyChain.save(credentials: .init(
                phoneNumber:  self?.originalNumber ?? "",
                password: self?.keyChain.retriveCredentials()?.password ?? ""))
          self?.navigationController?.popToViewController(ofClass: EditProfileViewController.self)
        }
      }
      else {
        let vc = self.initViewControllerWith(identifier: ResetPasswordViewController.className, and: "",storyboardName: Storyboard.Auth.rawValue) as! ResetPasswordViewController
        vc.config(type: .reset,email: self.originalNumber , otpCode: self.otpString)
        self.show(vc)
      }
    }
  }
  
  private func localization() {
    resendCodeLabel.text = "Resend Code".localiz()
    submitButton.setTitle("Next".localiz(), for: .normal)
    titleMessageLabel.text = "Please enter Code sent to".localiz()
    verificationCodeTitleLabel.text = "Verification Code".localiz()
    timerLabel.text = ""
    submitButton.addRoundedCorners(cornerRadius: 10)
  }
    private func chageRegisterStatusButton(isEnable: Bool) {
        submitButton.isUserInteractionEnabled = isEnable
    }

  func setupOtpView(){
          self.otpView.fieldsCount = 4
          self.otpView.defaultBorderColor = .black
          self.otpView.cursorColor = .black
          self.otpView.displayType = .underlinedBottom
          self.otpView.fieldSize = 40
          self.otpView.separatorSpace = 24
          self.otpView.fieldBorderWidth = 2
          self.otpView.shouldAllowIntermediateEditing = false
          self.otpView.delegate = self
          self.otpView.initializeUI()
      }

  private func setupTimer() {
    seconds = 90
    countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

  }

  private func cancelTimer() {
    countDownTimer.invalidate()
    countDownTimer = Timer()
  }
  @objc func updateTimer() {
    seconds -= 1
    if seconds <= 0 {
      timerLabel.text = "\(0) " + "second left".localiz()
      resendCodeLabel.isHidden = false
      self.cancelTimer()
    } else {
      resendCodeLabel.isHidden = true
      timerLabel.text = "\(seconds) " + "second left".localiz()
    }
  }


}
extension OtpViewController: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }

    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }

    func enteredOTP(otp otpString: String) {
      self.otpString = otpString
        print("OTPString: \(otpString)")
    }
}
