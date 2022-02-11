//
//  DetailViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 27/02/2021.
//

import Foundation

class DetailViewModel {

    // MARK: - Properties
    private(set) var ad: Adverisment?

    var adImages: [String] {
      return ad?.adImages?.map { $0.path ?? "" } ?? []
    }


  // MARK: - Protected Methods
  func adsDetail(id:Int ,compliation: @escaping CompliationHandler) {

    Network.shared.request(request: APIRouter.adsDetail(id: id), decodable: Adverisment.self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
        self.ad = response?.data
        compliation(nil)
      }
    }
    
    func favorite(id:Int,isFavorate: Bool ,compliation: @escaping CompliationHandler) {

        Network.shared.request(request: APIRouter.favorites(data: ["ad_id":"\(id)"],isFavorate: isFavorate), decodable: String.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }
          
          compliation(nil)
        }
      }
}
