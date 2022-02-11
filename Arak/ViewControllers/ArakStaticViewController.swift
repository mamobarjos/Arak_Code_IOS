//
//  ArakStaticViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 15/07/2021.
//

import UIKit

class ArakStaticViewController: UIViewController {

   
    enum ArakStatic {
      case terms
      case privcy
      case aboutUs
      case needHelp
    }

    @IBOutlet weak var descriptionTextView: UITextView!
    private var descriptionText: String = ""
    private var arakStatic: ArakStatic = .aboutUs

      override func viewDidLoad() {
          super.viewDidLoad()
        descriptionTextView.textColor = .black
        descriptionTextView.attributedText = descriptionText.htmlToAttributedString
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textAlignment = Helper.appLanguage == "en" ? .left : .right
        if arakStatic == .aboutUs {
          title = "About Us".localiz()
        } else if arakStatic == .terms {
          title = "Terms & Conditions".localiz()
        } else if arakStatic == .privcy {
          title = "Privacy Policy".localiz()
        } else if arakStatic == .needHelp {
          title = "Need Help?".localiz()
        }
      }

    func confige(descriptionText: String,arakStatic: ArakStatic) {
      self.descriptionText = descriptionText
      self.arakStatic = arakStatic
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      hiddenNavigation(isHidden: false)
 
    }

    override func leftTapped(itemBar: UIBarButtonItem) {
      navigationController?.popViewController(animated: true)
    }
  }
