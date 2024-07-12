//
//  CreateServiceViewModel.swift
//  Arak
//
//  Created by Osama Abu hdba on 08/03/2022.
//

import Foundation

class CreateServiceViewModel {

    func createService(data: [String: Any] , completion: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.createProduct(data: data), decodable: CreateProductModel.self) { (response, error) in
            if error != nil {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    func updateService(productId: Int , data: [String: Any] , completion: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.updateProduct(id: productId, data: data), decodable: CreateProductModel.self) { (response, error) in
            if error != nil {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
