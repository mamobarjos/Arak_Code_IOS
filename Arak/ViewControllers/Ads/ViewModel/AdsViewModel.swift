//
//  AdsViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//

import Foundation

class AdsViewModel {

    // MARK: - Properties
    private var adsTypeList: [AdsCategory] = []
    var hasMore = true

    var adsTypeCount: Int {
      return adsTypeList.count
    }


    
    // MARK: - Exposed Methods
    public func itemType(at index: Int) -> AdsCategory {
      return adsTypeList[index]
    }

    func clearList()  {
      adsTypeList = []
    }
    
    
    // MARK: - Protected Methods
  func adsType(compliation: @escaping CompliationHandler) {
    Network.shared.request(request: APIRouter.adsType, decodable: [AdsCategory].self) { (response, error) in
      if error != nil {
        compliation(error)
        return
      }
      self.adsTypeList = response?.data ?? []
      compliation(nil)
    }
  }
    
    
    
}
