//
//  GenericModel.swift
//  Arak
//
//  Created by Abed Qassim on 22/02/2021.
//

import Foundation
// MARK: - Upcoming
struct GenericModel<T:Codable>: Codable {
  
  var statusCode: Int?
  var message : String?
  var generalDescription: ErrorDescription?
  var data: T?
  var token: String?
  
  enum CodingKeys: String, CodingKey {
    case statusCode, message
    case generalDescription = "description"
    case data,token
  }
}
enum ErrorDescription: Codable {
    case string(String)

    case listOfString([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode([String].self) {
            self = .listOfString(x)
            return
        }
        throw DecodingError.typeMismatch(ErrorDescription.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MyValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .listOfString(let x):
            try container.encode(x)
        }
    }
}
