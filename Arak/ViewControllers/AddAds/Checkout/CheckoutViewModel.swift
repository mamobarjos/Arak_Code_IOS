//
//  CheckoutViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 28/02/2021.
//

import Foundation

class CheckoutViewModel {
  private(set) var url: String = ""
    private(set) var walletInsufficient: Bool = false

    func addAds(data:[String: Any]  ,compliation: @escaping CompliationHandler) {
        
        Network.shared.request(request: APIRouter.addADs(data: data), decodable: Adverisment.self, completion: { (response, error) in
            if (error != nil) {
                compliation(error ?? "")
                return
            }
            self.walletInsufficient = false
            if response?.data?.checkOutURL ?? "" == NetworkResponse.walletInsufficient.rawValue {
                self.walletInsufficient = true
            } else {
                self.url = response?.data?.checkOutURL ?? ""
            }
            
            compliation(nil)
        })
    }
    
    func addStoreAds(data:[String: Any]  ,compliation: @escaping CompliationHandler) {
        
        Network.shared.request(request: APIRouter.addStoreAds(data: data), decodable: CheckoutResponse.self, completion: { (response, error) in
            if (error != nil) {
                compliation(error ?? "")
                return
            }
            self.walletInsufficient = false
            if response?.data?.checkOutURL ?? "" == NetworkResponse.walletInsufficient.rawValue {
                self.walletInsufficient = true
            } else {
                self.url = response?.data?.checkOutURL ?? ""
            }
            
            compliation(nil)
        })
    }
    
    func getUserStore(complition: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getUserStore, decodable: Store.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            Helper.store = response?.data
            complition(nil)
        }
    }
    
    func createCliQTransaction(amount: String, imageURL: String ,compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.cliQPayment(data: ["amount":amount, "img_url":imageURL]), decodable: CliqResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            
            compliation(nil)
        }
    }
}

struct CheckoutResponse: Codable {
    let checkOutURL: String?
    
    enum CodingKeys: String, CodingKey {
        case checkOutURL = "checkout_url"
    }
}

struct CliqResponse: Codable {
    let amount: String?
    let id: Int?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let imgUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case amount
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case imgUrl = "img_url"
    }
}
