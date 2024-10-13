//
//  APIRouter.swift
//  Arak
//
//  Created by Abed Qassim on 21/02/2021.
//

import Foundation
import Alamofire
enum APIRouter: APIConfiguration {
    
    case login(phone:String, password:String)
    case forget(email:String)
    case register(data: [String: Any])
    case socialRegisterLogin(data: [String: Any])
    case countries
    case cities(id:Int)
    case logout
    case deleteAccount
    case adsType
    case getPackagesByAdCategory(categoryId: Int)
    case getAdsCategory
    case adsList(page: Int , search:String, ad_category_id: Int?)
    case searchAd(title: String)
    case adsFilteredList(page: Int , type:Int)
    case adsDetail(id: Int)
    case featuredAds(page: Int, search:String)
    case services(page: Int)
    case transactions(page: Int, from: String, to: String)
    case arakFeedback(data: [String: String])
    case otp(data:[String: Any])
    case resetPassword(data:[String: Any])
    case editPassword(data:[String: Any])
    case changePhone(data:[String: Any])
    case withDraw(data:[String: String])
    case digitalWallets
    case getTopRanked(page: Int)
    case getFavorites(page: Int)
    case getHistory(page: Int)
    case getRandomProducts
    
    case favorites(adId: Int)
    case getUserBalance
    case editUserImg(data:[String: String], userid: Int)
    case editUserInfo(data:[String: Any], userid: Int)
    case notifications(page: Int)
    case userBanners(page:Int)
    case updateToken(token: String)
    case getUserAds(page:Int,isFilter: Bool , date_from:String, date_to: String)
    case createCoupon(code: String)
    case aboutData
    case deleteAds(adId: Int)
    case RequestArakService(name: String ,email: String , phoneNo: String,serviceId: String)
    case toggleNotifications
    case getNotificationsStatus
    case submitReview(content: String, rate: Int, ad_id: Int)
    case deleteReview(id: Int)
    
    case getEllectionFilters
    case getEllectionData(governorate_id: Int?, district_id: Int?)
    case getEllectionDetails(person_id: Int)
    case cliQPayment(data: [String: String])
    case addADs(data:[String: Any])
    case addStoreAds(data:[String: Any])
    case getUserInfo
    
    case getCutomeAdsContent(ad_category_id: Int)
    case createCustomePackage(data:[String: Any])

    
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login , .register ,.forget, .logout,.socialRegisterLogin,.arakFeedback,.otp,.resetPassword,.withDraw,.favorites,.updateToken,.createCoupon,.RequestArakService,.toggleNotifications, .submitReview, .cliQPayment, .addADs, .addStoreAds, .createCustomePackage:
            return .post
        case .adsType,.adsList,.searchAd,.adsFilteredList ,.getUserBalance , .adsDetail,.countries,.cities,.transactions,.featuredAds,.services,.digitalWallets,.getTopRanked,.notifications,.getFavorites,.userBanners,.getHistory,.getUserAds,.aboutData,.getNotificationsStatus, .getRandomProducts, .getEllectionFilters, .getEllectionData, .getEllectionDetails, .getAdsCategory, .getUserInfo, .getPackagesByAdCategory, .getCutomeAdsContent:
            return .get
        case .deleteAds, .deleteAccount, .deleteReview:
            return .delete
            
        case .editUserImg, .editUserInfo, .changePhone, .editPassword:
            return .patch
        }
    }
    // MARK: - Parameters
    var parameters: RequestParams {
        switch self {
        case .login(let username, let password):
            return .body(["phone_no":username,"password":password])
        case .forget(let email):
            return .body(["email":email])
        case .logout:
            return .body([:])
        case .adsType,.digitalWallets,.getUserBalance:
            return .url([:])
        case .getPackagesByAdCategory(let categoryId):
            return .url(["ad_category_id": categoryId])
        case .featuredAds(let page , _),.services(let page),.getTopRanked(let page),.notifications(let page),.getFavorites(let page),.userBanners(let page),.getHistory(let page):
            // TODO: ----
            return .url(["page":page, "is_featured": true])
            
        case .getUserAds(let page, let isFiltered , let dateFrom, let dateTo):
            if isFiltered {
                return .url(["date_from": dateFrom, "date_to": dateTo])
            } else {
                return .url([:])
            }
           
        case .transactions(_, let from, let to):
            return .url(["date_from": from, "date_to": to])
        case .getRandomProducts:
            return .url(["random":true])
        case .adsList(let page , _, let ad_category_id):
            if ad_category_id == nil {
                return .url(["page":page, "is_featured": false])
            } else {
                return .url(["page":page, "is_featured": false, "ad_category_id": ad_category_id!])
            }
        case .searchAd(let title):
            return .url(["title":title])
        case .adsFilteredList(let page , _):
            return .url(["page":page])
        case .adsDetail,.countries:
            return .url([:])
        case .cities(let id):
            return .url(["country_id":id])
        case .arakFeedback(let data),.withDraw(let data):
            return .body(data)
        case .register(data: let data):
            return .body(data)
        case .editUserImg(let data, _):
            return .body(data)
        case .editUserInfo(let data, _):
            return .body(data)
        case .socialRegisterLogin(let data),.otp(let data),.changePhone(let data),.resetPassword(let data),.editPassword(let data):
            return .body(data)
        case .favorites:
            return .url([:])
        case .updateToken(token: let token):
            return .body(["fcm_token": token])
        case .createCoupon(let code):
            return .body(["code": code])
        case .aboutData:
            return .url([:])
        case .RequestArakService(let name , let email, let phoneNo,let serviceId):
            return .body(["name" : name, "email" : email, "phone_no":phoneNo,"service_id": Int(serviceId) ?? 1])
        case .deleteAds(_):
            return .url([:])
        case .toggleNotifications:
            return .body([:])
        case .getNotificationsStatus:
            return .url([:])
        case .deleteAccount:
            return .url([:])
        case .submitReview(content: let content, rate: let rate, ad_id: let ad_id):
            return .body(["content":content, "rating":rate, "ad_id":ad_id])
        case .deleteReview:
            return .url([:])
            
        case .getEllectionFilters:
            return .url([:])
            
        case .getEllectionData(governorate_id: let governorate_id, district_id: let district_id):
            if governorate_id == nil {
                return .url([:])
            } else {
                return .url(["governorate_id":governorate_id ?? 1/*, "district_id": district_id ?? 1*/])
            }
        case .getEllectionDetails(person_id: let person_id):
            return .url([:])
        case .cliQPayment(data: let data):
            return .body(data)
        case .addADs(let data):
            return .body(data)
        case .addStoreAds(let data):
            return .body(data)
        case .getAdsCategory:
            return .url([:])
            
        case .getUserInfo:
            return .url([:])
        case .getCutomeAdsContent(ad_category_id: let id):
            return .url(["ad_category_id":id])
        case .createCustomePackage(data: let data):
            return .body(data)
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .adsType:
            return "ad-categories"
        case .getPackagesByAdCategory:
            return "ad-packages"
        case .adsList(_,let search, _):
            return search.isEmpty ?  "ads" : "ads/\(search)"
        case .searchAd:
            return "ads"
        case .adsFilteredList(_, type: let type):
            return "ads/get-ads-by-category-id/\(type)"
        case .register:
            return "users"
        case .logout:
            return "auth/logout"
        case .forget:
            return "auth/recover"
        case .adsDetail(let id):
            return "ads/\(id)"
        case .countries:
            return "countries"
        case .cities:
            return "cities"
        case .transactions:
            return "transactions"
        case .socialRegisterLogin(_):
            return "social-register-login"
        case .featuredAds(_,_):
            return "ads"
        case .arakFeedback(_):
            return "feedbacks"
        case .services(_):
            return "services"
        case .otp(_):
            return "otp/send"
        case .resetPassword(_):
            return "users/forget-password"
        case .changePhone(_):
            return "users/\(Helper.currentUser?.id ?? 0)/phone"
        case .withDraw(_):
            return "withdraw-requests"
        case .digitalWallets:
            return "digital-wallets"
        case .getTopRanked(_):
            return "users/get-top-ranked-users-by-balance"
        case .getRandomProducts:
            return "store-products"
        case .favorites(let id):
//            return isFavorate ? "favorites/unfavorite-ad" : "favorites/favorite-ad"
        return "ads/\(id)/favorite"
        case .editUserInfo(_, let id):
            return "users/\(id)/info"
        case .editUserImg(_, let id):
            return "users/\(id)/img"
        case .getUserBalance:
            return "users/profile/balance"
        case .notifications(_):
            return "notifications"
        case .editPassword(_):
            return "users/\(Helper.currentUser?.id ?? 0)/password"
        case .getFavorites(_):
            return "ads/user/favorites"
        case .userBanners(_):
            return "banners"
        case .getHistory(_):
            return "ads/user/history"
        case .updateToken(_):
            return "notifications/update-token"
        case .getUserAds(_,let isFilter , let year, let month):
            return "ads/user/my-ads"
        case .createCoupon(_):
            return "coupons/consume"
        case .aboutData:
            return "content/1"
        case .RequestArakService(_,_,_,_):
            return "requested-services"
        case .deleteAds(let adId):
            return "ad/\(adId)"
        case .toggleNotifications:
            return "notifications/toggle-notifications-status"
        case .getNotificationsStatus:
            return "notifications/get-notifications-status"
        case .deleteAccount:
            return "user/account/delete-account"
        case .submitReview:
            return "ad-reviews"
        case .deleteReview(id: let id):
            return "ad-reviews/\(id)"
        case .getEllectionFilters:
            return "governorates"
            
        case .getEllectionData:
            return "elected-people"
        case .getEllectionDetails(let id):
            return "elected-people/\(id)"
        case .cliQPayment:
            return "cliq-payments"
        case .addADs:
            return "ads"
        case .addStoreAds:
            return "ads/custom/store-ads"
        case .getAdsCategory:
            return "ad-categories"
        case .getUserInfo:
            return "users/profile/info"
        case .getCutomeAdsContent:
            return "content/custom/data"
        case .createCustomePackage:
            return "ad-packages/custom"
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(Helper.appLanguage ?? "en", forHTTPHeaderField: HTTPHeaderField.acceptLanguage.rawValue)
        urlRequest.setValue(Helper.apiKey,forHTTPHeaderField: HTTPHeaderField.api_key.rawValue)
        
        if (Helper.isLoggingUser()) {
            urlRequest.setValue("Bearer \(Helper.userToken ?? "")", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        
        // Parameters
        switch parameters {
        
        case .body(let params):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            
        case .url(let params):
            let queryParams = params.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        }
        return urlRequest
    }
    
    
}
