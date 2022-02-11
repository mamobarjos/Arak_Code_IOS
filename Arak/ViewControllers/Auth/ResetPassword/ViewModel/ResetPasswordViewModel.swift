//
//  ResetPasswordViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import Foundation

class ResetPasswordViewModel {

    // MARK: - Properties
    
    
    // MARK: - Exposed Methods
    
    
    // MARK: - Protected Methods
    func editPassword(data: [String: String],compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.editPassword(data: data), decodable: User.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }

          compliation(nil)
        }
      }

    func resetPassword(data: [String: Any],compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.resetPassword(data: data), decodable: String.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }

          compliation(nil)
        }
      }

    
    

}
