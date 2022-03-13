//
//  SingleProduct.swift
//  Arak
//
//  Created by Osama Abu hdba on 20/02/2022.
//

import Foundation

struct SingleProduct: Codable {
    let storeProduct: PagingModel<[Product]>?
    let relatedProducts: [RelatedProducts]?

    enum CodingKeys: String, CodingKey {
        case storeProduct = "store_product"
        case relatedProducts = "related_products"
    }
}

// MARK: - StoreProduct

struct RelatedProducts: Codable {
    let id: Int
    let name: String?
    let desc: String?
    let price: Double?
    let totalRates: Double?
    let storeid: Int
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

struct Product: Codable {
    let id: Int
    let name: String
    let desc: String
    let price: Double
    let totalRates: Double?
    let storeid: Int
    let createdAt: String
    let updatedAt: String
    let storeProductFiles: [StoreProductFile]
    let store: ProductStore?
    
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
        case storeProductFiles = "store_product_files"
        case store = "store"
    }
}

// MARK: - StoreProductFile
struct StoreProductFile: Codable {
    let id: Int
    let path: String
    let storeProductid: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case path = "path"
        case storeProductid = "store_product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ProductStore
struct ProductStore: Codable {
    let totalRates: Double?
    let youtube: String?
    let userid: Int?
    let isFeatured: Int?
    let img: String?
    let facebook: String?
    let lon: String?
    let storeCategoryid: Int?
    let updatedAt: String?
    let cover: String?
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

    enum CodingKeys: String, CodingKey {
        case totalRates = "total_rates"
        case youtube = "youtube"
        case userid = "user_id"
        case isFeatured = "is_featured"
        case img = "img"
        case facebook = "facebook"
        case lon = "lon"
        case storeCategoryid = "store_category_id"
        case updatedAt = "updated_at"
        case cover = "cover"
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
    }
}
