//
//  AdsViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//

import Foundation

class AdsViewModel {

    // MARK: - Properties
    private var adsTypeList: [AdCategory] = []
    var packages: [Package] = []
    var hasMore = true

    var adsTypeCount: Int {
      return adsTypeList.count
    }


    
    // MARK: - Exposed Methods
    public func itemType(at index: Int) -> AdCategory {
      return adsTypeList[index]
    }

    func clearList()  {
      adsTypeList = []
    }
    
    
    // MARK: - Protected Methods
  func adsType(compliation: @escaping CompliationHandler) {
    Network.shared.request(request: APIRouter.adsType, decodable: AdCategoryContainer.self) { (response, error) in
      if error != nil {
        compliation(error)
        return
      }
        self.adsTypeList = response?.data?.adCategories ?? []
      compliation(nil)
    }
  }
    
    
    func getPackages(adCategoryId: Int ,compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.getPackagesByAdCategory(categoryId: adCategoryId), decodable: PackageContainer.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.packages = response?.data?.adPackages ?? []
            compliation(nil)
        }
    }
}
