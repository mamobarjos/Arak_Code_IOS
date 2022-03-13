//
//  SingleStore.swift
//  Arak
//
//  Created by Osama Abu hdba on 19/02/2022.
//

import Foundation
// MARK: - SingleStore
struct SingleStore: Codable {
    let totalRates: Double?
        let youtube: String?
        let isReviewed: Int?
        let userid: Int?
        let isFeatured: Int?
        let img: String?
        let facebook: String?
        let lon: String
        let storeCategoryid: Int?
        let updatedAt: String?
        let cover: String?
        let storeReviews: [ReviewResponse]
        let name: String?
        let twitter: String?
        let linkedin: String?
        let id: Int?
        let website: String?
        let phoneNo: String?
        let instagram: String?
        let lat: String?
        let createdAt: String?
        let desc: String?
        let snapchat: String?
        let storeProducts: [StoreProduct]
    
    enum CodingKeys: String, CodingKey {
        case totalRates = "total_rates"
        case youtube = "youtube"
        case isReviewed = "is_reviewed"
        case userid = "user_id"
        case isFeatured = "is_featured"
        case img = "img"
        case facebook = "facebook"
        case lon = "lon"
        case storeCategoryid = "store_category_id"
        case updatedAt = "updated_at"
        case cover = "cover"
        case storeReviews = "store_reviews"
        case name = "name"
        case twitter = "twitter"
        case linkedin = "linkedin"
        case id = "id"
        case website = "website"
        case phoneNo = "phone_no"
        case instagram = "instagram"
        case lat = "lat"
        case createdAt = "created_at"
        case desc = "desc"
        case snapchat = "snapchat"
        case storeProducts = "store_products"
    }
}
// MARK: - StoreProduct
struct StoreProduct: Codable {
    let id: Int
    let name: String?
    let desc: String?
    let price: Double?
    let totalRates: Double?
    let storeid: Int?
    let createdAt: String?
    let updatedAt: String?
    
    var priceformated: String {
        let price = String(format: "%.2f", self.price ?? 0.0)
        return "$\(price)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case desc = "desc"
        case price = "price"
        case totalRates = "total_rates"
        case storeid = "store_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
