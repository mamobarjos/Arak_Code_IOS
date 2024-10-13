//
//  DigitalWallet.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 09/07/2021.
//

import Foundation

struct DigitalWalletsContainer: Codable {
    let lastPage: Int?
    let digitalWallets: [DigitalWallet]?
    let total, page: Int?
}

class DigitalWallet: Codable {
    let nameEn: String?
    let id: Int?
    let createdAt: String?
//    let deletedAt: JSONNull?
    let country: DigitalWallet?
    let countryID: Int?
    let updatedAt, nameAr: String?
    let currencyID: Int?
    let countryCode: String?
    var nameTitle:String {
        return Helper.appLanguage ?? "en" == "en" ? (nameEn ?? "") : (nameAr ?? "")
    }
    enum CodingKeys: String, CodingKey {
        case nameEn = "name_en"
        case id
        case createdAt = "created_at"
//        case deletedAt = "deleted_at"
        case country
        case countryID = "country_id"
        case updatedAt = "updated_at"
        case nameAr = "name_ar"
        case currencyID = "currency_id"
        case countryCode = "country_code"
    }
}
