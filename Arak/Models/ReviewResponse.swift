//
//  ReviewResponse.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/03/2022.
//

import Foundation

struct ReviewResponse: Codable {
    let content: String?
    let rate: String?
    let id: Int?
    let createdAt: String?
    let userid: Int?
    let updatedAt: String?
    let storeid: Int?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case content = "content"
               case rate = "rating"
               case id = "id"
               case createdAt = "created_at"
               case userid = "user_id"
               case updatedAt = "updated_at"
               case storeid = "store_id"
               case user = "user"
    }
}

struct ProductReviewResponse: Codable {
    let content: String?
        let rate: Double?
        let id: Int?
        let storeProductid: Int?
        let createdAt: String?
        let userid: Int?
        let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case content = "content"
        case rate = "rate"
        case id = "id"
        case storeProductid = "store_product_id"
        case createdAt = "created_at"
        case userid = "user_id"
        case updatedAt = "updated_at"
    }
}
