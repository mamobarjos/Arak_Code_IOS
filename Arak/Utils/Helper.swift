//
//  Helper.swift
//  Arak
//
//  Created by Abed Qassim on 21/02/2021.
//

import UIKit
import FirebaseMessaging
class Helper {
    enum UserType: String {
        case GUEST
        case NORMAL
    }
    
    static func CellPhone(_ phone:String)  {
        if (phone == ""){
            return
        }
        let urlString:String = "tel://\(phone.replacedArabicDigitsWithEnglish)"
        if let phoneCallURL = URL(string: urlString) {
            if (UIApplication.shared.canOpenURL(phoneCallURL)) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    static var apiKey: String {
        return "yzjPf7Ng7ccQwJeBjVa6Uj3hWM8PcMyz"
    }
    
    static func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    static var fcmToken:String?{
        get{
            let token = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
            return token
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "fcmToken")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isEnabelNotification:Bool{
        get{
            let token = UserDefaults.standard.bool(forKey: "isEnabelNotification")
            return token
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isEnabelNotification")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isBiomatricAvailable:Bool{
        get{
            let available = UserDefaults.standard.bool(forKey: "isBiomatricAvailable")
            return available
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isBiomatricAvailable")
            UserDefaults.standard.synchronize()
        }
    }

    static func updateSubscription(isEnable: Bool) {
        isEnabelNotification = isEnable
        if isEnable {
            
            Messaging.messaging().subscribe(toTopic: "general") { error in
                if error != nil {
                    return
                }
            }
        }else {
            Messaging.messaging().unsubscribe(fromTopic: "general") { error in
                if error != nil {
                    return
                }
            }
        }
    }
    static func OpenMap(_ lat:Double = 31.9989997 , _ lng:Double = 31.9989997) {
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        {
            let urlString = "http://maps.google.com/?daddr=\(lat),\(lng)&directionsmode=driving"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
            
        }
        else
        {
            let urlString = "http://maps.apple.com/?address=\(lat),\(lng)"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }        }
    }
    
    
    static func isLoggingUser() -> Bool {
        guard let token = userToken else {
            return false
        }
        return !token.isEmpty
    }
    static func resetLoggingData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey:"currentUser")
        defaults.removeObject(forKey:"token")
    }
    static var appLanguage:String? {
        get{
            let firstLunch = UserDefaults.standard.string(forKey: "appLanguage")
            return firstLunch
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "appLanguage")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var notificationCount:String? {
        get{
            let firstLunch = UserDefaults.standard.string(forKey: "notificationCount")
            return firstLunch
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "notificationCount")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var userType:String? {
        get{
            let firstLunch = UserDefaults.standard.string(forKey: "userType")
            return firstLunch
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "userType")
            UserDefaults.standard.synchronize()
        }
    }
    static var userToken:String?{
        get{
            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            return token
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "token")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    
    static var hasTopNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }else{
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    static var arakLinks:ArakLinks? {
        get {
            let userDefaults = UserDefaults.standard
            do {
                let user = try userDefaults.getObject(forKey: "ArakLinks", castTo: ArakLinks.self)
                return user
            } catch {
                print(error.localizedDescription)
            }
            return nil
        }
        set{
            let userDefaults = UserDefaults.standard
            do {
                try userDefaults.setObject(newValue, forKey: "ArakLinks")
                userDefaults.synchronize()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static var currentUser:User? {
        get {
            let userDefaults = UserDefaults.standard
            do {
                let user = try userDefaults.getObject(forKey: "currentUser", castTo: User.self)
                return user
            } catch {
                print(error.localizedDescription)
            }
            return nil
        }
        set{
            let userDefaults = UserDefaults.standard
            do {
                try userDefaults.setObject(newValue, forKey: "currentUser")
                userDefaults.synchronize()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static var store: StoreResponse? {
        get {
            let userDefaults = UserDefaults.standard
            do {
                let user = try userDefaults.getObject(forKey: "store", castTo: StoreResponse.self)
                return user
            } catch {
                print(error.localizedDescription)
            }
            return nil
        }
        set{
            let userDefaults = UserDefaults.standard
            do {
                try userDefaults.setObject(newValue, forKey: "store")
                userDefaults.synchronize()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
