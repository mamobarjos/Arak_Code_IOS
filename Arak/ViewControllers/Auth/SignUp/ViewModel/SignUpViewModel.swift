//
//  SignUpViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import Foundation

class SignUpViewModel {

  // MARK: - Properties
  private(set) var genderList: [String] = ["Male".localiz() , "Female".localiz(), "Other".localiz()]

  private(set) var countryList: [Country] = []
  private(set) var cityList: [Country] = []
  // MARK: - Protected Methods
    private(set) var phone:String = ""

  func register(data: [String: String] , compliation: @escaping CompliationHandler) {
      print(data)
    Network.shared.request(request: APIRouter.register(data: data), decodable: User.self) { (response, error) in
      if error != nil {
        compliation(error)
        return
      }
        Helper.userType = Helper.UserType.NORMAL.rawValue
      Helper.currentUser = response?.data
      Helper.userToken = response?.token ?? ""
      compliation(nil)
    }
  }
    func changePhone(data: [String: String] , compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.changePhone(data: data), decodable: String.self) { (response, error) in
        if error != nil || response?.data == nil {
          compliation(error)
          return
        }

        compliation(nil)
      }
    }
      
  func socialRegisterLogin(data: [String: String] , compliation: @escaping CompliationHandler) {
      print(data)
    Network.shared.request(request: APIRouter.socialRegisterLogin(data: data), decodable: User.self) { (response, error) in
      if error != nil || response?.data == nil {
        compliation(error)
        return
      }
        Helper.userType = Helper.UserType.NORMAL.rawValue
      Helper.currentUser = response?.data
      Helper.userToken = response?.token ?? ""
      compliation(nil)
    }
  }
  func getCountry( compliation: @escaping CompliationHandler) {
    Network.shared.request(request: APIRouter.countries, decodable: [Country].self) { (response, error) in
      if error != nil {
        compliation(error)
        return
      }
      self.countryList = response?.data ?? []
      compliation(nil)
    }
  }

  func getCity(by countryId: Int ,compliation: @escaping CompliationHandler) {
    Network.shared.request(request: APIRouter.cities(id: countryId), decodable: [Country].self) { (response, error) in
      if error != nil {
        compliation(error)
        return
      }
      self.cityList = response?.data ?? []
      compliation(nil)
    }
  }
    func otp(data: [String: String] , compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.otp(data: data), decodable: String.self) { (response, error) in
        if error != nil || response?.data == nil {
          compliation(error)
          return
        }
        self.phone = response?.data ?? ""
        compliation(nil)
      }
    }
}
