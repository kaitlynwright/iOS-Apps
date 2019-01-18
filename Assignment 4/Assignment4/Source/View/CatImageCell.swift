//
//  CatImageCell.swift
//  Assignment4
//
//  Created by Kaitlyn Wright on 7/22/18.
//

import UIKit

class CatImageCell: UICollectionViewCell {
    @IBOutlet weak var CatImageView: UIImageView!

    func setImage(_ name: String) {
        let catImage = UIImage(named: name)
        CatImageView.image = catImage
    }
}
