//
//  SuccessViewController.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//  
//

import UIKit
import Foundation


class SuccessViewController: UIViewController {

  enum SourceViewController {
    case register
    case reset
    case forget
  }
    // MARK: - Outlets

  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var genderImageView: UIImageView!

    // MARK: - Properties


    var viewModel: SuccessViewModel =  SuccessViewModel()
    private var type:SourceViewController = .register

    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      hiddenNavigation(isHidden: true)
      navigationController?.navigationBar.transparentNavigationBar()
    }

    private func locaization() {
      titleLabel.text = "Success".localiz()
      messageLabel.text = "Your password has been changed successfully!".localiz()
      loginButton.setTitle("Log in".localiz(), for: .normal)
    }


    // MARK: - Protected Methods
    private func setupUI() {
      loginButton.isHidden = type == .forget
      messageLabel.isHidden = type == .forget
      locaization()
    }

    func confige(source: SourceViewController) {
      self.type = source
    }

    private func setupBinding() {

    }

    @IBAction func Login(_ sender: Any) {
      if  type == .reset {
        self.navigationController?.popToViewController(ofClass: LoginViewController.self)
      }else if type == .forget {
        
        self.navigationController?.popToViewController(ofClass: LoginViewController.self)
      }
    }
  

}
