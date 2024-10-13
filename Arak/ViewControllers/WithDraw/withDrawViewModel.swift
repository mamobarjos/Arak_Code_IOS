//
//  withDrawViewModel.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 08/07/2021.
//

import Foundation
class withDrawViewModel {
    private(set) var walletTypeList: [DigitalWallet] = []

    
    func withDraw(data: [String: String] , compliation: @escaping CompliationHandler) {
        // TODO: ---- change model type 
      Network.shared.request(request: APIRouter.withDraw(data: data), decodable: WithDrawResponse.self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
        compliation(nil)
      }
    }
    
    func digitalWallets(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.digitalWallets, decodable: DigitalWalletsContainer.self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
            self.walletTypeList = response?.data?.digitalWallets ?? []
        compliation(nil)
      }
    }
}

struct WithDrawResponse: Codable {
    let amount, status: String?
    let id: Int?
    let createdAt, walletType: String?
//    let deletedAt: JSONNull?
    let userID: Int?
    let updatedAt, phoneNo, name: String?

    enum CodingKeys: String, CodingKey {
        case amount, status, id
        case createdAt = "created_at"
        case walletType = "wallet_type"
//        case deletedAt = "deleted_at"
        case userID = "user_id"
        case updatedAt = "updated_at"
        case phoneNo = "phone_no"
        case name
    }
}
