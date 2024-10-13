//
//  EllectionFilters.swift
//  Arak
//
//  Created by Osama Abu Hdba on 31/07/2024.
//

import Foundation

struct EllectionFilters: Codable {
    let governorates, districts: [District]?
}

// MARK: - District
struct District: Codable {
    let id: Int?
    let name, nameAr: String?
//    let governorateID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
//        case governorateID = "governorate_id"
    }
}


struct EllectionData: Codable {
    let electedPeople: [EllectionPeople]?
//    let banners: Banners?
}

// MARK: - Banners
struct Banners: Codable {
    let data: [EllectionDataBanner]?
}

// MARK: - BannersDatum
struct EllectionDataBanner: Codable {
    let id: Int?
    let name: String?
    let img: String?
    let governorate, district: EllectionDistrict?
}

// MARK: - District
struct EllectionDistrict: Codable {
    let id: Int?
    let name, nameAr: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
    }
}

// MARK: - People
struct People: Codable {
    let data: [EllectionPeople]?
}

// MARK: - PeopleDatum
struct EllectionPeople: Codable {
    let id: Int?
    let name, description: String?
    let img: String?
    let coverImg: String?
    let email, phoneNo, cluster: String?
    let governorate: District?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, img
        case coverImg = "cover_img"
        case email
        case phoneNo = "phone_no"
        case cluster, governorate
    }
}


struct DataClass: Codable {
    let id: Int?
    let name: String?
    let img: String?
    let coverImg: String?
    let email, phoneNo, cluster: String?
    let governorate, district: District?

    enum CodingKeys: String, CodingKey {
        case id, name, img
        case coverImg = "cover_img"
        case email
        case phoneNo = "phone_no"
        case cluster, governorate, district
    }
}
