//
//  ArakLinks.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 15/07/2021.
//

import Foundation
import Foundation
// MARK: - Datum
struct ArakLinks: Codable {
    var id: Int?
    var aboutEn, termsEn, privacyEn, aboutAr: String?
    var termsAr, privacyAr, createdAt, updatedAt: String?
    var needHelp: String?
    var needHelpAr: String?
    var needHelpEn: String?
  var terms: String {
    return Helper.appLanguage ?? "en" == "en" ? (termsEn ?? "") : (termsAr ?? "")
  }

  var needHelpJoyin: String {
    return Helper.appLanguage ?? "en" == "en" ? (needHelpEn ?? "") : (needHelpAr ?? "")
  }
  var about: String {
    return Helper.appLanguage ?? "en" == "en" ? (aboutEn ?? "") : (aboutAr ?? "")
  }

  var privacy: String {
    return Helper.appLanguage ?? "en" == "en" ? (privacyEn ?? "") : (privacyAr ?? "")
  }
 
  enum CodingKeys: String, CodingKey {
        case id
        case aboutEn = "about_en"
        case termsEn = "terms_en"
        case privacyEn = "privacy_en"
        case aboutAr = "about_ar"
        case termsAr = "terms_ar"
        case privacyAr = "privacy_ar"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case needHelp = "need_help"
        case needHelpAr = "need_help_ar"
        case needHelpEn = "need_help_en"

    }
}
