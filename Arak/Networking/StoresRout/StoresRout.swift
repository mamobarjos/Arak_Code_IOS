//
//  StoresRout.swift
//  Arak
//
//  Created by Osama Abu hdba on 18/02/2022.
//

import Foundation
import Alamofire

enum StoresRout: APIConfiguration {
    case createStore(data: [String:Any])
    case getStores(page: Int)
    case filterStoresByCategory(category: Int, page: Int)
    case searchStore(storeName: String)

    case getSingleStore(id: Int)
    case getUserStore

    case createProduct(data: [String:Any])
    case getStoreProducts(storeId: Int, page: Int)
    case getStoreSingleProduct(productId: Int)

    case submitReview(content: String, rate: Int, store_id: Int)
    case deleteStoreReview(id: Int)

    case submiteProductReview(content: String, rate: Int, store_product_id: Int)
    case deleteProductReview(id: Int)

    case getCategories

    case updateStore(id: Int, data: [String:Any])
    case updateProduct(id: Int, data: [String:Any])
    case getUserProducts(page: Int)

    case getProductsByCategory(categoryId: Int, page: Int)

    var method: HTTPMethod {
        switch self {
        case .createStore: return .post
        case .getStores: return .get
        case .filterStoresByCategory: return .get
        case .searchStore: return .get
        case .getSingleStore: return .get
        case .createProduct: return .post
        case .getStoreProducts: return .get
        case .getStoreSingleProduct: return .get
        case .submitReview: return .post
        case .deleteStoreReview: return .delete
        case .getCategories: return .get

        case .updateStore:return .post
        case .updateProduct:return .post
        case .getUserStore: return .get
        case .submiteProductReview: return .post
        case .deleteProductReview: return .delete
        case .getUserProducts: return .get

        case .getProductsByCategory:
            return .get
        }
    }

        var path: String {
            switch self {
            case .createStore: return "stores/create-store"
            case .getStores: return "stores/get-stores"
            case .filterStoresByCategory(let categoryId, _): return "stores/filter-stores-by-category/\(categoryId)"
            case .searchStore(let storeName): return "stores/search-stores/\(storeName)"
            case .getSingleStore(let storeId): return "stores/get-single-store/\(storeId)"
            case .createProduct: return "store-products/create-product"
            case .getStoreProducts(let storeId, _): return "store-products/get-store-products/\(storeId)"
            case .getStoreSingleProduct(let productId): return "store-products/get-single-store-product/\(productId)"
            case .submitReview: return "store-reviews/add-review"
            case .deleteStoreReview(let id):
                return "store-reviews/delete-review/\(id)"
            case .getCategories: return "store-categories"
            case .updateStore(let id, _):
                return "stores/update-store/\(id)"
            case .updateProduct(let id, _):
                return "store-products/update-product/\(id)"
            case .getUserStore:
                return "stores/get-user-store"
            case .submiteProductReview: return "store-product-reviews/add-review"
            case .deleteProductReview(id: let id): return "store-product-reviews/delete-review/\(id)"
            case .getUserProducts:
                return "store-products/get-user-store-products"
            case .getProductsByCategory(let id, _):
                return "stores/filter-store-products-by-category/\(id)"
            }
        }

        var parameters: RequestParams {
            switch self {
            case .createStore(let data):
                return .body(data)
            case .getStores(let page):
                return.url(["page":page])
            case .filterStoresByCategory(_,let page):
                return.url(["page":page])
            case .searchStore:
                return.url([:])
            case .getSingleStore:
                return.url([:])
            case .createProduct(let data):
                return .body(data)
            case .getStoreProducts(_,let page):
                return.url(["page":page])
            case .getStoreSingleProduct:
                return.url([:])
            case .submitReview(content: let content, rate: let rate, store_id: let storeID):
                return .body(["content":content, "rate":rate, "store_id":storeID])
            case .deleteStoreReview:
                return .url([:])
            case .getCategories:
                return .url([:])
            case .updateStore(_ , let data):
                return .body(data)
            case .updateProduct(_ , let data):
                return .body(data)
            case .getUserStore:
                return .url([:])
            case .submiteProductReview(content: let content, rate: let rate, store_product_id: let storeID):
                return .body(["content":content, "rate":rate, "store_product_id":storeID])
            case .deleteProductReview(id: let id):
                return .url([:])
            case .getUserProducts(let page):
                return.url(["page":page])
            case .getProductsByCategory(categoryId: let categoryId, page: let page):
                return .url([:])
            }
        }

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
