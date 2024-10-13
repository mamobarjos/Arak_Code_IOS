//
//  CouponViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 08/07/2021.
//

import UIKit

class CouponViewController: UIViewController {
    
    typealias ConfirmBlock = (String) -> Void
    typealias ShowArakService = () -> Void

    @IBOutlet weak var couponeLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var contactNoteLabel: UILabel!
    private var error: String = ""
    private var confirmBlock: ConfirmBlock?
    private var showArakService: ShowArakService?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.29)
        addGesture()
        codeTextField.keyboardType = .default
        codeTextField.placeholder = "Coupon Code".localiz()
        couponeLabel.text = "Available Coupons\n25,50,100,250".localiz()
        contactNoteLabel.text = "Please contact us to purchase a coupon".localiz()
        contactNoteLabel.textAligment()
        contactNoteLabel.isUserInteractionEnabled = true
        contactNoteLabel.addTapGestureRecognizer {
            self.showArakService?()
            
        }
        useButton.setTitle("Use".localiz(), for: .normal)
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    func confige(confirmBlock: ConfirmBlock?,showArakService: ShowArakService?) {
        self.confirmBlock = confirmBlock
        self.showArakService = showArakService
    }
    
    @IBAction func Use(_ sender: Any) {
        if !validation() {
            showToast(message: error)
            return
        }
        confirmBlock?(codeTextField.text ?? "")
    }
    
    @objc func dismissVC() {
        dismissViewController()
    }
    private func validation() -> Bool {
      error = ""
      guard let code = codeTextField.text else {
        error = "Please insert your Coupon Code".localiz()
        self.codeTextField.becomeFirstResponder()
        return error.isEmpty
      }
        if code.validator(type: .Required) == .Required {
            error = "Please insert your Coupon Code".localiz()
            self.codeTextField.becomeFirstResponder()
          return error.isEmpty
        }

        return error.isEmpty
    }
}
