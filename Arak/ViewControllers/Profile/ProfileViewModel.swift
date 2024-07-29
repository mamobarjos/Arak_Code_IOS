//
//  ProfileViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//

import Foundation

class ProfileViewModel {
    
    // MARK: - Properties
    
    
    // MARK: - Exposed Methods
    
    
    // MARK: - Protected Methods
    func logout(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.logout, decodable: User.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            Helper.resetLoggingData()
            compliation(nil)
        }
    }
    func deleteAccount(compliation: @escaping CompliationHandler) {
        
        Network.shared.request(request: APIRouter.deleteAccount, decodable: DeleteUerModel.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            Helper.resetLoggingData()
            compliation(nil)
        }
    }

    func editProfile(data: [String: String],compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.editUserInfo(data: data), decodable: User.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }
          
          Helper.currentUser = response?.data
          compliation(nil)
        }
      }


    func editProfileImage(imageType: Int ,data: [String: String],compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.editUserImg(data: data), decodable: User.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }
          Helper.currentUser = response?.data
          compliation(nil)
        }
      }
    
    func getUserBalance(compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.getUserBalance, decodable: Double.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }
        Helper.currentUser?.balance = "\(response?.data ?? 0)"
          compliation(nil)
        }
      }
    
}
