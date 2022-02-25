//
//  StoresViewModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 18/02/2022.
//

import Foundation

class StoresViewModel {
    private var categories: [StoreCategory] = []
    private var stores: [Store] = []


    func getCategories() -> [StoreCategory] {
        return self.categories
    }

    func getStores() -> [Store] {
        return self.stores
    }

    /// get stores and categories
    func getStores(page: Int = 1,compliation: @escaping CompliationHandler) {
        if page == 1 {
            stores = []
        }
        Network.shared.requestWithoutToken(request: StoresRout.getStores(page: page), decodable: StoresRespose.self) { [weak self] (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self?.categories.append(contentsOf: response?.data?.storeCategories ?? [])
            self?.stores.append(contentsOf: response?.data?.storesData.data ?? [])
            compliation(nil)
        }
    }

    /// fetch stores by category if category id == ("-1") response will back with all stores
    func getStoresByCategory(page: Int = 1, by category: Int, compliation: @escaping CompliationHandler) {
        if page == 1 {
            self.stores = []
        }
        Network.shared.request(request: StoresRout.filterStoresByCategory(category: category), decodable: StoresData.self) { [weak self] response, error in
            guard error == nil else {
                compliation(error)
                return
            }
            self?.stores = []
            self?.stores = response?.data?.data ?? []
            compliation(nil)
        }
    }
}
