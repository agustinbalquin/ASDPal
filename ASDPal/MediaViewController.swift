//
//  MediaViewController.swift
//  ASDPal
//
//  Created by Agustin Balquin on 2/19/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var results = [MPMediaItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            results = (query.items)!
            if #available(iOS 10.3, *) {
                let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer()
                myMediaPlayer.setQueue(with:query)
                myMediaPlayer.play()
            } else {
                print("Version to o")
            }
        }
        print("results: ", results)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASDPalMediaCell", for: indexPath) as! MediaCollectionViewCell
        return cell
    }
}
