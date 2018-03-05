//
//  EmergencyContactsViewController.swift
//  ASDPal
//
//  Created by Agustin Balquin on 2/17/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit

import Contacts

class EmergencyContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var cnContacts = [CNContact]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var demoArrays = [(name: "Mom", number: "5625063648"),(name: "Dad", number: "5625063648"), (name: "Big Sister", number: "5625063648"), (name: "Teacher", number: "5625063648"), (name: "Aunt Janine", number: "5625063648"), (name: "Steve -Neighbor", number: "5625063648")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !demoArrays.isEmpty {
            return demoArrays.count
        } else {
            return cnContacts.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emergencyCell", for: indexPath) as! EmergencyContactsTableViewCell
        
        cell.delegate = self
        if !demoArrays.isEmpty {
            cell.contactName.text = demoArrays[indexPath.row].name
        } else {
            if !cnContacts.isEmpty {
                let contact = cnContacts[indexPath.row]
                cell.contact = contact
                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
                cell.contactName.text = fullName
                NSLog("\(fullName): \(contact.phoneNumbers.description)")
            } else {
                cell.contactName.text = "No Name"
            }
        }
        
        return cell
    }
    
    func fetchContacts() {
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            
            
            do {
                try store.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    self.cnContacts.append(contact)
                }
            } catch let error {
                NSLog("Fetch contact error: \(error)")
            }
        })
    }

    @IBAction func fetchContactsButtonPress(_ sender: Any) {
        
        let alert = UIAlertController(title: "Fetch Contacts", message: "Do you want to fetch contacts, this may take a while", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true) { self.fetchContacts() }
        
    }
    
    func makeCall(number: String)  {
        print("number is: \(number)")
        let url: NSURL = URL(string: "TEL://\(number)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
}

extension EmergencyContactsViewController: EmergencyContactsTableViewCellDelegate {
    func callNumber(contactCell: EmergencyContactsTableViewCell) {
        let text = contactCell.contact?.phoneNumbers[0].value.stringValue
        let charSet = NSCharacterSet(charactersIn: "1234567890").inverted
        let cleanedArr =  text?.components(separatedBy: charSet)
        let cleanedString = cleanedArr?.joined()
        makeCall(number: cleanedString!)
    }
}
