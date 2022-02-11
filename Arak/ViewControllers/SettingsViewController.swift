//
//  SettingsViewController.swift
//  Arak
//
//  Created by Abed Qassim on 30/05/2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var changeLanguageLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var generalTitleLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var termsAndConditionsLabell: UILabel!
    @IBOutlet weak var aboutUsLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var englishView: UIView!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var arabicView: UIView!
    @IBOutlet weak var legalLabel: UILabel!
    @IBOutlet weak var feedbackItemLabel: UILabel!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var arabicStackView: UIStackView!
    @IBOutlet weak var englishStackView: UIStackView!
    @IBOutlet weak var arabicButton: UIButton!
    @IBOutlet weak var arabicLabel: UILabel!
    @IBOutlet weak var needHelpLabel: UILabel!
    
    
    private var viewModel = NotificationViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        localization()
        englishStackView.isHidden = true
        arabicStackView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationSwitch.setOn(Helper.isEnabelNotification, animated: true)
    }
    
    private func localization() {
        changeLanguageLabel.text = "Change Language".localiz()
        notificationLabel.text = "Notifications".localiz()
        generalTitleLabel.text = "General".localiz()
        feedbackLabel.text = "Feedback".localiz()
        termsAndConditionsLabell.text = "Terms & Conditions".localiz()
        aboutUsLabel.text = "About Us".localiz()
        privacyPolicyLabel.text = "Privacy Policy".localiz()
        legalLabel.text = "Legal".localiz()
        needHelpLabel.text = "Need Help?".localiz()
        arabicView.backgroundColor = Helper.appLanguage ?? "en" == "ar" ? #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1) : .clear
        englishView.backgroundColor = Helper.appLanguage ?? "en" == "en" ? #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1) : .clear
        arabicButton.isHidden = Helper.appLanguage ?? "en" != "ar"
        englishButton.isHidden = Helper.appLanguage ?? "en" != "en"
        feedbackLabel.text = "Feedback".localiz()
        feedbackItemLabel.text = "Feedback".localiz()
        title = "Settings".localiz()
        
    }
    @IBAction func English(_ sender: Any) {
        if Helper.appLanguage ?? "en" == "en" {
            return
        }
        Helper.appLanguage = "en"
        LocaleManager.apply(identifier:  Helper.appLanguage)
        englishStackView.isHidden = true
        arabicStackView.isHidden = true
    }
    
    @IBAction func Arabic(_ sender: Any) {
        if Helper.appLanguage ?? "en" == "ar" {
            return
        }
        Helper.appLanguage = "ar"
        LocaleManager.apply(identifier:  Helper.appLanguage)
        englishStackView.isHidden = true
        arabicStackView.isHidden = true
    }
    @IBAction func ChangeNotification(_ sender: Any) {
        viewModel.toggleNotification { error in
            if error == nil {
                
            }
        }
        
    }
    
    @IBAction func ChangeLanguage(_ sender: Any) {
        englishStackView.isHidden =  !englishStackView.isHidden
        arabicStackView.isHidden =  !arabicStackView.isHidden
    }
    
    @IBAction func Terms(_ sender: Any) {
        let arakStaticViewController = initViewControllerWith(identifier: ArakStaticViewController.className, and: "",storyboardName: Storyboard.Main.rawValue) as! ArakStaticViewController
        arakStaticViewController.confige(descriptionText: Helper.arakLinks?.terms ?? "", arakStatic: .terms)
        show(arakStaticViewController)
    }
    @IBAction func AboutUs(_ sender: Any) {
        let arakStaticViewController = initViewControllerWith(identifier: ArakStaticViewController.className, and: "",storyboardName: Storyboard.Main.rawValue) as! ArakStaticViewController
        arakStaticViewController.confige(descriptionText: Helper.arakLinks?.about ?? "", arakStatic: .aboutUs)
        show(arakStaticViewController)
    }
    @IBAction func PrivacyPolicy(_ sender: Any) {
        let arakStaticViewController = initViewControllerWith(identifier: ArakStaticViewController.className, and: "",storyboardName: Storyboard.Main.rawValue) as! ArakStaticViewController
        arakStaticViewController.confige(descriptionText: Helper.arakLinks?.privacy ?? "", arakStatic: .privcy)
        show(arakStaticViewController)
    }
    @IBAction func Feedback(_ sender: Any) {
        let vc = initViewControllerWith(identifier: FeedbackViewController.className, and: "") as! FeedbackViewController
        show(vc)
    }
    @IBAction func NeedHelp(_ sender: Any) {
    }
}
