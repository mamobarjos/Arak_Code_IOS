//
//  Transaction.swift
//  Arak
//
//  Created by Abed Qassim on 29/05/2021.
//

import Foundation
struct Transaction: Codable {
  enum TransactionType:Int {
    case income = 0
    case outcome = 1
  }
  var id, type: Int?
  var amount: Double?
  var desc: String?
  var userID: Int?
  var createdAt, updatedAt: String?
  var transactionType: TransactionType {
    return type ?? 0  == 0 ? .income : .outcome
  }
  var valueAmountTitle: String {
    return "\(amount ?? 0) \("JOD".localiz())"
  }
  
  enum CodingKeys: String, CodingKey {
    case id, type, amount, desc
    case userID = "user_id"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}
