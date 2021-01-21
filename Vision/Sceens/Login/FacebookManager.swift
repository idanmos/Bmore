//
//  FacebookLoginManager.swift
//  B-more
//
//  Created by Idan Moshe on 18/01/2021.
//

import UIKit
import FBSDKLoginKit

enum FacebookPermissions: String, CaseIterable {
    case public_profile, email, user_friends
}

enum FacebookGraphPath: Hashable {
    case me(MeSubType)
    
    enum MeSubType {
        case feed, friends
        
        var title: String {
            switch self {
            case .feed: return "me/feed"
            case .friends: return "me/friends"
            }
        }
    }
    
    var title: String {
        return "me"
    }
}

enum FacebookGraphParameters: String {
    case fields, message
}

class FacebookManager {
    
    static let shared = FacebookManager()
    
    var presenter: UIViewController?
    
    lazy var loginManager = LoginManager()
    
    func isUserLoggedIn() -> Bool {
        if let token = AccessToken.current, !token.isExpired {
            return true
        }
        return false
    }
    
    func performLogIn() {
        if let token = AccessToken.current, !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            
            // The FBSDKAccessToken contains userID which you can use to identify the user.
            debugPrint(#file, #function, "token.userID: \(token.userID)")
            
            if token.hasGranted(permission: "email") {
                //
            } else {
                self.loginManager.logIn(permissions: ["public_profile", "email"], from: self.presenter) { (result: LoginManagerLoginResult?, error: Error?) in
                    //
                }
            }
        } else {
            self.loginManager.logIn(permissions: ["public_profile", "email"/*, "user_friends"*/], from: self.presenter) { (result: LoginManagerLoginResult?, error: Error?) in
                if let result: LoginManagerLoginResult = result {
                    if result.declinedPermissions.contains("email") {
                        //
                    }
                }
            }
        }
    }
    
    func perform(graphPath: FacebookGraphPath, parameters: [String: Any], handler: @escaping ([String: Any]?, Error?) -> Void) {
        GraphRequest(graphPath: "me/friends", parameters: parameters, httpMethod: .get).start { (connection: GraphRequestConnection?, result: Any?, error: Error?) in
            /* if ([error.userInfo[FBSDKGraphRequestErrorGraphErrorCode] isEqual:@200]) {
                NSLog(@"permission error");
            } */
                        
            if let error: Error = error {
                debugPrint(#file, #function, "error: \(error)")
                handler(nil, error)
                return
            }
            
            if let json = result as? [String: Any] {
                debugPrint(#file, #function, "result: \(json)")
                handler(json, nil)
                
                json.forEach { (pair: (key: String, value: Any)) in
                    if pair.key == "data", let friends = pair.value as? [Any] {
                        debugPrint("")
                    }
                }
            }
        }
        
        /* GraphRequest(graphPath: graphPath.title, parameters: parameters).start { (connection: GraphRequestConnection?, result: Any?, error: Error?) in
            if let error: Error = error {
                debugPrint(#file, #function, "error: \(error)")
                return
            }
            
            if let json = result {
                debugPrint(#file, #function, "result: \(json)")
            }
        } */
    }
    
}
