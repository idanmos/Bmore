//
//  AuthenticationServices.swift
//  Bmore
//
//  Created by Idan Moshe on 03/02/2021.
//

import Foundation
import AuthenticationServices

class AuthenticationServices {
        
    class func getCredentials(_ handler: @escaping (Bool, Error?) -> Void) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState: ASAuthorizationAppleIDProvider.CredentialState, error: Error?) in
            switch credentialState {
            case .revoked:
                debugPrint("AuthenticationServices", #function, "revoked")
            case .authorized:
                debugPrint("AuthenticationServices", #function, "authorized")
            case .notFound:
                debugPrint("AuthenticationServices", #function, "notFound")
            case .transferred:
                debugPrint("AuthenticationServices", #function, "transferred")
            @unknown default:
                break
            }
            
            if credentialState == .authorized {
                DispatchMainThreadSafe { handler(true, error) }
            } else {
                DispatchMainThreadSafe { handler(false, error) }
            }
        }
    }
    
    class func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.idanmoshe.Vision", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            debugPrint(#function, "Unable to save userIdentifier to keychain.")
        }
    }
    
}
