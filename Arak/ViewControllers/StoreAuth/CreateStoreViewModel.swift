//
//  CreateStoreViewModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 25/02/2022.
//

import Foundation

class CreateStoreViewModel {
    
    private(set) var categories: [StoreCategory] = []
    private(set) var countryList: [Country] = []
    private(set) var cityList: [Country] = []
    func getCategories() -> [StoreCategory] {
        return categories
    }
    
    func createStore(data: [String: Any] , compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.createStore(data: data), decodable: StoreResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            Helper.UserStoreId = response?.data?.id
            compliation(nil)
        }
    }
    
    func updateStore(id: Int, data: [String:Any], compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.updateStore(id: id, data: data), decodable: StoreResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            //            Helper.store = response?.data
            compliation(nil)
        }
    }
    
    func getStoresCategory(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getCategories, decodable: StoreCategoryContainer.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.categories = response?.data?.storeCategories ?? []
            compliation(nil)
        }
    }
    
    func getCountry( compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.countries, decodable: CountryContainer.self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
          self.countryList = response?.data?.countries ?? []
        compliation(nil)
      }
    }

    func getCity(by countryId: Int ,compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.cities(id: countryId), decodable: CountryContainer.self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
          self.cityList = response?.data?.cities ?? []
        compliation(nil)
      }
    }
    
}
