//
//  HomeViewController.swift
//  ASDPal
//
//  Created by Agustin Balquin on 2/26/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutUser(_ sender: Any) {
        
        // Define alerts
        let alert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        // Add alerts
        alert.addAction(UIAlertAction(title: "Logout", style: .default) { action in
            PFUser.logOutInBackground { (error: Error?) in }
            NotificationCenter.default.post(name: NSNotification.Name("logoutNotfication"),object: nil)
        })
        alert.addAction(cancelAction)
        
        // Present
        self.present(alert, animated: true) { }
        
    }

}
