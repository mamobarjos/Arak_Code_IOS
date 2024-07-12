//
//  FaceIDAuthenticatorServiceType.swift
//  Qawn
//
//  Created by Osama Abu hdba on 25/08/2022.
//

import Foundation
import LocalAuthentication
//import Resolver

enum BiometricType {
    case none
    case touchID
    case faceID
    case unknown
}

enum BiometricError: LocalizedError {
    case authenticationFailed
    case userCancel
    case userFallback
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case unknown

    var faceIdErrorDescription: String? {
        switch self {
        case .authenticationFailed: return "There was a problem verifying your identity."
        case .userCancel: return "You pressed cancel."
        case .userFallback: return "You pressed password."
        case .biometryNotAvailable: return "Face ID is not available."
        case .biometryNotEnrolled: return "Face ID is not set up."
        case .biometryLockout: return "Face ID is locked."
        case .unknown: return "Face ID ID may not be configured"
        }
    }
    
    var touchIdErrorDescription: String? {
        switch self {
        case .authenticationFailed: return "There was a problem verifying your identity."
        case .userCancel: return "You pressed cancel."
        case .userFallback: return "You pressed password."
        case .biometryNotAvailable: return "Touch ID is not available."
        case .biometryNotEnrolled: return "Touch ID is not set up."
        case .biometryLockout: return "Touch ID is locked."
        case .unknown: return "Touch ID ID may not be configured"
        }
    }
}

protocol FaceIDAuthenticatorServiceType: AnyObject {
    var typeOfBiometry: String? { get }
    var policy: LAPolicy {get set}
    func canEvaluate(completion: (Bool, BiometricType?, BiometricError?) -> Void)
    func evaluate(completion: @escaping (Bool, BiometricError?) -> Void)
    func biometricType(for type: LABiometryType) -> BiometricType
    func biometricError(from nsError: NSError) -> BiometricError
}

class DefaultFaceIDAuthenticatorService: FaceIDAuthenticatorServiceType {
    var policy: LAPolicy
    private var localizedReason: String?
    private var error: NSError?
    
    var typeOfBiometry: String?
    
    
//    @Injected var preferencesManager: PreferencesManager
    init(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: String = "Verify your Identity",
            localizedFallbackTitle: String = "Enter App Password",
         localizedCancelTitle: String = "General_Cancel".localiz()) {
           self.policy = policy
           self.localizedReason = localizedReason
       }
    
    func biometricType(for type: LABiometryType) -> BiometricType {
        switch type {
           case .none:
               return .none
           case .touchID:
               return .touchID
           case .faceID:
               return .faceID
           @unknown default:
               return .unknown
           }
    }
    
    func biometricError(from nsError: NSError) -> BiometricError {
        let error: BiometricError
        switch nsError {
        case LAError.authenticationFailed:
            error = .authenticationFailed
        case LAError.userCancel:
            error = .userCancel
        case LAError.userFallback:
            error = .userFallback
        case LAError.biometryNotAvailable:
            error = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            error = .biometryNotEnrolled
        case LAError.biometryLockout:
            error = .biometryLockout
        default:
            error = .unknown
        }
        
        return error
    }
    
    func canEvaluate(completion: (Bool, BiometricType?, BiometricError?) -> Void) {
       
        if Helper.isBiomatricAvailable == true {
             completion(true, nil, nil)
            return
        }
        let context = LAContext()
        // Asks Context if it can evaluate a Policy
            // Passes an Error pointer to get error code in case of failure
            guard context.canEvaluatePolicy(policy, error: &error) else {
                // Extracts the LABiometryType from Context
                // Maps it to our BiometryType
                let type = biometricType(for: context.biometryType)
                
                // Unwraps Error
                // If not available, sends false for Success & nil in BiometricError
                guard let error = error else {
                    Helper.isBiomatricAvailable = false
                    return completion(false, type, nil)
                }
                
                // Maps error to our BiometricError
                Helper.isBiomatricAvailable = false
                return completion(false, type, biometricError(from: error))
            }
            
            // Context can evaluate the Policy
        completion(true, biometricType(for: context.biometryType), error as? BiometricError)
    }
    
    func evaluate(completion: @escaping (Bool, BiometricError?) -> Void) {
        let context = LAContext()
        // Asks Context to evaluate a Policy with a LocalizedReason
        context.evaluatePolicy(policy, localizedReason: localizedReason ?? "") { [weak self] success, error in
               // Moves to the main thread because completion triggers UI changes
               DispatchQueue.main.async {
                   if success {
                       // Context successfully evaluated the Policy
                       completion(true, nil)
                   } else {
                       // Unwraps Error
                       // If not available, sends false for Success & nil for BiometricError
                       guard let error = error else { return completion(false, nil) }
                       
                       // Maps error to our BiometricError
                       completion(false, self?.biometricError(from: error as NSError))
                   }
               }
           }
    }
}

extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Capture these recoverable error thru Crashlytics
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                return .faceID
            }
        } else {
            return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
}
