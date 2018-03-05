//
//  EmergencyContactsTableViewCell.swift
//  ASDPal
//
//  Created by Agustin Balquin on 2/17/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit
import Contacts

@objc protocol EmergencyContactsTableViewCellDelegate {
    func callNumber(contactCell: EmergencyContactsTableViewCell)
}


class EmergencyContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    
    var contact: CNContact?
    
    var delegate: EmergencyContactsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func callButtonPressed(_ sender: Any) {
        delegate!.callNumber(contactCell: self)
    }
    
}
