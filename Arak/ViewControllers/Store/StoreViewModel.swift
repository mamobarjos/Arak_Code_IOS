//
//  StoreViewModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 19/02/2022.
//

import Foundation

class StoreViewModel {
    private(set) var storDetails: SingleStore?
    private(set) var storeProduct: [StoreProduct] = []
    private(set) var reviews: [ReviewResponse] = []
    private(set) var review: ReviewResponse?
    private(set) var products: [StoreProduct] = []
    var canLoadMore = false
    func getStoreDetails() -> SingleStore? {
        return self.storDetails
    }

    func getStoreProduct() -> [StoreProduct] {
        return self.storeProduct
    }

    func getReviews() -> [ReviewResponse] {
        return reviews
    }

    func getReview() -> ReviewResponse? {
        return review
    }

    func getProducts() -> [StoreProduct] {
        return products
    }


    func getUserStore(complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getUserStore, decodable: SingleStore.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            self?.storDetails = response?.data
            self?.storeProduct = response?.data?.storeProducts ?? []
            self?.reviews = response?.data?.storeReviews ?? []
            complition(nil)
        }
    }

    func getStore(stroeId: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getSingleStore(id: stroeId), decodable: SingleStore.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            self?.storDetails = response?.data
            self?.storeProduct = response?.data?.storeProducts ?? []
            self?.reviews = response?.data?.storeReviews ?? []
            complition(nil)
        }
    }

    func getUserProducts(page: Int = 1, complition: @escaping CompliationHandler) {
            if page == 1 {
                self.products = []
            }

            Network.shared.request(request: StoresRout.getUserProducts(page: page), decodable: PagingModel<[StoreProduct]>.self) { [weak self] response, error in
                guard error == nil else {
                    complition(error)
                    return
                }

                self?.canLoadMore = !(response?.data?.data?.isEmpty ?? false)
                self?.products.append(contentsOf: response?.data?.data ?? [])
                complition(nil)
            }
        }

    func submitReview(review: String, rate: Int, stroeId: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.submitReview(content: review, rate: rate, store_id: stroeId), decodable: ReviewResponse.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            self?.review = response?.data
            complition(nil)
        }
    }

    func getStoreProducts(storeId: Int, page: Int = 1, complition: @escaping CompliationHandler) {
        if page == 1 {
            self.products = []
        }

        Network.shared.request(request: StoresRout.getStoreProducts(storeId: storeId, page: page), decodable: PagingModel<[StoreProduct]>.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }

            self?.canLoadMore = !(response?.data?.data?.isEmpty ?? false)
            self?.products.append(contentsOf: response?.data?.data ?? [])
            complition(nil)
        }
    }

    func getStoreProductsByCategory(categoryId: Int, page: Int = 1, complition: @escaping CompliationHandler) {
        if page == 1 {
            self.products = []
        }

        Network.shared.request(request: StoresRout.getProductsByCategory(categoryId: categoryId, page: page), decodable: PagingModel<[StoreProduct]>.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }

            self?.canLoadMore = !(response?.data?.data?.isEmpty ?? false)
            self?.products.append(contentsOf: response?.data?.data ?? [])
            complition(nil)
        }
    }



    func deleteStoreReview(reviewId: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.deleteStoreReview(id: reviewId), decodable: Review.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            complition(nil)
        }
    }

    struct Review: Codable {
        let id: Int
        let content: String
        let rate: Int
        let storeid: Int
        let userid: Int
        let createdAt: String
        let updatedAt: String

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case content = "content"
            case rate = "rate"
            case storeid = "store_id"
            case userid = "user_id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}
