//
//  LogInViewController.swift
//  ASDPal
//
//  Created by Agustin Balquin on 2/23/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logUserIn(_ sender: Any) {
        // Perform request
        let username = usernameTextField.text? ?? "";
        let password = passwordTextField.text? ?? "";
    
    }
}
