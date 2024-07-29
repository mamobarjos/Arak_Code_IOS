//
//  LoginViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import Foundation

class LoginViewModel {

    // MARK: - Properties
    
    
    // MARK: - Exposed Methods
    
    
    // MARK: - Protected Methods
  func login(phone: String , password:String , compliation: @escaping CompliationHandler) {
    Network.shared.request(request: APIRouter.login(phone: phone, password: password), decodable: User.self) { (response, error) in
      if error != nil {
        compliation(error)
        return
      }
//      if (response?.data?.isActive == 0) {
//        compliation("The user has been blocked, please contact the administration".localiz())
//        return
//      }
      Helper.userType = Helper.UserType.NORMAL.rawValue
      Helper.currentUser = response?.data
      Helper.userToken = response?.token ?? ""
      compliation(nil)
    }
  }


}
