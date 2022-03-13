//
//  CreateStoreRespose.swift
//  Arak
//
//  Created by Osama Abu hdba on 25/02/2022.
//

import Foundation
//
//// MARK: - DataClass
struct StoreResponse: Codable {
    let youtube: String?
    let id: Int
    let lon: String?
    let linkedin: String?
    let storeCategoryid: Int?
    let createdAt: String?
    let userid: Int?
    let desc: String?
    let phoneNo: String?
    let lat: String?
    let img: String?
    let cover: String?
    let updatedAt: String?
    let snapchat: String?
    let facebook: String?
    let website: String?
    let instagram: String?
    let name: String?
    let twitter: String?

    enum CodingKeys: String, CodingKey {
        case userid = "user_id"
        case name = "name"
        case desc = "desc"
        case website = "website"
        case phoneNo = "phone_no"
        case lon = "lon"
        case lat = "lat"
        case img = "img"
        case cover = "cover"
        case facebook = "facebook"
        case twitter = "twitter"
        case instagram = "instagram"
        case linkedin = "linkedin"
        case youtube = "youtube"
        case snapchat = "snapchat"
        case storeCategoryid = "store_category_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id = "id"
    }
}
