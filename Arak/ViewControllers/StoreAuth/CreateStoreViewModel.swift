//
//  CreateStoreViewModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 25/02/2022.
//

import Foundation

class CreateStoreViewModel {
   private(set) var categories: [StoreCategory] = []
    func getCategories() -> [StoreCategory] {
        return categories
    }

    func createStore(data: [String: Any] , compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.createStore(data: data), decodable: StoreResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            Helper.store = response?.data
            compliation(nil)
        }
    }

    func getStoresCategory(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getCategories, decodable: [StoreCategory].self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }

            self.categories = response?.data ?? []
            compliation(nil)
        }
    }
}
