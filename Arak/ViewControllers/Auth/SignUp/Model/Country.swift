//
//  Country.swift
//  Arak
//
//  Created by Abed Qassim on 29/05/2021.
//

import Foundation


struct CountryContainer: Codable {
//    let lastPage: Int?
    let cities: [Country]?
    let countries: [Country]?
//    let total, page: Int?
}

struct Country: Codable {
    let nameEn: String?
    let id: Int?
    let createdAt: String?
    let currencyID: Int?
//    let deletedAt: JSONNull?
    let countryCode, updatedAt: String?
    let currency: Currency?
    let nameAr: String?
    
    var name:String {
        return Helper.appLanguage ?? "en" == "en" ? (nameEn ?? "") : (nameAr ?? "")
    }
  
    enum CodingKeys: String, CodingKey {
        case nameEn = "name_en"
        case id
        case createdAt = "created_at"
        case currencyID = "currency_id"
//        case deletedAt = "deleted_at"
        case countryCode = "country_code"
        case updatedAt = "updated_at"
        case currency
        case nameAr = "name_ar"
    }
}

struct Currency: Codable {
    let symbol, nameEn: String?
    let id: Int?
    let exchangeRate, createdAt: String?
//    let deletedAt: JSONNull?
    let updatedAt, nameAr: String?

    enum CodingKeys: String, CodingKey {
        case symbol
        case nameEn = "name_en"
        case id
        case exchangeRate = "exchange_rate"
        case createdAt = "created_at"
//        case deletedAt = "deleted_at"
        case updatedAt = "updated_at"
        case nameAr = "name_ar"
    }
}
