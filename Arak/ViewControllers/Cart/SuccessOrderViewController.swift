//
//  SuccessOrderViewController.swift
//  KHR
//
//  Created by Reham Khalil on 22/07/2024.
//
import UIKit

class SuccessOrderViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleLabelText()
    }
    
    private func setTitleLabelText() {
        let fullText = "Thanks for using ARAK"
        let coloredText = "ARAK"
        let color = UIColor(hex: "#FF6E2E")
        
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: coloredText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
        }
        
        titleLabel.attributedText = attributedString
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let vc = InterestsViewController.loadFromNib()
        self.show(vc)
    }
}

