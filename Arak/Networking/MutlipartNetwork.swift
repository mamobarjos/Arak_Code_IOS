//
//  MutlipartNetwork.swift
//  Arak
//
//  Created by Abed Qassim on 21/02/2021.
//

import Foundation
import Alamofire


typealias CompliationHandler = (String?) -> ()

class Network {

  static let shared = Network()

  private func headers() -> HTTPHeaders {
      var headers: HTTPHeaders = [
          "Content-Type": " application/json-patch+json",
          "accept": "application/json",
          "Accept-Language": Helper.appLanguage ?? "en",
          HTTPHeaderField.api_key.rawValue : Helper.apiKey
      ]
      //Add the user token to header if any
      guard let userToken: String = Helper.userToken  else {
          return headers
      }
      headers["Authorization"] = "Bearer" + " "  + userToken
      return headers
  }


  func request<T: Codable>(request:APIConfiguration , decodable: T.Type,completion: @escaping (GenericModel<T>?, _ error: String?) -> ())  {
    if !InternetConnectionManager.isConnectedToNetwork() {
      //NoInternetScreen()
      completion(nil,NetworkResponse.internet.rawValue.localiz())
      return
    }
      
    AF.request(request).responseJSON { (response) in
      switch response.result {
        case .failure(let err):
          print(err.localizedDescription)
          completion(nil,NetworkResponse.failed.rawValue)
          break

        case .success :

          guard let responseDictionary  = response.value as? NSDictionary , let statusCode = response.response?.statusCode else {
              completion(nil,NetworkResponse.unableToDecode.rawValue)
              return
            }
          if statusCode == 401 && !request.path.contains("auth/login") {
                self.Logout()
              
                completion(nil,NetworkResponse.authenticationError.rawValue)
              } else {

                guard let decode = try? JSONSerialization.data(withJSONObject: responseDictionary, options: .prettyPrinted)  else {
                    completion(nil,NetworkResponse.unableToDecode.rawValue)
                    return
                }
                  print("////// //// ///// //// ")
                  print("URL =====>  \(request.path)")
                  print(String(data: decode, encoding: .utf8) ?? "can't decode")
                  print("////// //// ///// //// ")

                let decoder = JSONDecoder.init()
               
                

                  do {
                      let decodeObj = try decoder.decode(GenericModel<T>.self, from: decode)
                      // Successfully decoded
                     
                  } catch let error {
                      // Decoding error occurred
                      print("Decoding error:", error.localizedDescription)
                      if let decodingError = error as? DecodingError {
                          switch decodingError {
                          case .dataCorrupted(let context):
                              print("Data corrupted: \(context)")
                          case .keyNotFound(let key, let context):
                              print("Key '\(key)' not found:", context.debugDescription)
                              print("CodingPath:", context.codingPath)
                          case .typeMismatch(let type, let context):
                              print("Type mismatch: '\(type)'", context.debugDescription)
                              print("CodingPath:", context.codingPath)
                          case .valueNotFound(let type, let context):
                              print("Value '\(type)' not found:", context.debugDescription)
                              print("CodingPath:", context.codingPath)
                          @unknown default:
                              print("Unknown decoding error")
                          }
                      }
                  }
                  
                  
                  
                  guard let decodeObj = try? decoder.decode(GenericModel<T>.self, from: decode) else {
                      completion(nil,NetworkResponse.unableToDecode.rawValue)
                      return
                  }
                  
                  if decodeObj.statusCode == 400 {
                      completion(nil, decodeObj.message ?? "Error")
                      return
                  }
                  
                  if decodeObj.statusCode == 401 {
                      completion(nil, decodeObj.message ?? "Error")
                      return
                  }
                  
                  if decodeObj.statusCode == 404 {
                      completion(nil, decodeObj.message ?? "Error")
                      return
                  }
                  
                  if decodeObj.statusCode != 200  &&  decodeObj.statusCode != 201 {
                      switch decodeObj.generalDescription {
                      case .string(let error):
                          completion(nil,error)
                      case .listOfString(let errorList):
                          completion(nil,errorList.joined(separator: "\n"))
                      default:
                          completion(nil,"Error")
                      }
                      
                      return
                  }
                  completion(decodeObj, nil)
              }
          break
      }
    }.cURLDescription { description in
        print("cURLDescription: ", description)
    }
      
  }
   func requestWithoutToken<T: Codable>(request:APIConfiguration , decodable: T.Type,completion: @escaping (GenericModelWithoutToken<T>?, _ error: String?) -> ())  {
      if !InternetConnectionManager.isConnectedToNetwork() {
        //NoInternetScreen()
        completion(nil,NetworkResponse.internet.rawValue.localiz())
        return
      }
       
      AF.request(request).responseJSON { (response) in
        switch response.result {
          case .failure(let err):
            print(err.localizedDescription)
            completion(nil,NetworkResponse.failed.rawValue)
            break

          case .success :

            guard let responseDictionary  = response.value as? NSDictionary , let statusCode = response.response?.statusCode else {
                completion(nil,NetworkResponse.unableToDecode.rawValue)
                return
              }
                if statusCode == 401 {
                  self.Logout()

                  completion(nil,NetworkResponse.authenticationError.rawValue)
                } else {

                  guard let decode = try? JSONSerialization.data(withJSONObject: responseDictionary, options: .prettyPrinted)  else {
                      completion(nil,NetworkResponse.unableToDecode.rawValue)
                      return
                  }
                    print("=== ==== === ===")
                    print(String(data: decode, encoding: .utf8) ?? "can't decode")
                    print("=== ==== === ===")

                  let decoder = JSONDecoder.init()

                  guard let decodeObj = try? decoder.decode(GenericModelWithoutToken<T>.self, from: decode) else {
                      let errorResult  = try? decoder.decode(GenericModelWithoutToken<String>.self, from: decode)
                      print("can't decode the result \(errorResult)")
                    completion(nil,NetworkResponse.unableToDecode.rawValue)
                    return
                  }

                  if decodeObj.statusCode != 200  &&  decodeObj.statusCode != 201 {
                    switch decodeObj.generalDescription {
                      case .string(let error):
                        completion(nil,error)
                      case .listOfString(let errorList):
                        completion(nil,errorList.joined(separator: "\n"))
                      default:
                        completion(nil,"Error")
                    }

                    return
                  }
                  completion(decodeObj, nil)
                }
            break
        }
      }.cURLDescription { description in
          print("cURLDescription: ", description)
      }
    }
    
  func Logout() {
    let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
    let vc = storyboard.instantiateViewController(identifier: LoginViewController.className) as! LoginViewController
    if let viewController = UIApplication.shared.topViewController as? UINavigationController {
      Helper.resetLoggingData()
      viewController.push(vc)
    }
  }
    

    func postRequestWithMultipart<T: Codable>(_ url: String, decodable: T.Type, parameters: [String: Any], imagesArray: [Data]? = [], imageServerKey: [String]? = [], mimeType: [String] = ["image/jpeg"], extType: [String] = ["jpeg"], completionHandler: @escaping (_ Result: GenericModel<T>?, String??) -> Void) {
        if url.isEmpty {
            completionHandler(nil, NetworkResponse.generalError.rawValue)
            return
        }
        if !InternetConnectionManager.isConnectedToNetwork() {
            //NoInternetScreen()
            completionHandler(nil, NetworkResponse.internet.rawValue.localiz())
            return
        }
        
        AF.upload(
            multipartFormData: { multipartFormData in
                if let imageDataArray = imagesArray, !imageDataArray.isEmpty {
                    for index in 0..<imageDataArray.count {
                        multipartFormData.append(imageDataArray[index], withName: imageServerKey?[index] ?? "", fileName: "\(Date().timeIntervalSince1970).\(extType[index])", mimeType: mimeType[index])
                    }
                }
                
                for (key, value) in parameters {
                    if let stringValue = value as? String {
                        multipartFormData.append(Data(stringValue.utf8), withName: key)
                    } else if let intValue = value as? Int {
                        multipartFormData.append(Data("\(intValue)".utf8), withName: key)
                    } else if let boolValue = value as? Bool {
                        multipartFormData.append(Data("\(boolValue)".utf8), withName: key)
                    }
                }
            },
            to: url,
            method: .post,
            headers: headers()
        ).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let responseDictionary = value as? [String: Any] else {
                    completionHandler(nil, NetworkResponse.generalError.rawValue.localiz())
                    return
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: responseDictionary, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let objectInfo = try decoder.decode(GenericModel<T>.self, from: jsonData)
                    completionHandler(objectInfo, nil)
                } catch {
                    completionHandler(nil, NetworkResponse.generalError.rawValue.localiz())
                }
            case .failure:
                if response.response?.statusCode == 401 {
                    self.Logout()
                    completionHandler(nil, NetworkResponse.authenticationError.rawValue.localiz())
                } else {
                    completionHandler(nil, NetworkResponse.generalError.rawValue.localiz())
                }
            }
        }.cURLDescription { curl in
            debugPrint(curl)
        }
    }
}
