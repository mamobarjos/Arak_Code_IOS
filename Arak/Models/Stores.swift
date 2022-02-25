//
//  Stores.swift
//  Arak
//
//  Created by Osama Abu hdba on 18/02/2022.
//

import Foundation

struct StoresRespose: Codable {
    let storesData: StoresData
    let storeCategories: [StoreCategory]?

    enum CodingKeys: String, CodingKey {
        case storesData = "stores"
        case storeCategories = "store_categories"
    }
}

// MARK: - StoreCategory
struct StoreCategory: Codable {
    let id: Int
    let name: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Stores
struct StoresData: Codable {
    let data: [Store]
    let lastPageurl: String?
    let prevPageurl: String?
    let from: Int?
    let total: Int?
    let path: String?
    let firstPageurl: String?
    let lastPage: Int?
    let nextPageurl: String?
    let currentPage: Int?
    let perPage: Int?
    let to: Int?

    enum CodingKeys: String, CodingKey {
        case lastPageurl = "last_page_url"
        case prevPageurl = "prev_page_url"
        case from = "from"
        case total = "total"
        case path = "path"
        case firstPageurl = "first_page_url"
        case lastPage = "last_page"
        case nextPageurl = "next_page_url"
        case data = "data"
        case currentPage = "current_page"
        case perPage = "per_page"
        case to = "to"
    }
}

// MARK: - Datum
struct Store: Codable {
    let id: Int?
    let name: String?
    let desc: String?
    let website: String?
    let phoneNo: String?
    let lon: String?
    let lat: String?
    let img: String?
    let cover: String?
    let totalRates: Double?
    let facebook: String?
    let twitter: String?
    let instagram: String?
    let linkedin: String?
    let youtube: String?
    let snapchat: String?
    let userid: Int?
    let storeCategoryid: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case desc = "desc"
        case website = "website"
        case phoneNo = "phone_no"
        case lon = "lon"
        case lat = "lat"
        case img = "img"
        case cover = "cover"
        case totalRates = "total_rates"
        case facebook = "facebook"
        case twitter = "twitter"
        case instagram = "instagram"
        case linkedin = "linkedin"
        case youtube = "youtube"
        case snapchat = "snapchat"
        case userid = "user_id"
        case storeCategoryid = "store_category_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
