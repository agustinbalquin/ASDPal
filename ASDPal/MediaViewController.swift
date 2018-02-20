//
//  MediaViewController.swift
//  ASDPal
//
//  Created by Agustin Balquin on 2/19/18.
//  Copyright © 2018 ASDPal. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASDPalMediaCell", for: indexPath) as! MediaCollectionViewCell
        return cell
    }
}
