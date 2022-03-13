//
//  CreateProductModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 11/03/2022.
//

import Foundation
struct CreateProductModel: Codable {
    let id: Int
    let price: String
    let createdAt: String
    let updatedAt: String
    let storeid: Int
    let name: String
    let desc: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case price = "price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case storeid = "store_id"
        case name = "name"
        case desc = "desc"
    }
}
