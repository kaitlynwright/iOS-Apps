//
//  CatCell.swift
//  Assignment4
//
//  Created by Kaitlyn Wright on 7/22/18.
//

import UIKit

class CatCell: UITableViewCell {

    func update(withTitle title: String, withSubtitle subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
}
