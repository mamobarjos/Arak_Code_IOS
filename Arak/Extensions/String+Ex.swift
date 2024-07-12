//
//  String+Ex.swift
//  Resturant
//
//  Created by Abed Qassim on 10/10/20.
//

import UIKit

enum ValidationRuleType {
    case Required,
    Email,
    Length,
    PhoneNumber,
    NotMatching
}
enum ValidationErrorType {
   case Required,
        Email,
        PhoneNumber,
        Length,
        NotMatching,
        Validated

    func description() -> String {
        switch self {
        case .Required:
            return "Required field"
        case .Email:
            return "Must be a valid email"
        case .PhoneNumber:
            return "Must be a valid Phone Number"
        case .Length:
            return "Must be at least 8 characters"
          case .NotMatching:
              return "Must be at least 8 characters"
          case .Validated:
            return ""
        }
    }
}

extension String {
  func validator(type: ValidationRuleType , otherString: String = "" , length: Int = 5) -> ValidationErrorType {
    switch type {
      case .Required :
        return self.isEmpty ? .Required : .Validated
      case .Email:
        return isValidEmail()
      case .NotMatching :
        return isMatch(otherString: otherString)
      case .Length:
        return self.count > length ? .Validated : .Length
    case .PhoneNumber:
       return isValidPhoneNumber()
    }
  }

  private func isMatch(otherString: String)  -> ValidationErrorType {
    if self.isEmpty {
      return .Required
    }
    if otherString.isEmpty {
      return .Required
    }
    return self == otherString ? .Validated : .NotMatching
  }

  private func isValidEmail() -> ValidationErrorType {
    if self.isEmpty {
      return .Required
    }
    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil ? .Validated : .Email
  }
    
    private func isValidPhoneNumber() -> ValidationErrorType {
        if self.isEmpty {
            return .Required
        }
        // Regular expression for validating phone numbers like 962796951946
        let regex = try! NSRegularExpression(pattern: "^[0-9]{12}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) != nil ? .Validated : .PhoneNumber
    }
  
}


extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
  func convertTime(fromFormatter: String, toFormatter: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormatter
    guard let date = dateFormatter.date(from: self) else {
      return self
    }

    dateFormatter.dateFormat = toFormatter
    return dateFormatter.string(from: date)
  }
}


extension String {
  func localiz() -> String {
    return NSLocalizedString(self, comment: "")
  }
}

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
