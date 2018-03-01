//
//  MediaCollectionViewCell.swift
//  ASDPal
//
//  Created by Agustin Balquin on 2/20/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit
import MediaPlayer

@objc protocol MediaCollectionViewCellDelegate {
    func playSong(mediaCell:MediaCollectionViewCell)
}

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mediaLabel: UILabel!
    
    var delegate:MediaCollectionViewCellDelegate?
    
    var cellSong: MPMediaItemCollection?
    
    @IBAction func songClick(_ sender: Any) {
        delegate!.playSong(mediaCell: self)
    }

}
