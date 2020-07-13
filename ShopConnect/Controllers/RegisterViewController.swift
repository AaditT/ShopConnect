//
//  RegisterViewController.swift
//  ShopConnect
//
//  Created by Aadit Trivedi on 7/7/20.
//  Copyright © 2020 Aadit Trivedi. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "RegisterToChoice", sender: self)
                }
            }
        }
    }
    
}
