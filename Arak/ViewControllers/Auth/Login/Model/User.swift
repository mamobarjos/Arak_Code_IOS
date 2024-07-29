//
//  User.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import Foundation

struct User: Codable {
    let fullname: String?
    let cityID, adsImgsViews: Int?
//    let oauthID, preferences, imgAvatar: JSONNull?
    var imgAvatar: String?
    let notificationsEnabled: Bool?
//    let updatedAt: JSONNull?
    let hasStore: Bool?
    var balance: String?
    let id: Int?
    let gender: String?
    let countryID: Int?
    var phoneNo: String?
    let fcmToken: String?
    let birthdate: String?
    let isActive, hasWallet: Bool?
    let adsVideosViews: Int?
    let role: String?
//    let slProvider, deletedAt: JSONNull?
    let createdAt, password: String?
    let adsWebsiteViews: Int?
    
    var balanceTitle: String  {
        return "\(balance ?? "") \("JOD".localiz())"
    }
    
    enum CodingKeys: String, CodingKey {
        case fullname
        case cityID = "city_id"
        case adsImgsViews = "ads_imgs_views"
//        case oauthID = "oauthId"
//        case preferences
//        case imgAvatar = "img_avatar"
        case notificationsEnabled = "notifications_enabled"
//        case updatedAt = "updated_at"
        case hasStore = "has_store"
        case balance, id, gender
        case countryID = "country_id"
        case phoneNo = "phone_no"
        case fcmToken = "fcm_token"
        case birthdate
        case isActive = "is_active"
        case hasWallet = "has_wallet"
        case adsVideosViews = "ads_videos_views"
        case role
//        case slProvider = "sl_provider"
//        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case password
        case adsWebsiteViews = "ads_website_views"
        
    }
}
