//
//  CreateServiceViewModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 08/03/2022.
//

import Foundation

class CreateServiceViewModel {

    func createService(data: [String: Any] , compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.createProduct(data: data), decodable: CreateProductModel.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            compliation(nil)
        }
    }
}
