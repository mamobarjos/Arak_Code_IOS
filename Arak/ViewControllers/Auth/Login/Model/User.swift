//
//  User.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import Foundation

struct User: Codable {
    let id: Int?
    let fullname, email, city,country, gender: String?
    var imgAvatar, emailVerifiedAt: String?
    var phoneNo: String?
    let role: Int?
    let roleLabel: String?
    let  isActive, adsImgsViews, adsVideosViews, adsWebsiteViews: Int?
    let isActiveLabel, createdAt, updatedAt: String?
    let socialToken: String?
    var balance: Double?
    var companyName: String?
    let hasStore: Int
    
    var balanceTitle: String  {
        return "\(balance ?? 0) \("JOD".localiz())"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, fullname, email, city, gender,country
        case imgAvatar = "img_avatar"
        case emailVerifiedAt = "email_verified_at"
        case phoneNo = "phone_no"
        case role
        case roleLabel = "role_label"
        case balance
        case isActive = "is_active"
        case isActiveLabel = "is_active_label"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adsImgsViews = "ads_imgs_views"
        case adsVideosViews = "ads_videos_views"
        case adsWebsiteViews = "ads_website_views"
        case socialToken = "social_token"
        case companyName = "company_name"
        case hasStore = "has_store"
        
    }
}
