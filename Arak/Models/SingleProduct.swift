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
    let name: String
    let desc: String
    let price: Double
    let totalRates: Double?
    let storeid: Int
    let createdAt: String
    let updatedAt: String

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
