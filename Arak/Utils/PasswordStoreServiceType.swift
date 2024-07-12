//
//  PasswordStoreServiceType.swift
//  Qawn
//
//  Created by Osama Abu hdba on 25/08/2022.
//

import Foundation
import KeychainSwift

struct PasswordCredential: Codable {
    let phoneNumber: String
    let password: String
}

protocol PasswordStoreServiceType {
    func retriveCredentials() -> PasswordCredential?
    func save(credentials: PasswordCredential)
}

class KeychainPasswordStoreService: NSObject, PasswordStoreServiceType {

    let key = "come.arak.Credential"
    let service = KeychainSwift()
    
    var credentials: PasswordCredential?

    override init(){
        super.init()

        guard let data = self.service.getData(key) else { return }
        self.credentials = try? JSONDecoder().decode(PasswordCredential.self, from: data)
    }

    func retriveCredentials() -> PasswordCredential? {
        self.credentials
    }

    func save(credentials: PasswordCredential) {
        self.credentials = credentials

        guard let data = try? JSONEncoder().encode(credentials) else {
            return
        }

        service.set(data, forKey: key)
    }
}
