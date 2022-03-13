//
//  SocialMediaSignUPViewController.swift
//  Arak
//
//  Created by Osama Abu hdba on 23/02/2022.
//

import UIKit

class SocialMediaSignUPViewController: UIViewController {

    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var instaTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var linkidInTextField: UITextField!
    @IBOutlet weak var snapShatTextField: UITextField!
    @IBOutlet weak var YouTubeTextField: UITextField!


    @IBOutlet weak var facebookDeletButton: UIButton!
    @IBOutlet weak var instaDeletButton: UIButton!
    @IBOutlet weak var twitterDeletButton: UIButton!
    @IBOutlet weak var linkidInDeletButton: UIButton!
    @IBOutlet weak var snapShatDeletButton: UIButton!
    @IBOutlet weak var YouTubeDeletButton: UIButton!

    @IBOutlet weak var submitButton: UIButton!

    private var viewModel = CreateStoreViewModel()
    var data: [String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        // Do any additional setup after loading the view.
    }

    @IBAction func submittAction(_ sender: Any) {
        if let content =  data?.merging(parseContent() ?? [:]) {(current, _) in current} {
            print(content)
        let vc = self.initViewControllerWith(identifier: CreateStoreSummeryViewController.className, and: "Summery", storyboardName: Storyboard.storeAuth.rawValue) as! CreateStoreSummeryViewController
            vc.data = content
        self.show(vc)
        }
    }

    @IBAction func facebookDeletAction(_ sender: Any) {
        facebookTextField.text = ""
        facebookTextField.resignFirstResponder()
        facebookDeletButton.isHidden = true
    }

    @IBAction func instaDeletAction(_ sender: Any) {
        instaTextField.text = ""
        instaTextField.resignFirstResponder()
        instaDeletButton.isHidden = true
    }

    @IBAction func linkedInDeletAction(_ sender: Any) {
        linkidInTextField.text = ""
        linkidInTextField.resignFirstResponder()
        linkidInDeletButton.isHidden = true
    }

    @IBAction func twitterDeletAction(_ sender: Any) {
        twitterTextField.text = ""
        twitterTextField.resignFirstResponder()
        twitterDeletButton.isHidden = true
    }

    @IBAction func snapDeletAction(_ sender: Any) {
        snapShatTextField.text = ""
        snapShatTextField.resignFirstResponder()
        snapShatDeletButton.isHidden = true
    }

    @IBAction func youTubeDeletAction(_ sender: Any) {
        YouTubeTextField.text = ""
        YouTubeTextField.resignFirstResponder()
        YouTubeDeletButton.isHidden = true
    }

    private func prepareUI() {
        [facebookDeletButton, instaDeletButton, twitterDeletButton, linkidInDeletButton, snapShatDeletButton, YouTubeDeletButton].forEach{
            $0?.isHidden = true
        }

        [facebookTextField, instaTextField, twitterTextField, linkidInTextField, snapShatTextField, YouTubeTextField].forEach {
            $0?.delegate = self
        }
    }

    func getData(data: [String:Any]) {
        self.data = data
    }

    private func parseContent() -> [String:Any]? {
        var data: [String:String] = [:]
        data = [
            "facebook":"\(facebookTextField.text ?? "")",
            "twitter":"\(twitterTextField.text ?? "")",
            "instagram":"\(instaTextField.text ?? "")",
            "linkedin":"\(linkidInTextField.text ?? "")",
            "youtube":"\(YouTubeTextField.text ?? "")",
            "snapchat":"\(snapShatTextField.text ?? "")",
        ]
        return data
    }
}

extension SocialMediaSignUPViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == facebookTextField {
            facebookDeletButton.isHidden = false
        }

        if textField == instaTextField {
            instaDeletButton.isHidden = false
        }

        if textField == twitterTextField {
            twitterDeletButton.isHidden = false
        }
        if textField == linkidInTextField {
            linkidInDeletButton.isHidden = false
        }
        if textField == snapShatTextField {
            snapShatDeletButton.isHidden = false
        }
        if textField == YouTubeTextField {
            YouTubeDeletButton.isHidden = false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == facebookTextField {
            if textField.text?.isEmpty == true {
                facebookDeletButton.isHidden = true
            }
        }

        if textField == instaTextField {
            if textField.text?.isEmpty == true {
                instaDeletButton.isHidden = true
            }
        }

        if textField == twitterTextField {
            if textField.text?.isEmpty == true {
                twitterDeletButton.isHidden = true
            }
        }
        if textField == linkidInTextField {
            if textField.text?.isEmpty == true {
                linkidInDeletButton.isHidden = true
            }
        }
        if textField == snapShatTextField {
            if textField.text?.isEmpty == true {
                snapShatDeletButton.isHidden = true
            }
        }
        if textField == YouTubeTextField {
            if textField.text?.isEmpty == true {
                YouTubeDeletButton.isHidden = true
            }
        }
    }
}
