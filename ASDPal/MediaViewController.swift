//
//  MediaViewController.swift
//  ASDPal
//
//  Created by Agustin Balquin on 2/19/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit
import MediaPlayer

@objc protocol MediaCollectionViewCellDelegate {
    func playSong(mediaCell:MediaCollectionViewCell)
}

class MediaViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var results = [MPMediaItem]()
    var resultsTest = [MPMediaItemCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         var delegate:MediaCollectionViewCellDelegate?
        
        collectionView.dataSource = self
        let status = MPMediaLibrary.authorizationStatus()
        
        if status != .authorized {
            MPMediaLibrary.requestAuthorization({
                (status) in
                switch status {
                case .notDetermined:
                    print("notDetermined")
                case .denied:
                    print("denied")
                case .restricted:
                    print("restricted")
                case .authorized:
                    print("authorized")
                    let query = MPMediaQuery.songs()
                    self.results = (query.items)!
                    if #available(iOS 10.3, *) {
                        let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer()
                        myMediaPlayer.setQueue(with:query)
                        myMediaPlayer.play()
                    } else {
                        // Fallback on earlier versions
                    }
                }
            })
        } else{
            let query = MPMediaQuery.songs()
            resultsTest = query.collections!
            results = (query.items)!
            
        }
        print("results: ", results)
    }
    
    func playSong() {
        if #available(iOS 10.3, *) {
            let myPlayer = MPMusicPlayerController.applicationMusicPlayer()
            myPlayer.setQueue(with: resultsTest[0])
            myPlayer.play()
        } else {
            let alert = UIAlertController(title: "Cannot play songs", message: "iOS version needs update", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsTest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASDPalMediaCell", for: indexPath) as! MediaCollectionViewCell
        let currentSong = resultsTest[indexPath.row]
        cell.mediaLabel.text = currentSong.representativeItem?.title
        if let artwork = currentSong.representativeItem?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork{
            cell.imageView.image = artwork.image(at: CGSize(width: 160, height: 160))
        }
        return cell
    }
}
