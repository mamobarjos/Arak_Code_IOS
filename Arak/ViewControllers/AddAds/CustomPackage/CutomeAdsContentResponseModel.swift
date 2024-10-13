//
//  CutomeAdsContentResponseModel.swift
//  Arak
//
//  Created by Osama Abu Hdba on 09/09/2024.
//

import Foundation

struct CutomeAdsContentResponse: Codable {
    let customImgs: [CustomImg]?
    let customReachs: [CustomReach]?
    let customSeconds: [CustomSecond]?
    var customGenders: [CustomGender]?
    var customAges: [CustomAge]?
    let customCountries: [CustomCountry]?
    var customCities: [CustomCity]?
}

struct CustomImg: Codable {
    let id: Int?
    let value: Int?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, value
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct CustomReach: Codable {
    let id: Int?
    let value: Int?
    let secondPrice: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, value
        case secondPrice = "second_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct CustomSecond: Codable {
    let id: Int?
    let value: Int?
    let price: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, value, price
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct CustomGender: Codable {
    let id: Int?
    let gender: String?
    let price: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, gender, price
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct CustomAge: Codable {
    let id: Int?
    let age: String?
    let price: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, age, price
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct CustomCountry: Codable {
    let id: Int?
    let countryID: Int?
    let price: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let country: Country?
    
    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case price
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case country
    }
}

struct CustomCity: Codable {
    let id: Int?
    let cityID: Int?
    let price: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let city: Country?
    
    enum CodingKeys: String, CodingKey {
        case id
        case cityID = "city_id"
        case price
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case city
    }
}
