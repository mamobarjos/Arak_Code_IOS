//
//  UIViewController+ExSoicalMedia.swift
//  Joyin
//
//  Created by Abed Qassim on 26/05/2021.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import CryptoKit
import AuthenticationServices

protocol SocialDelegate {
    func signIn(socialMedia:SocialMedia?)
    func error(socialError:SocialError?)
}
var socialDelegate: SocialDelegate?

extension UIViewController: GIDSignInDelegate {
    
    func signInFacebook()  {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [], from: self) { result, error in
            if error != nil {
                socialDelegate?.error(socialError: .General)
                return
            }
            guard let result = result ,let accessToken = result.token?.tokenString , !result.isCancelled else {
                socialDelegate?.error(socialError: .General)
                return
            }
            self.fetchProfile(accessToken:accessToken,socialDelegate: socialDelegate)
        }
    }
    
    func fetchBalance(compliation: @escaping CompliationHandler) {
        let viewModel = ProfileViewModel()
        viewModel.getUserBalance (compliation: compliation)
    }
    func fetchProfile(accessToken:String , socialDelegate:SocialDelegate?) {
        let parameters = ["fields": "id, email, name, picture.type(large)"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: parameters, tokenString: accessToken, version: Settings.defaultGraphAPIVersion, httpMethod: HTTPMethod.get)
        
        graphRequest.start { connection, user, requestError in
            if requestError != nil {
                print("----------ERROR-----------\n")
                print(requestError)
                print("----------ERROR-----------\n")
                socialDelegate?.error(socialError: .General)
                return
            }
            guard let userData = user as? NSDictionary else {
                socialDelegate?.error(socialError: .General)
                return
            }
            let email = userData["email"] as? String ?? SocialError.EmailNotFound.rawValue
            let firstName = userData["name"] as? String ?? ""
            let lastName = userData["last_name"] as? String ?? ""
            let userID : String = userData["id"] as? String ?? ""
            
            let fullName = firstName + lastName
            var pictureUrl = ""
            if let picture = userData["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                pictureUrl = url
                print(pictureUrl)
            }
            let soicalMedia = SocialMedia(socialId: userID, email: email, phone: SocialError.PhoneNotFound.rawValue, displayName: fullName, imageUrl: pictureUrl, socialToken: accessToken, type: .Facebook)
            socialDelegate?.signIn(socialMedia: soicalMedia)
        }
    }
    
    func signInGoogle()  {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            socialDelegate?.error(socialError: .General)
            return
        }
        if error != nil {
            socialDelegate?.error(socialError: .General)
        } else {
            let id = user.userID ?? ""
            let idToken = user.authentication.idToken ?? ""
            let fullName = user.profile.name ?? ""
            _ = user.profile.givenName ?? ""
            _ = user.profile.familyName
            let email = user.profile.email ?? SocialError.EmailNotFound.rawValue
            let soicalMedia = SocialMedia(socialId: id, email: email, phone: SocialError.PhoneNotFound.rawValue, displayName: fullName, imageUrl: "", socialToken: idToken, type: .Google)
            socialDelegate?.signIn(socialMedia: soicalMedia)
        }
        
    }
}

