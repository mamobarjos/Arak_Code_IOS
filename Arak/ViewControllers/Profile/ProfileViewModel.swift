//
//  ProfileViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 23/02/2021.
//

import Foundation

class ProfileViewModel {
    
    // MARK: - Properties
    
    private(set) var genderList: [String] = ["Male".localiz() , "Female".localiz()]

    private(set) var countryList: [Country] = []
    private(set) var cityList: [Country] = []
    
    // MARK: - Exposed Methods
    
    
    // MARK: - Protected Methods
    func logout(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.logout, decodable: User.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            
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

    func editProfile(data: [String: Any],compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.editUserInfo(data: data, userid: Helper.currentUser?.id ?? 1), decodable: User.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }
          
          Helper.currentUser = response?.data
          compliation(nil)
        }
      }


    func editProfileImage(userId: Int,imageType: Int ,data: [String: String],compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.editUserImg(data: data, userid: userId), decodable: User.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }
          Helper.currentUser = response?.data
          compliation(nil)
        }
      }
    
    func getUserBalance(compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.getUserBalance, decodable: BalanceContainer.self) { (response, error) in
          if error != nil {
            compliation(error)
            return
          }
          
          var user = Helper.currentUser
          user?.balance = response?.data?.balance ?? "0"
          Helper.currentUser = user
          compliation(nil)
        }
      }
    
    func getCountry( compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.countries, decodable: CountryContainer.self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
          self.countryList = response?.data?.countries ?? []
        compliation(nil)
      }
    }

    func getCity(by countryId: Int ,compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.cities(id: countryId), decodable: CountryContainer.self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
          self.cityList = response?.data?.cities ?? []
        compliation(nil)
      }
    }
    
}

struct BalanceContainer: Codable {
    let balance: String?
}
