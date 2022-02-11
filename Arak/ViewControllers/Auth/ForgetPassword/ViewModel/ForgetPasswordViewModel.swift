//
//  ForgetPasswordViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import Foundation

class ForgetPasswordViewModel {

    // MARK: - Properties
    
    
    // MARK: - Exposed Methods
    
    
    // MARK: - Protected Methods
    
    func forget(email: String , compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.forget(email: email), decodable: String.self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
        compliation(nil)
      }
    }
    

}
