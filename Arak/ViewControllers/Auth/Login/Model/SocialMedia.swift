//
//  SocialMedia.swift
//  Joyin
//
//  Created by Abed Qassim on 26/05/2021.
//

import Foundation

enum SocialType: Int {
  case Facebook = 1
  case Google = 2
  case Apple = 3
}
enum SocialError: String {
  case UserNotFound = "USERNOTFOUND"
  case EmailNotFound = "EMAILNOTFOUND"
  case PhoneNotFound = "PHONENOTFOUND"
  case General
}

struct SocialMedia {
  var socialId: String
  var email: String
  var phone: String
  var displayName: String
  var imageUrl: String
  var socialToken: String
  var type: SocialType
}
