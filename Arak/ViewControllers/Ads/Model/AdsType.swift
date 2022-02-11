//
//  AdsType.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//

import Foundation


// MARK: - Datum
struct AdsCategory: Codable {
      var id: Int?
      var categoryNameEn, categoryNameAr: String?
      var img: String?
      var createdAt, updatedAt: String?
      var packages: [Package]?
      var categoryTitle: String {
        return  Helper.appLanguage ?? "en" == "en" ? (categoryNameEn ?? "") : categoryNameAr ?? ""
      }

      enum CodingKeys: String, CodingKey {
          case id
          case categoryNameEn = "category_name_en"
          case categoryNameAr = "category_name_ar"
          case img
          case createdAt = "created_at"
          case updatedAt = "updated_at"
          case packages
      }
}
// MARK: - Package
struct Package: Codable {
    var id: Int?
    var nameEn, nameAr: String?
    var icon: String?
    var reach: String?
    var price: Double?
    var noOfImgs: Int?
    var seconds: String?
    var adCategoryID: Int?
    var isVideo: Bool {
      return adCategoryID ?? -1 == AdsTypes.video.rawValue
    }
    var imageTitle:String {
      return "\(noOfImgs ?? 0) " + ((noOfImgs ?? 0) > 1 ? "Images".localiz() : "Image".localiz())
    }
  var name:String {
    return (Helper.appLanguage ?? "en") == "en" ? (nameEn ?? "") : (nameAr ?? "")
  }
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case icon, reach, price, seconds
        case adCategoryID = "ad_category_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case noOfImgs = "no_of_imgs"
    }
}
