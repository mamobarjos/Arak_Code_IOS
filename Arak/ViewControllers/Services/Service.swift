//
//  Service.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 06/07/2021.
//

import Foundation

struct ServiceContainer: Codable {
    let lastPage: Int?
    let services: [Service]?
    let total: Int?
    let page: String?
}

struct Service: Codable {
    let shortDescEn, titleEn: String?
    let id: Int?
    let img: String?
    let createdAt: String?
//    let deletedAt: JSONNull?
    let titleAr, longDescEn, updatedAt, shortDescAr: String?
    let longDescAr: String?
    var titleTitle:String {
        return Helper.appLanguage ?? "en" == "en" ? (titleEn ?? "") : (titleAr ?? "")
    }
    var descTitle:String {
        return Helper.appLanguage ?? "en" == "en" ? (longDescEn ?? "") : (longDescAr ?? "")
    }
      enum CodingKeys: String, CodingKey {
          case shortDescEn = "short_desc_en"
          case titleEn = "title_en"
          case id
          case createdAt = "created_at"
          case img = "img_url"
//          case deletedAt = "deleted_at"
          case titleAr = "title_ar"
          case longDescEn = "long_desc_en"
          case updatedAt = "updated_at"
          case shortDescAr = "short_desc_ar"
          case longDescAr = "long_desc_ar"
      }
}
