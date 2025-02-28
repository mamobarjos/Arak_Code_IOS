//
//  NotificationViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//

import Foundation
import FirebaseMessaging
class NotificationViewModel {
    
    private var notificationList: [NotificationModel] = []
    private(set) var hasPage = true
    private(set) var checkoutURL = ""
    
    var notificationItemCount: Int {
        return notificationList.count
    }
    
    func notification(at index: Int) -> NotificationModel {
        return notificationList[index]
    }
    func changeCollapsed(at index: Int , isCollaped: Bool) {
        notificationList[index].isCollaped =  isCollaped
    }
    
    
}


extension NotificationViewModel {
    
    func getNotifications(page:Int ,compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.notifications(page: page), decodable: NotificationResponseContainer.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            if page == 1 {
                self.notificationList = []
            }
            
            self.hasPage = (response?.data?.data?.notifications ?? []).count != 0
            self.notificationList.append(contentsOf: response?.data?.data?.notifications ?? [])
            Helper.notificationCount = response?.data?.data?.notificationCount ?? "0"
            compliation(nil)
        }
    }
    
    func getStaticLinks(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.aboutData, decodable: ArakLinks.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            print(response?.data?.isLive)
            Helper.arakLinks = response?.data
            compliation(nil)
        }
    }
    
    func toggleNotification(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.toggleNotifications, decodable: Int.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            Helper.updateSubscription(isEnable: response?.data ?? 0 == 1)
            compliation(nil)
        }
    }
    
    
    
    func getNotificationsStatus(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.getNotificationsStatus, decodable: Int.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            Helper.updateSubscription(isEnable: response?.data ?? 0 == 1)
            compliation(nil)
        }
    }
    
    func updateToken(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.updateToken(token: Messaging.messaging().fcmToken ?? ""), decodable: User.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            Helper.currentUser = response?.data
            compliation(nil)
        }
    }
}
