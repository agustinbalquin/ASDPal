//
//  LogInViewController.swift
//  ASDPal
//
//  Created by Agustin Balquin on 2/23/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
        
        registerButton.layer.cornerRadius = registerButton.frame.size.height/2
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.clear.cgColor
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logUserIn(_ sender: Any) {
        // Perform request
        let username = usernameTextField.text ?? "";
        let password = passwordTextField.text ?? "";
        
        print("username: ",username)
        print("password: ", password)
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            
            if error != nil {
                
                let alertController = UIAlertController(title: "Error", message: "Username/Password is incorrect", preferredStyle: .alert)
                
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                    
                }
            }
            else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    @IBAction func registerUser(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "Username/Password is empty", preferredStyle: .alert)
            
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            alertController.addAction(OKAction)
            
            present(alertController, animated: true) {
                
            }
        }

        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let alertController = UIAlertController(title: "Success", message: "User registered successfully", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true) { }
            }
        }
        
    }
    
    
}
