//
//  CatImagesViewController.swift
//  Assignment4
//
//  Created by Kaitlyn Wright on 7/22/18.
//

import UIKit

class CatImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var selectedCatIndex: Int!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CatService.shared.imageNamesForCategory(atIndex: selectedCatIndex).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageNames = CatService.shared.imageNamesForCategory(atIndex: selectedCatIndex)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImageCell", for: indexPath) as! CatImageCell
        cell.setImage(imageNames[indexPath.row])
        
        return cell
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
