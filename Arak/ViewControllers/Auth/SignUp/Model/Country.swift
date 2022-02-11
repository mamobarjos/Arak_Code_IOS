//
//  Country.swift
//  Arak
//
//  Created by Abed Qassim on 29/05/2021.
//

import Foundation
struct Country: Codable {
    let id: Int?
    var name:String {
        return Helper.appLanguage ?? "en" == "en" ? (name_en ?? "") : (name_ar ?? "")
    }
    let name_ar:String?
    let name_en:String?
    enum CodingKeys: String, CodingKey {
        case id,name_ar,name_en
    }
}
