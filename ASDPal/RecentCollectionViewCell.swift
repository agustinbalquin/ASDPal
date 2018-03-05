//
//  RecentCollectionViewCell.swift
//  ASDPal
//
//  Created by Agustin Balquin on 3/5/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit
import MediaPlayer

@objc protocol RecentCollectionViewCellDelegate {
    func playSong(recentCell:RecentCollectionViewCellDelegate)
}
class RecentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mediaLabel: UILabel!
    
    var delegate:RecentCollectionViewCellDelegate?
    
    var cellSong: MPMediaItemCollection?
    
    @IBAction func songClick(_ sender: Any) {
        delegate!.playSong(recentCell: self as! RecentCollectionViewCellDelegate)
    }
}
