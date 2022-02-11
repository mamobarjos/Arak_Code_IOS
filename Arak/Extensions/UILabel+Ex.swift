//
//  UILabel+Ex.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import UIKit
extension UILabel {
  func setSubTextColor(pSubString : String, pColor : UIColor){
          let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.text!);
          let range = attributedString.mutableString.range(of: pSubString, options:NSString.CompareOptions.caseInsensitive)
          if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: pColor, range: range)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range);

          }
          self.attributedText = attributedString

      }
  func textAligment() {
    textAlignment = Helper.appLanguage ?? "en" == "en" ? .left : .right
  }
}

extension UITextField {
  func textAligment() {
    textAlignment =  Helper.appLanguage ?? "en" == "en" ? .left : .right
  }
}
