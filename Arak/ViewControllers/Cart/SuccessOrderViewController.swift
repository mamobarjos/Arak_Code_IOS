//
//  SuccessOrderViewController.swift
//  KHR
//
//  Created by Reham Khalil on 22/07/2024.
//
import UIKit

class SuccessOrderViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var doneButtton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleLabelText()
        hiddenNavigation(isHidden: true)
    }
    
    private func setTitleLabelText() {
        
        let fullText = "Thanks for using ARAK".localiz()
        let coloredText = "ARAK".localiz()
        let color = UIColor(hex: "#FF6E2E")
        
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: coloredText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
        }
        
        title = "Arak Store".localiz()
        titleLabel.attributedText = attributedString
        subtitleLabel.text = "Your order on the way! enjoy it.".localiz()
        doneButtton.setTitle("Done".localiz(), for: .normal)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

