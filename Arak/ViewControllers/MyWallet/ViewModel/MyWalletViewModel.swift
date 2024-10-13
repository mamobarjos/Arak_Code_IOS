//
//  MyWalletViewModel.swift
//  Arak
//
//  Created by Abed Qassim on 29/05/2021.
//

import Foundation
class MyWalletViewModel {
    
    // MARK: - Properties
    private var transactionList: [Transaction] = []
    private(set) var hasMore = true
    
    var itemCount: Int {
        return transactionList.count
    }
    
    func item(at index: Int) -> Transaction {
        return transactionList[index]
    }
    
    // MARK: - Protected Methods
    func getTransactions(page: Int , from:String, to: String,compliation: @escaping CompliationHandler) {
        Network.shared.request(request: APIRouter.transactions(page: page, from: from, to: to), decodable: TransactionContainer.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            if page == 1 {
                self.transactionList = []
            }
            self.transactionList.append(contentsOf: response?.data?.data ?? [])
            self.hasMore = false
            compliation(nil)
        }
    }
    
    func createCoupon(code: String ,compliation: @escaping CompliationHandler)   {
        Network.shared.request(request: APIRouter.createCoupon(code: code) ,decodable: CouponResponse.self) { (response, error) in
            if error != nil {
                compliation(error)
                return
            }
            
            compliation(nil)
        }
    }
    
}

struct CouponResponse: Codable {
    let balance: String?
}
