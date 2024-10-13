//
//  PlaceOrderModel.swift
//  Arak
//
//  Created by Osama Abu Hdba on 31/08/2024.
//

import Foundation

// Data model
struct PlaceOrderModel: Codable {
    let id: Int?
    let checkoutUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case checkoutUrl = "checkout_url"

    }
}
