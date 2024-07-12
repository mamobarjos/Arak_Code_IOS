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
    case register(data: [String: String])
    case socialRegisterLogin(data: [String: Any])
    case countries
    case cities(id:Int)
    case logout
    case deleteAccount
    case adsType
    case adsList(page: Int , search:String)
    case adsFilteredList(page: Int , type:Int)
    case adsDetail(id: Int)
    case featuredAds(page: Int, search:String)
    case services(page: Int)
    case transactions(page: Int,isFilter: Bool , year:String, month: String)
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
    
    case favorites(data:[String: String],isFavorate: Bool)
    case getUserBalance
    case editUserImg(data:[String: String])
    case editUserInfo(data:[String: String])
    case notifications(page: Int)
    case userBanners(page:Int)
    case updateToken(token: String)
    case getUserAds(page:Int,isFilter: Bool , year:String, month: String)
    case createCoupon(code: String)
    case aboutData
    case deleteAds(adId: Int)
    case RequestArakService(name: String ,email: String , phoneNo: String,serviceId: String)
    case toggleNotifications
    case getNotificationsStatus
    case submitReview(content: String, rate: Int, ad_id: Int)
    case deleteReview(id: Int)

    
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login , .register ,.forget,.editUserImg,.editUserInfo , .logout,.socialRegisterLogin,.arakFeedback,.otp,.resetPassword,.changePhone,.withDraw,.favorites,.editPassword,.updateToken,.createCoupon,.RequestArakService,.toggleNotifications, .submitReview:
            return .post
        case .adsType,.adsList,.adsFilteredList ,.getUserBalance , .adsDetail,.countries,.cities,.transactions,.featuredAds,.services,.digitalWallets,.getTopRanked,.notifications,.getFavorites,.userBanners,.getHistory,.getUserAds,.aboutData,.getNotificationsStatus, .getRandomProducts:
            return .get
        case .deleteAds, .deleteAccount, .deleteReview:
            return .delete
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
        case .featuredAds(let page , _),.services(let page),.getTopRanked(let page),.notifications(let page),.getFavorites(let page),.userBanners(let page),.getHistory(let page),.getUserAds(let page,_,_,_),.transactions(let page,_,_,_):
            return .url(["page":page])
        case .getRandomProducts:
            return .url([:])
        case .adsList(let page , _):
            return .url(["page":page])
        case .adsFilteredList(let page , _):
            return .url(["page":page])
        case .adsDetail,.countries,.cities(_):
            return .url([:])
        case .register(data: let data),.arakFeedback(let data),.withDraw(let data),.editUserImg(let data),.editUserInfo(let data):
            return .body(data)
        case .socialRegisterLogin(let data),.otp(let data),.changePhone(let data),.resetPassword(let data),.editPassword(let data):
            return .body(data)
        case .favorites(let data,_):
            return .body(data)
        case .updateToken(token: let token):
            return .body(["fcm_token": token])
        case .createCoupon(let code):
            return .body(["coupoun_code": code])
        case .aboutData:
            return .url([:])
        case .RequestArakService(let name , let email, let phoneNo,let serviceId):
            return .body(["name" : name, "email" : email, "phone_no":phoneNo,"service_id": serviceId])
        case .deleteAds(_):
            return .url([:])
        case .toggleNotifications:
            return .body([:])
        case .getNotificationsStatus:
            return .url([:])
        case .deleteAccount:
            return .url([:])
        case .submitReview(content: let content, rate: let rate, ad_id: let ad_id):
            return .body(["content":content, "rate":rate, "ad_id":ad_id])
        case .deleteReview:
            return .url([:])
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .adsType:
            return "ads-categories"
        case .adsList(_,let search):
            return search.isEmpty ?  "ads" : "ads/\(search)"
        case .adsFilteredList(_, type: let type):
            return "ads/get-ads-by-category-id/\(type)"
        case .register:
            return "auth/register"
        case .logout:
            return "auth/logout"
        case .forget:
            return "auth/recover"
        case .adsDetail(let id):
            return "ad/\(id)"
        case .countries:
            return "countries"
        case .cities(let id):
            return "cities/get-cities-by-country/\(id)"
        case .transactions(_,let isFilter , let year, let month):
            return isFilter ? "transactions/filter-user-transactions/\(year)/\(month)": "transactions/get-user-transactions"
        case .socialRegisterLogin(_):
            return "social-register-login"
        case .featuredAds(_,_):
            return "ads/get-featured-ads"
        case .arakFeedback(_):
            return "feedback/post-feedback"
        case .services(_):
            return "services"
        case .otp(_):
            return "otp/send-otp"
        case .resetPassword(_):
            return "user/forget-pass"
        case .changePhone(_):
            return "user/edit-user-phone"
        case .withDraw(_):
            return "withdraw/withdraw-request"
        case .digitalWallets:
            return "digital-wallets"
        case .getTopRanked(_):
            return "users/get-top-ranked-users-by-balance"
        case .getRandomProducts:
            return "store-products/get-random-products-from-many-stores"
        case .favorites(_,_):
//            return isFavorate ? "favorites/unfavorite-ad" : "favorites/favorite-ad"
        return "favorites/favorite-ad"
        case .editUserInfo(_):
            return "user/edit-user-info"
        case .editUserImg(_):
            return "user/edit-user-img"
        case .getUserBalance:
            return "user/get-user-balance"
        case .notifications(_):
            return "notifications/get-user-notifications"
        case .editPassword(_):
            return "user/edit-user-pass"
        case .getFavorites(_):
            return "favorites/get-user-favorites"
        case .userBanners(_):
            return "banners/get-banners"
        case .getHistory(_):
            return "histories/get-user-history"
        case .updateToken(_):
            return "notifications/update-token"
        case .getUserAds(_,let isFilter , let year, let month):
            return isFilter ? "ads/filter-user-ads/\(year)/\(month)" : "ads/get-user-ads"
        case .createCoupon(_):
            return "coupoun/consume-coupoun"
        case .aboutData:
            return "about-data"
        case .RequestArakService(_,_,_,_):
            return "services/request-arak-service"
        case .deleteAds(let adId):
            return "ad/\(adId)"
        case .toggleNotifications:
            return "notifications/toggle-notifications-status"
        case .getNotificationsStatus:
            return "notifications/get-notifications-status"
        case .deleteAccount:
            return "user/account/delete-account"
        case .submitReview:
            return "ad-reviews/add-review"
        case .deleteReview(id: let id):
            return "ad-reviews/delete-review/\(id)"
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
