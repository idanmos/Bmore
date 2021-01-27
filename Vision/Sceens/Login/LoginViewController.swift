//
//  LoginViewController.swift
//  B-more
//
//  Created by Idan Moshe on 18/01/2021.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"/*, "user_friends"*/]
        // loginButton.readPermissions = @[@”email”];
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        if FacebookManager.shared.isUserLoggedIn() {
            FacebookManager.shared.perform(graphPath: .me(.feed), parameters: ["fields": ""]) { (result: [String : Any]?, error: Error?) in
                //
            }
        } else {
            FacebookManager.shared.performLogIn()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
