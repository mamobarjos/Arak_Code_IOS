//
//  ProductViewModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 20/02/2022.
//

import Foundation

class ProductViewModel{
    
    private var storeProduct: StoreProduct?
    private var relatedProducts: [RelatedProducts] = []
    private var review: ReviewResponse?

    func getRelatedProducts() -> [RelatedProducts] {
        return self.relatedProducts
    }

    func getStoreProduct() -> StoreProduct? {
        return self.storeProduct
    }

    func getReview() -> ReviewResponse? {
        return review
    }

    func getProduct(productId: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getStoreSingleProduct(productId:productId), decodable: StoreProduct.self) { response, error in
            guard error == nil else {
                complition(error)
                return
            }

            self.storeProduct = response?.data
//            self.relatedProducts = response?.data?.relatedProducts ?? []

            complition(nil)
        }
    }
    
    func getRelatedProduct(productId: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getStoreProducts(storeId: productId, page: 1), decodable: [RelatedProducts].self) { response, error in
            guard error == nil else {
                complition(error)
                return
            }

            self.relatedProducts = response?.data ?? []

            complition(nil)
        }
    }
    
    func submitReview(review: String, rate: Int, storeProductId: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.submiteProductReview(content: review, rate: rate, store_product_id: storeProductId), decodable: ReviewResponse.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            self?.review = response?.data
            complition(nil)
        }
    }

    func deleteReview(reviewId: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.deleteProductReview(id: reviewId), decodable: Review.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            complition(nil)
        }
    }
}

struct Review: Codable {
    let id: Int?
    let content: String?
    let rate: Int?
    let productId: Int?
    let userid: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case content = "content"
        case rate = "rate"
        case productId = "store_product_id"
        case userid = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
