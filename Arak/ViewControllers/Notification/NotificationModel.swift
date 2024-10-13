//
//  NotificationModel.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 10/07/2021.
//

import Foundation

struct NotificationResponseContainer: Codable {
    let data: NotificationResponse?
//    let total, page, limit: Int?
}

struct NotificationResponse: Codable {
    let notifications: [NotificationModel]?
    let notificationCount: String?
    
    enum CodingKeys: String, CodingKey {
        case notifications
        case notificationCount = "notification_count"
    }
}

struct NotificationModel: Codable {
    let id: Int?
    let title, description, type: String?
    let url: String?
    let isRead: Bool?
//    let userID, senderID: JSONNull?
    let createdAt, updatedAt: String?
//    let deletedAt: JSONNull?
    var isCollaped = true

    enum CodingKeys: String, CodingKey {
        case id, title, description, type, url
        case isRead = "is_read"
//        case userID = "user_id"
//        case senderID = "sender_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
//        case deletedAt = "deleted_at"
    }
}
