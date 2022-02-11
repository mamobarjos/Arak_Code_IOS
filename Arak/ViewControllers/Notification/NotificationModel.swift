//
//  NotificationModel.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 10/07/2021.
//

import Foundation

struct NotificationResponse: Codable {
    var notifications: PagingModel<[NotificationModel]>?
    var notifCount : String?
    enum CodingKeys: String, CodingKey {
        case notifications
        case notifCount = "notif_count"
    }
}
struct NotificationModel: Codable {
    var id: Int?
    var title, desc, type: String?
    var isRead: Int?
    var userID: Int?
    var createdAt, updatedAt: String?
    var isCollaped = true

    enum CodingKeys: String, CodingKey {
        case id, title, desc, type
        case isRead = "is_read"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
