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
    var reviews: [ReviewResponse] = []
    var review: ReviewResponse?
    
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
        self.reviews = response?.data?.reviews ?? []
        compliation(nil)
      }
    }
    
    func favorite(id:Int ,compliation: @escaping CompliationHandler) {

        Network.shared.request(request: APIRouter.favorites(adId: id), decodable: Country.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }
          
          compliation(nil)
        }
      }
    
    func submitReview(review: String, rate: Int, ad_id: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.submitReview(content: review, rate: rate, ad_id: ad_id), decodable: ReviewResponse.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            self?.review = response?.data
            complition(nil)
        }
    }
    
    func deleteReview(reviewId: Int, complition: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.deleteReview(id: reviewId), decodable: Review.self) { [weak self] response, error in
            guard error == nil else {
                complition(error)
                return
            }
            complition(nil)
        }
    }
}
