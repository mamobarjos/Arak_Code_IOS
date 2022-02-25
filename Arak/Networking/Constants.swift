//
//  Constants.swift
//  Arak
//
//  Created by Abed Qassim on 21/02/2021.
//

import Foundation
import Alamofire

struct Constants {
    struct ProductionServer {
//        static let baseURL = "https://arakads.live/api/"
        static let baseURL = "https://stg.arakads.live/api/"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
    case api_key = "x-api-key"

}


enum ContentType: String {
    case json = "Application/json"
    case formEncode = "application/x-www-form-urlencoded"
}

enum RequestParams {
    case body(_:Parameters)
    case url(_:Parameters)
}

enum NetworkResponse:String {
  case success
  case authenticationError = "Please sign in again"
  case generalError = "Bad request"
  case outdated = "The url you requested is outdated."
  case failed = "Network request failed."
  case internet = "Check internet connection."
  case noData = "Response returned with no data to decode."
  case unableToDecode = "We could not decode the response."
    case walletInsufficient = "WALLET_INSUFFICIENT"
}

enum AdsTypes: Int {
  case video = 2
  case image = 1
  case videoWeb = 3
}
