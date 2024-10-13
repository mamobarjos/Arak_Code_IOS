//
//  User.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import Foundation

struct UserModel: Codable {
    let accessToken: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user
    }
}

struct User: Codable {
    let id: Int?
    var fullname, password, phoneNo, birthdate: String?
    let gender: String?
    let countryID, cityID: Int?
    var role, balance: String?
    var imgAvatar: String?
    let notificationsEnabled: Bool?
    let fcmToken: String?
    var isActive, hasStore, hasWallet: Bool?
    let adsImgsViews, adsVideosViews, adsWebsiteViews: Int?
//    let preferences, oauthID, slProvider: JSONNull?
    let createdAt: String?
//    let updatedAt, deletedAt: JSONNull?
    let accessToken: String?
    let country: Country?
    
    var balanceTitle: String  {
        return "\(balance ?? "0") \((Helper.currencyCode ?? "JOD"))"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, fullname, password
        case phoneNo = "phone_no"
        case birthdate, gender
        case countryID = "country_id"
        case cityID = "city_id"
        case role, balance
        case imgAvatar = "img_avatar"
        case notificationsEnabled = "notifications_enabled"
        case fcmToken = "fcm_token"
        case isActive = "is_active"
        case hasStore = "has_store"
        case hasWallet = "has_wallet"
        case adsImgsViews = "ads_imgs_views"
        case adsVideosViews = "ads_videos_views"
        case adsWebsiteViews = "ads_website_views"
        case accessToken = "access_token"
//        case preferences
//        case oauthID = "oauthId"
//        case slProvider = "sl_provider"
        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case deletedAt = "deleted_at"
        case country
        
    }
}
