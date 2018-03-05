//
//  EmergencyContactsViewController.swift
//  ASDPal
//
//  Created by Agustin Balquin on 2/17/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit

import Contacts
import CoreLocation
import MessageUI

class EmergencyContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
 

    @IBOutlet weak var tableView: UITableView!
    
    var location = CLLocation()
    private var locman = CLLocationManager()
    private var startTime: Date?
    
    var cnContacts = [CNContact]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var demoArrays = [(name: "Mom", number: "9099928405"),(name: "Dad", number: "9098393141"), (name: "Big Sister", number: "9258581118"), (name: "Teacher", number: "5625063648")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locman.delegate = self
        locman.requestWhenInUseAuthorization()
        locman.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locman.startUpdatingLocation()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    // Message Compose Controller
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
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
            cell.number = demoArrays[indexPath.row].number
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
    @IBAction func helpPressed(_ sender: Any) {
        
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients =  ["6265607761"]  //demoArrays.map{$0.number}
        composeVC.body = "I need Help!"
        let tempCoordinate = locman.location?.coordinate
        composeVC.addAttachmentURL(locationVCardURLFromCoordinate(coordinate: location.coordinate)! as URL, withAlternateFilename: "vCard.loc.vcf")
        
        self.present(composeVC, animated: true, completion: nil)
        
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
    
    func callNumberDemo(number:String) {
        makeCall(number: number)
    }
}
