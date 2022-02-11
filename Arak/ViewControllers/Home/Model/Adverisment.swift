//
//  Adverisment.swift
//  Arak
//
//  Created by Abed Qassim on 26/02/2021.
//

import UIKit
// MARK: - DataClass
struct AdverismentResponse: Codable {
    var ads: PagingModel<[Adverisment]>?
    var banners: PagingModel<[AdBanner]>?

    enum CodingKeys: String, CodingKey {
        case ads,banners
    }
}

// MARK: - Adverisment
struct Adverisment: Codable {
    enum ProductStatus : Int {
      case Pending = 0
      case Approved = 1
      case Completed = 2
      case Decline = 3
    }
    var id: Int?
    var title, desc, lon, lat: String?
    var locationTitle:String?
    var phoneNo, alternativePhoneNo, companyName: String?
    var adCategoryID, packageID, userID: Int?
    var package: Package?
    var createdAt, updatedAt: String?
    var duration: String?
    var views: Int?
    var totalAmount: String?
    var adImages: [AdImage]?
    var adFileImagesPreparing: [AdImagePrepare]?
    var websiteURL: String?
    var checkoutURL:String?
    var isFavorate,status: Int?
    var thumbUrl: String?
    var isMe: Bool {
        return userID ?? -1 == Helper.currentUser?.id ?? -2
    }
    var isFav: Bool {
        get {
            return isFavorate ?? 0 != 0
        }
        
        set {
            isFavorate = newValue  ? 1 : 0
        }
    }
    var statusTitle: String {
      if status == ProductStatus.Approved.rawValue {
        return "Approved".localiz()
      } else  if status == ProductStatus.Pending.rawValue {
        return "Pending".localiz()
      } else  if status == ProductStatus.Decline.rawValue {
        return "Decline".localiz()
      } else  if status == ProductStatus.Completed.rawValue {
        return "Completed".localiz()
      }
      return ""
    }

    var statusColor: UIColor {
      if status == ProductStatus.Approved.rawValue ||  status == ProductStatus.Completed.rawValue {
        return #colorLiteral(red: 0.168627451, green: 0.7176470588, blue: 0.2235294118, alpha: 1)
      } else  if status == ProductStatus.Pending.rawValue {
        return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
      } else  if status == ProductStatus.Decline.rawValue {
        return #colorLiteral(red: 0.7755567431, green: 0.2490332723, blue: 0.220043093, alpha: 1)
      }
      return .white
    }
    enum CodingKeys: String, CodingKey {
        case id, title, desc, lon, lat, status
        case phoneNo = "phone_no"
        case alternativePhoneNo = "alternative_phone_no"
        case companyName = "company_name"
        case adCategoryID = "ad_category_id"
        case packageID = "package_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adImages = "ad_files"
        case websiteURL = "website_url"
        case duration
        case isFavorate = "is_fav"
        case checkoutURL = "checkout_url"
        case thumbUrl = "thumb_url"
        case package
        case views
    }
}

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


struct AdBanner: Codable {
    var id: Int?
    var path: String?
    var user_id: Int?
    var createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case path = "img"
        case id
        case user_id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


struct AdImagePrepare {
    var id: Int?
    var path: UIImage?
}
