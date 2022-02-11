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

    Network.shared.postRequestWithMultipart(Constants.ProductionServer.baseURL + "ad", decodable: Adverisment.self, parameters: data, imagesArray: nil, imageServerKey: [], mimeType: [], extType: []) { (response, error) in
      if (error != nil) {
        compliation(error ?? "")
        return
      }
        self.walletInsufficient = false
        if response?.data?.checkoutURL ?? "" == NetworkResponse.walletInsufficient.rawValue {
            self.walletInsufficient = true
        } else {
            self.url = response?.data?.checkoutURL ?? ""
        }
        
      compliation(nil)
    }
  }
}
