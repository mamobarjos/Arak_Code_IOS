//
//  CreateProductModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/03/2022.
//

import Foundation
struct CreateProductModel: Codable {
//    let rating: Double?
    let id: Int?
//    let price: String
//    let salePrice: String
//    let createdAt: String
//    let deletedAt: String?
//    let storeProductFiles: [StoreProductFile]
//    let description: String
//    let storeId: Int
//    let name: String
//    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
//        case rating
        case id
//        case price
//        case salePrice = "sale_price"
//        case createdAt = "created_at"
//        case deletedAt = "deleted_at"
//        case storeProductFiles = "store_product_files"
//        case description
//        case storeId = "store_id"
//        case name
//        case updatedAt = "updated_at"
    }
}
