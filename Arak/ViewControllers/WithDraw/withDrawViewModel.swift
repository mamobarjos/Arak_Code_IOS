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
      Network.shared.request(request: APIRouter.withDraw(data: data), decodable: String.self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
        compliation(nil)
      }
    }
    
    func digitalWallets(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.digitalWallets, decodable: [DigitalWallet].self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
        self.walletTypeList = response?.data ?? []
        compliation(nil)
      }
    }
}
