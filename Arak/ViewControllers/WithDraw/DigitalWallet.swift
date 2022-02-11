//
//  DigitalWallet.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 09/07/2021.
//

import Foundation
class DigitalWallet: Codable {
    let id: Int?
    let name, createdAt, updatedAt,name_ar: String?
    var nameTitle:String {
        return Helper.appLanguage ?? "en" == "en" ? (name ?? "") : (name_ar ?? "")
    }
    enum CodingKeys: String, CodingKey {
        case id, name,name_ar
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
