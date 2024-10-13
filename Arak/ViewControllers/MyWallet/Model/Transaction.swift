//
//  Transaction.swift
//  Arak
//
//  Created by Abed Qassim on 29/05/2021.
//

import Foundation

struct TransactionContainer: Codable {
    let limit: Int?
    let data: [Transaction]?
    let total, page: Int?
}

struct Transaction: Codable {
  enum TransactionType:Int {
    case income = 0
    case outcome = 1
  }
  var id: Int?
  var type: String?
  var amount: String?
  var desc: String?
  var userID: Int?
  var createdAt, updatedAt: String?
  var transactionType: TransactionType {
    return type ?? ""  == "INCOME" ? .income : .outcome
  }
  var valueAmountTitle: String {
    return "\(amount ?? "0") \((Helper.currencyCode ?? "JOD"))"
  }
  
  enum CodingKeys: String, CodingKey {
    case id, type, amount
    case desc = "description"
    case userID = "user_id"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}
