//
//  CreateAdViewModel.swift
//  Arak
//
//  Created by Osama Abu Hdba on 09/09/2024.
//

import Foundation
class CreateAdViewModel {

    // MARK: - Properties
    var customeAdData: CutomeAdsContentResponse?
    var package: Package?


  // MARK: - Protected Methods
    func getCutomeAdsContent(categoryId:Int ,compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.getCutomeAdsContent(ad_category_id: categoryId), decodable: CutomeAdsContentResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            var data = response?.data
            data?.customGenders?.insert(.init(id: nil, gender: "All".localiz(), price: "-1", createdAt: nil, updatedAt: nil, deletedAt: nil), at: 0)
//            data?.customCities?.insert(.init(id: nil, cityID: 0, price: "-1", createdAt: nil, updatedAt: nil, deletedAt: nil, city: .init(nameEn: "All".localiz(), id: 0, createdAt: nil, currencyID: nil, countryCode: nil, updatedAt: nil, currency: nil, nameAr: "All".localiz())), at: 0)
//            data?.customAges?.insert(.init(id: nil, age: "All".localiz(), price: "-1", createdAt: nil, updatedAt: nil, deletedAt: nil), at: 0)
            self.customeAdData = data
            compliation(nil)
        }
    }
    
    func createCustomePackage(data: [String: Any] ,compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.createCustomePackage(data: data), decodable: Package.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            
            var customPackage = response?.data
            if customPackage?.adCategoryID != 1 {
                customPackage?.noOfImgs = 1
            }
            
            self.package = customPackage
            compliation(nil)
        }
    }
}


