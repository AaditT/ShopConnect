//
//  LoginViewController.swift
//  ShopConnect
//
//  Created by Aadit Trivedi on 7/8/20.
//  Copyright © 2020 Aadit Trivedi. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "LoginToChoice", sender: self)
                }
            }
        }
    }
    
}
