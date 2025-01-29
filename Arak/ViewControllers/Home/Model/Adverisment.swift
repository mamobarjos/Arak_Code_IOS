//
//  Adverisment.swift
//  Arak
//
//  Created by Abed Qassim on 26/02/2021.
//

import UIKit
// MARK: - DataClass
struct AdverismentResponse: Codable {
//    let page, lastPage: Int?
    let ads: [Adverisment]?
//    let total: Int?

}

// MARK: - Adverisment
//struct Adverisment: Codable {
//    enum ProductStatus : Int {
//      case Pending = 0
//      case Approved = 1
//      case Completed = 2
//      case Decline = 3
//    }
//    var id: Int?
//    var title, desc, lon, lat: String?
//    var locationTitle:String?
//    var phoneNo, alternativePhoneNo, companyName: String?
//    var adCategoryID, packageID, userID: Int?
//    var package: Package?
//    var createdAt, updatedAt: String?
//    var duration: String?
//    var views: Int?
//    var totalAmount: String?
//    var adImages: [AdImage]?
//    var adFileImagesPreparing: [AdImagePrepare]?
//    var websiteURL: String?
//    var checkoutURL:String?
//    var isFavorate,status: Int?
//    var thumbUrl: String?
//    var reviews: [ReviewResponse]?
//    var isMe: Bool {
//        return userID ?? -1 == Helper.currentUser?.id ?? -2
//    }
//    var isFav: Bool {
//        get {
//            return isFavorate ?? 0 != 0
//        }
//
//        set {
//            isFavorate = newValue  ? 1 : 0
//        }
//    }
//    var statusTitle: String {
//      if status == ProductStatus.Approved.rawValue {
//        return "Approved".localiz()
//      } else  if status == ProductStatus.Pending.rawValue {
//        return "Pending".localiz()
//      } else  if status == ProductStatus.Decline.rawValue {
//        return "Decline".localiz()
//      } else  if status == ProductStatus.Completed.rawValue {
//        return "Completed".localiz()
//      }
//      return ""
//    }
//
//    var statusColor: UIColor {
//      if status == ProductStatus.Approved.rawValue ||  status == ProductStatus.Completed.rawValue {
//        return #colorLiteral(red: 0.168627451, green: 0.7176470588, blue: 0.2235294118, alpha: 1)
//      } else  if status == ProductStatus.Pending.rawValue {
//        return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//      } else  if status == ProductStatus.Decline.rawValue {
//        return #colorLiteral(red: 0.7755567431, green: 0.2490332723, blue: 0.220043093, alpha: 1)
//      }
//      return .white
//    }
//    enum CodingKeys: String, CodingKey {
//        case id, title, desc, lon, lat, status
//        case phoneNo = "phone_no"
//        case alternativePhoneNo = "alternative_phone_no"
//        case companyName = "company_name"
//        case adCategoryID = "ad_category_id"
//        case packageID = "package_id"
//        case userID = "user_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case adImages = "ad_files"
//        case websiteURL = "website_url"
//        case duration
//        case isFavorate = "is_fav"
//        case checkoutURL = "checkout_url"
//        case thumbUrl = "thumb_url"
//        case package
//        case views
//        case reviews = "ad_reviews"
//    }
//}

// MARK: - AdImage
struct AdImage: Codable {
    var id: Int?
    var path: String?
    var adID: Int?
    var createdAt, updatedAt: String?
    var thumbnilData:UIImage?
    var duration: Int?
    enum CodingKeys: String, CodingKey {
        case id, path
        case adID = "ad_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}




struct BannerResponse: Codable {
    let lastPage: Int?
    let banners: [AdBanner]?
    let total: Int?
    let page: String?
}

// MARK: - Banner
struct AdBanner: Codable {
    let id: Int?
    let description: String?
    let countryID: Int?
    let isHomepage: Bool?
    let createdAt, websiteURL: String?
    let type: String?
//    let userID: JSONNull?
    let title: String?
    let path: String?
//    let deletedAt: JSONNull?
    let updatedAt: String?
//    let storeID, user: JSONNull?
//    let status: String?
//    let store: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, description
        case countryID = "country_id"
        case isHomepage = "is_homepage"
        case createdAt = "created_at"
        case websiteURL = "website_url"
        case type
//        case userID = "user_id"
        case title
        case path = "img_url"
//        case deletedAt = "deleted_at"
        case updatedAt = "updated_at"
//        case storeID = "store_id"
//        case user, status, store
    }
}



struct AdImagePrepare {
    var id: Int?
    var path: UIImage?
}


struct Adverisment: Codable {
    enum ProductStatus : Int {
      case Pending = 0
      case Approved = 1
      case Completed = 2
      case Decline = 3
    }
    let isVisited: Bool?
    let statusTitle, title: String?
    let adPackageID: Int?
    let adImages: [AdFile]?
    
    let duration: Double?
    let userID: Int?
    let updatedAt: String?
    let isPaymentCompleted: Bool?
    let views: Int?
    let adCategory: AdCategory?
    var package: Package?
    var isFav: Bool?
    let id: Int?
    let storeId: Int?
    let phoneNo: String?
    let adCategoryID: Int?
    let createdAt: String?
    let thumbUrl: String?
    var reviews: [ReviewResponse]?
    let websiteURL: String?
    let desc: String?
    var locationTitle:String?
    var alternativePhoneNo, companyName: String?
    var totalAmount: String?
    var lon:String?
    var lat: String?
    let isReviewed: Bool?
    let checkOutURL: String?
    var adFileImagesPreparing: [AdImagePrepare]?

    var isMe: Bool {
        return userID ?? -1 == Helper.currentUser?.id ?? -2
    }

    var statusColor: UIColor {
        if statusTitle == "Approved".localiz() ||  statusTitle == "Completed".localiz() {
            return #colorLiteral(red: 0.168627451, green: 0.7176470588, blue: 0.2235294118, alpha: 1)
        } else  if statusTitle == "Pending".localiz() {
            return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else  if statusTitle == "Decline".localiz() {
            return #colorLiteral(red: 0.7755567431, green: 0.2490332723, blue: 0.220043093, alpha: 1)
        }
        return .white
    }
    
    enum CodingKeys: String, CodingKey {
        case isVisited = "is_visited"
        case statusTitle = "status"
        case title
        case reviews = "ad_reviews"
        case adPackageID = "ad_package_id"
        case adImages = "ad_files"
        case duration
        case package = "ad_package"
        case isFav = "is_favorite"
        case userID = "user_id"
        case updatedAt = "updated_at"
        case isPaymentCompleted = "is_payment_completed"
        case views
        case adCategory = "ad_category"
        case id
        case storeId = "store_id"
//        case adFileImagesPreparing
        case phoneNo = "phone_no"
        case adCategoryID = "ad_category_id"
        case createdAt = "created_at"
        case desc = "description"
        case thumbUrl = "thumb_url"
        case websiteURL = "website_url"
        case locationTitle, alternativePhoneNo, companyName
        case totalAmount
        case lon, lat
        case isReviewed = "is_reviewed"
        case checkOutURL = "checkout_url"
    }
}

// MARK: - AdCategory

struct AdCategoryContainer: Codable {
    let adCategories: [AdCategory]?
}
struct AdCategory: Codable {
    let id: Int?
    let nameEn, nameAr: String?
    
    var categoryTitle: String {
      return  Helper.appLanguage ?? "en" == "en" ? (nameEn ?? "") : nameAr ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
    }
}

// MARK: - AdFile
struct AdFile: Codable {
    let id: Int?
    let path: String?
    var thumbnilData:UIImage?
    var duration: Int?
    var adID: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case path = "url"
        case id
    }
}
