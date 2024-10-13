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
    
 public var categories: [StoreCategory] = []
  // MARK: - Protected Methods
    private(set) var phone:String = ""

    
  func register(data: [String: Any] , compliation: @escaping CompliationHandler) {
      print(data)
    Network.shared.request(request: APIRouter.register(data: data), decodable: User.self) { (response, error) in
      if error != nil {
        compliation(error)
        return
      }
        Helper.userType = Helper.UserType.NORMAL.rawValue
        Helper.currentUser = response?.data
        Helper.userToken = response?.data?.accessToken ?? ""
      compliation(nil)
    }
  }
    
    func login(phone: String , password:String , compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.login(phone: phone, password: password), decodable: UserModel.self) { (response, error) in
        if error != nil {
          compliation(error)
          return
        }
  //      if (response?.data?.isActive == 0) {
  //        compliation("The user has been blocked, please contact the administration".localiz())
  //        return
  //      }
        Helper.userType = Helper.UserType.NORMAL.rawValue
          Helper.currentUser = response?.data?.user
          Helper.userToken = response?.data?.accessToken ?? ""
        compliation(nil)
      }
    }

    func changePhone(data: [String: String] , compliation: @escaping CompliationHandler) {
      Network.shared.request(request: APIRouter.changePhone(data: data), decodable: User.self) { (response, error) in
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
    
    func getIntrest(compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.getCategories, decodable: StoreCategoryContainer.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            self.categories = response?.data?.storeCategories ?? []
            compliation(nil)
        }
    }
    
    func updateUserIntrest(intrests: [Int],compliation: @escaping CompliationHandler) {
        Network.shared.request(request: StoresRout.updateUserIntrest(data: ["category_ids": intrests]), decodable: User.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }

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
