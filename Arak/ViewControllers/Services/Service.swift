//
//  Service.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 06/07/2021.
//

import Foundation
struct Service: Codable {
      var id: Int?
      var title: String?
      var img: String?
      var createdAt, updatedAt: String?
      var desc: String?
      var titleAr:String?
      var descAr:String?
    var titleTitle:String {
        return Helper.appLanguage ?? "en" == "en" ? (title ?? "") : (titleAr ?? "")
    }
    var descTitle:String {
        return Helper.appLanguage ?? "en" == "en" ? (desc ?? "") : (descAr ?? "")
    }
      enum CodingKeys: String, CodingKey {
          case id
          case title
          case img
          case createdAt = "created_at"
          case updatedAt = "updated_at"
          case desc
        case descAr = "desc_ar"
        case titleAr  = "title_ar"
      }
}
