//
//  ProductViewModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 20/02/2022.
//

import Foundation

class ProductViewModel{
    
    private var storeProduct: [Product] = []
    private var relatedProducts: [RelatedProducts] = []

    func getRelatedProducts() -> [RelatedProducts] {
        return self.relatedProducts
    }

    func getStoreProduct() -> [Product] {
        return self.storeProduct
    }

    func getProduct(productId: Int, complition: @escaping CompliationHandler) {
        Network.shared.requestWithoutToken(request: StoresRout.getStoreSingleProduct(productId:1), decodable: SingleProduct.self) { response, error in
            guard error == nil else {
                complition(error)
                return
            }
            self.storeProduct = response?.data?.storeProduct?.data ?? []
            self.relatedProducts = response?.data?.relatedProducts ?? []

            complition(nil)
        }
    }
    func submitReview(stroeId: Int, complition: @escaping CompliationHandler) {

    }
}
