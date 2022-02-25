//
//  StoreViewModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 19/02/2022.
//

import Foundation

class StoreViewModel {
    private var storDetails: SingleStore?
    private var storeProduct: [StoreProduct] = []

    func getStoreDetails() -> SingleStore? {
        return self.storDetails
    }

    func getStoreProduct() -> [StoreProduct] {
        return self.storeProduct
    }

    func getStore(stroeId: Int, complition: @escaping CompliationHandler) {
        Network.shared.requestWithoutToken(request: StoresRout.getSingleStore(id: 1), decodable: [SingleStore].self) { response, error in
            guard error == nil else {
                complition(error)
                return
            }
            self.storDetails = response?.data?.first
            self.storeProduct = response?.data?.first?.storeProducts ?? []
            
            complition(nil)
        }
    }
    func submitReview(stroeId: Int, complition: @escaping CompliationHandler) {

    }
}
