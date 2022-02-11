//
//  ServiceViewModel.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 06/07/2021.
//

import Foundation

class ServiceViewModel {
    private var serviceList: [Service] = []
    
    var hasMore = true
    var itemCount: Int {
        return serviceList.count
    }
    
    func item(at index: Int) -> Service  {
        return serviceList[index]
    }

    func getServices(page: Int,compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.services(page: page), decodable: PagingModel<[Service]>.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            if page == 1 {
                self.serviceList = []
            }
            self.hasMore = (response?.data?.data ?? []).count != 0
            self.serviceList.append(contentsOf: response?.data?.data ?? [])
            compliation(nil)
        }
    }
    
    func requestService(name:String , email: String , phoneNo: String,serviceId: String,compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.RequestArakService(name: name, email: email, phoneNo: phoneNo, serviceId: serviceId), decodable: Service.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            compliation(nil)
        }
    }
}
