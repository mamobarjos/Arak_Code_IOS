//
//  Stores.swift
//  Arak
//
//  Created by Osama Abu hdba on 18/02/2022.
//

import Foundation

extension Double {
    /// Rounds the double to the specified number of decimal places.
    /// - Parameter places: The number of decimal places to round to.
    /// - Returns: The rounded double.
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}
struct StoresRespose: Codable {
    let storesData: StoresData
    let storeCategories: [StoreCategory]?
    let banners: [Banner]

    enum CodingKeys: String, CodingKey {
        case storesData = "stores"
        case storeCategories = "store_categories"
        case banners = "banners"
    }
}

// MARK: - StoreCategory

struct StoreCategoryContainer: Codable {
    let storeCategories: [StoreCategory]?
    let total, page, lastPage: Int?
}

struct StoreCategory: Codable {
    let id: Int?
    let iconUrl: String?
    let arName, name: String?
    var selected = false

    enum CodingKeys: String, CodingKey {
        case id
        case arName = "name_ar"
        case name = "name_en"
        case iconUrl = "icon_url"
    }
}

// MARK: - Stores
struct StoresData: Codable {
    let page, lastPage, total: Int?
    let stores: [Store]?
}

// MARK: - Datum
struct Store: Codable {
    let createdAt: String?
    let id: Int?
    let lon: String?
    let facebook: String?
    let storeCategoryID: Int?
    let deletedAt: String?
    let snapchat: String?
    let desc: String?
    let countryID: Int?
    let hasCash: Bool?
    let website, tiktok: String?
    let user: User?
    let name: String?
    let youtube: String?
    let status: String?
    let cover: String?
    let hasMastercard, hasPaypal: Bool?
    let lat: String?
    let instagram: String?
    let userID: Int?
    let updatedAt: String?
    let hasVisa: Bool?
    let storeCategory: StoreCategory?
    let storeReviews: [ReviewResponse]?
    let isFeatured: Bool?
    let img: String?
    let storeProducts: [StoreProduct]?
    let totalRates: Double?
    let x, linkedin: String?
    let phoneNo: String?
    let locationName: String?
    let isReviewed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id, lon, facebook
        case storeCategoryID = "store_category_id"
        case deletedAt = "deleted_at"
        case snapchat
        case desc = "description"
        case countryID = "country_id"
        case hasCash = "has_cash"
        case website, tiktok, user, name, youtube, status
        case cover = "cover_img_url"
        case hasMastercard = "has_mastercard"
        case hasPaypal = "has_paypal"
        case lat, instagram
        case userID = "user_id"
        case updatedAt = "updated_at"
        case hasVisa = "has_visa"
        case storeCategory = "store_category"
        case storeReviews = "store_reviews"
        case isFeatured = "is_featured"
        case img = "img_url"
        case storeProducts = "store_products"
        case totalRates = "rating"
        case x, linkedin
        case phoneNo = "phone_no"
        case locationName = "location_name"
        case isReviewed = "is_reviewed"
    }
}
// MARK: - Banner
struct Banner: Codable {
    let status: Int
    let img: String?
    let id: Int
    let storeId: Int?
    let createdAt: String?
    let isHomepage: Int?
    let websiteurl: String?
    let userid: Int?
    let updatedAt: String?
    let title: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case img = "img"
        case id = "id"
        case storeId = "store_id"
        case createdAt = "created_at"
        case isHomepage = "is_homepage"
        case websiteurl = "website_url"
        case userid = "user_id"
        case updatedAt = "updated_at"
        case title, description
    }
}
