//
//  FeedbackViewModel.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 06/07/2021.
//

import Foundation

class FeedbackViewModel {
    func arakFeedback(data: [String: String],compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.arakFeedback(data: data), decodable: String.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }

          compliation(nil)
        }
      }
}
