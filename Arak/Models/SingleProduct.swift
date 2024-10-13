//
//  SingleProduct.swift
//  Arak
//
//  Created by Osama Abu hdba on 20/02/2022.
//

import Foundation

struct SingleProduct: Codable {
    let storeProduct: Product?
    let relatedProducts: [RelatedProducts]?

    enum CodingKeys: String, CodingKey {
        case storeProduct = "store_product"
        case relatedProducts = "related_products"
    }
}

// MARK: - StoreProduct
struct RelatedProductsContainer: Codable {
    let total: Int?
    let products: [RelatedProducts]?
}

struct RelatedProducts: Codable {
    let id: Int?
    let description: String?
    let rating: Double?
    let storeProductReviews: [Review]?
    let storeProductFiles: [StoreProductFile]?
    let createdAt: String?
    //      let deletedAt: JSONNull?
    let price, salePrice: String?
    let updatedAt: String?
    let storeid: Int?
    let name: String?
    let store: Store?
    let desc: String?

    var priceformated: String {
        return "\(price ?? "") JOD"
    }


    enum CodingKeys: String, CodingKey {
        case id, description, rating
        case storeProductReviews = "store_product_reviews"
        case storeProductFiles = "store_product_files"
        case createdAt = "created_at"
        case desc
        case price
        case salePrice = "sale_price"
        case updatedAt = "updated_at"
        case storeid = "store_id"
        case name, store
    }
}

struct Product: Codable {
    let id: Int?
    let name: String?
    let desc: String?
    let price: Double?
    let totalRates: Double?
    let storeid: Int?
    let createdAt: String?
    let updatedAt: String?
    let storeProductFiles: [StoreProductFile]
    let store: ProductStore?
    let reviews: [ProductReviewResponse]
    let shareLink: String?
    
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
        case reviews = "store_product_reviews"
        case shareLink = "share_link"
    }
}

// MARK: - StoreProductFile
struct StoreProductFile: Codable {
//    let storeProductFile, id: Int?
//    let deletedAt: JSONNull?
//    let updatedAt: String?
    let path: String?
//    let createdAt: String?

    enum CodingKeys: String, CodingKey {
//        case storeProductFile = "store_product_file"
//        case id
//        case deletedAt = "deleted_at"
//        case updatedAt = "updated_at"
        case path = "url"
//        case createdAt = "created_at"
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



/// Stubid Model

struct StubidRelatedProducts: Codable {
    let id: Int
    let name: String?
    let desc: String?
    let price: Double?
    let totalRates: Double?
    let storeid: Int
    let createdAt: String?
    let updatedAt: String?
//    let storeProductFiles: [StoreProductFile]

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
//        case storeProductFiles = "store_product_files"
    }
}


struct Datum: Codable {
    let id, price: Int?
    let createdAt: JSONNull?
    let storeProductFiles: [StoreProductFile2]?
    let totalRates: Double?
    let updatedAt: JSONNull?
    let storeID: Int?
    let name, desc: String?

    enum CodingKeys: String, CodingKey {
        case id, price
        case createdAt = "created_at"
        case storeProductFiles = "store_product_files"
        case totalRates = "total_rates"
        case updatedAt = "updated_at"
        case storeID = "store_id"
        case name, desc
    }
}

// MARK: - StoreProductFile
struct StoreProductFile2: Codable {
    let path: String?
    let id: Int?
    let updatedAt: JSONNull?
    let storeProductID: Int?
    let createdAt: JSONNull?

    enum CodingKeys: String, CodingKey {
        case path, id
        case updatedAt = "updated_at"
        case storeProductID = "store_product_id"
        case createdAt = "created_at"
    }
}
