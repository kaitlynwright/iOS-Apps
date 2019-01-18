//
//  DetailViewController.swift
//  Assignment3
//
//  Created by Kaitlyn Wright on 7/16/18.
//  Copyright © 2018 CIS 410. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    //method for perform action button
    func incrementClicks() -> Void
}

class DetailViewController: UIViewController {
    weak var delegate: DetailViewControllerDelegate?
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBAction func onPerformActionClick(_ sender: Any) {
        delegate?.incrementClicks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentTimeValue = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        self.dateTimeLabel.text = "Presented at " + currentTimeValue
    }
}
