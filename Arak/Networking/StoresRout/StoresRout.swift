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
    case getStores(page: Int, category: Int)
    case filterStoresByCategory(category: Int, page: Int)
    case searchStore(storeName: String)

    case getSingleStore(id: Int)
    case getUserStore

    case createProduct(data: [String:Any])
    case getStoreProducts(storeId: Int, page: Int)
    case getStoreSingleProduct(productId: Int)
    case getArakProductsCatigores
    case getArakProducts(categotyId: Int)
    case getArakProductVariants(productId: Int)
    case createOrder(form: CreateOrderForm)

    case submitReview(content: String, rate: Int, store_id: Int)
    case deleteStoreReview(id: Int)

    case submiteProductReview(content: String, rate: Int, store_product_id: Int)
    case deleteProductReview(id: Int)

    case getCategories
    case updateUserIntrest(data: [String:Any])

    case updateStore(id: Int, data: [String:Any])
    case updateProduct(id: Int, data: [String:Any])
    case getUserProducts(page: Int)

    case getProductsByCategory(categoryId: Int, page: Int)
    case deleteProduct(productId: Int)

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
        case .updateUserIntrest: return .post
        case .getArakProductsCatigores: return .get
        case .getArakProducts: return .get
        case .getArakProductVariants: return .get
        case .createOrder: return .post
            
            
        case .updateStore:return .patch
        case .updateProduct:return .patch
        case .getUserStore: return .get
        case .submiteProductReview: return .post
        case .deleteProductReview: return .delete
        case .getUserProducts: return .get

        case .getProductsByCategory:
            return .get
        case .deleteProduct:
            return .delete
        }
    }

        var path: String {
            switch self {
            case .createStore: return "stores"
            case .getStores: return "stores"
            case .filterStoresByCategory(let categoryId, _): return "stores/filter-stores-by-category/\(categoryId)"
            case .searchStore: return "stores"
            case .getSingleStore(let storeId): return "stores/\(storeId)"
            case .createProduct: return "store-products"
            case .getStoreProducts(let storeId, _): return "store-products/\(storeId)/related"
            case .getStoreSingleProduct(let productId): return "store-products/\(productId)"
            case .submitReview: return "store-reviews"
            case .deleteStoreReview(let id):
                return "store-reviews/\(id)"
            case .getCategories: return "store-categories"
            case .updateUserIntrest: return "users/update-preferences"
            case .updateStore(let id, _):
                return "stores/\(id)"
            case .updateProduct(let id, _):
                return "store-products/\(id)"
            case .getUserStore:
                return "stores/user/my-store"
            case .getArakProductsCatigores:
                return "stores/arak-store/categories"
            case .getArakProducts:
                return "stores/arak-store/products"
            case .getArakProductVariants:
                return "stores/arak-store/products/variations"
            case .createOrder:
                return "stores/arak-store/order"
                
            case .submiteProductReview: return "store-product-reviews"
            case .deleteProductReview(id: let id): return "store-product-reviews/\(id)"
            case .getUserProducts:
                return "store-products/user/my-products"
            case .getProductsByCategory(let id, _):
                return "stores/filter-store-products-by-category/\(id)"
            case .deleteProduct(productId: let id):
                return "store-products/\(id)"
            }
        }

        var parameters: RequestParams {
            switch self {
            case .createStore(let data):
                return .body(data)
            case .getStores(let page, let categoryID):
                if categoryID == -1 {
                    return.url(["page":page])
                } else {
                    return.url(["page":page, "store_category_id": categoryID])
                }
                
            case .filterStoresByCategory(_,let page):
                return.url(["page":page])
            case .searchStore(let storeName):
                return.url(["name":storeName])
            case .getSingleStore:
                return.url([:])
            case .createProduct(let data):
                return .body(data)
            case .getStoreProducts(_,let page):
                return.url([:])
            case .getStoreSingleProduct:
                return.url([:])
            case .submitReview(content: let content, rate: let rate, store_id: let storeID):
                return .body(["content":content, "rating":rate, "store_id":storeID])
            case .deleteStoreReview:
                return .url([:])
            case .getCategories:
                return .url([:])
            case .updateUserIntrest(let data):
                return .body(data)
            case .updateStore(_ , let data):
                return .body(data)
            case .updateProduct(_ , let data):
                return .body(data)
            case .getUserStore:
                return .url([:])
            case .submiteProductReview(content: let content, rate: let rate, store_product_id: let storeID):
                return .body(["content":content, "rating":rate, "store_product_id":storeID])
            case .deleteProductReview(id: let id):
                return .url([:])
            case .getUserProducts(let page):
                return.url(["page":page])
            case .getProductsByCategory(categoryId: let categoryId, page: let page):
                return .url([:])
            case .getArakProductsCatigores:
                return .url([:])
            case .getArakProducts(let id):
                if id  == -1 {
                    return .url([:])
                } else {
                    return .url(["category":id])
                }
               
            case .getArakProductVariants(let productId):
                return.url(["product_id":productId])
                
            case .createOrder(form: let form):
                return .body(form.toDictionary() ?? [:])
            case .deleteProduct:
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

extension Encodable {
    func toDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] {
                return dictionary
            }
        } catch {
            print("Failed to convert object to dictionary: \(error.localizedDescription)")
        }
        return nil
    }
}
