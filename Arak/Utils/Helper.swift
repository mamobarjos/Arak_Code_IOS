//
//  Helper.swift
//  Arak
//
//  Created by Abed Qassim on 21/02/2021.
//

import UIKit
import FirebaseMessaging
import DropDown
class Helper {
    typealias CompletionHandler = (Index, String) -> Void
    enum UserType: String {
        case GUEST
        case NORMAL
    }
    
    static var currencyCode = Helper.country?.currency?.symbol
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
        return "w0QEzdIHjitCUB902JGf6q2xgyGKoP9A"
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
    
    static var CartItemsCount:Int? {
        get{
            let firstLunch = UserDefaults.standard.string(forKey: "CartItemsCount") ?? "1"
            return Int(firstLunch)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "CartItemsCount")
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
    
    static var country:Country? {
        get {
            let userDefaults = UserDefaults.standard
            do {
                let user = try userDefaults.getObject(forKey: "country", castTo: Country.self)
                return user
            } catch {
                print(error.localizedDescription)
            }
            return nil
        }
        set{
            let userDefaults = UserDefaults.standard
            do {
                try userDefaults.setObject(newValue, forKey: "country")
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

    static var UserStoreId: Int? {
        get {
            let userDefaults = UserDefaults.standard
            do {
                let user = try userDefaults.getObject(forKey: "UserStoreId", castTo: Int.self)
                return user
            } catch {
                print(error.localizedDescription)
            }
            return nil
        }
        set{
            let userDefaults = UserDefaults.standard
            do {
                try userDefaults.setObject(newValue, forKey: "UserStoreId")
                userDefaults.synchronize()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static var store: Store? {
        get {
            let userDefaults = UserDefaults.standard
            do {
                let user = try userDefaults.getObject(forKey: "store", castTo: Store.self)
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
    
    class func setupDropDown(dropDownBtn: UIView , dropDown: DropDown , imagesArr: [UIImage]? = nil , stringsArr : [String] ,  completion: @escaping CompletionHandler) {
        self.customizeDropDown()
        dropDown.anchorView = dropDownBtn
        dropDown.bottomOffset = CGPoint(x: 0, y: dropDownBtn.bounds.height)
        dropDown.dataSource = stringsArr
        if imagesArr != nil {
            dropDown.cellNib = UINib(nibName: "dropDownTableCell", bundle: nil)
            dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                cell.textLabel?.textAlignment = .right
                print("Item\(item)")
            }
        }
        dropDown.selectionAction = { (index, item) in
            completion(index , item)
        }
    }
    
    class func customizeDropDown() {
        let appearance = DropDown.appearance()
        appearance.backgroundColor = .white
        appearance.selectionBackgroundColor = #colorLiteral(red: 1, green: 0.4309999943, blue: 0.1800000072, alpha: 0.5)
        appearance.layer.cornerRadius = 20
        appearance.layer.masksToBounds = true
        appearance.layer.shadowColor = UIColor(white: 0.6, alpha: 1).cgColor
        appearance.layer.shadowOpacity = 0.9
        appearance.layer.shadowRadius = 10
        appearance.animationduration = 0.2
        appearance.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        //        appearance.textFont = UIFont.appFontRegular(ofSize: 13)
        if #available(iOS 11.0, *) {
            appearance.setupMaskedCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner])
        }
    }
}
