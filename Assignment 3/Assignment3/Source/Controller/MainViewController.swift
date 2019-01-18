//
//  MainViewController.swift
//  Assignment3
//
//  Created by Kaitlyn Wright on 7/16/18.
//  Copyright © 2018 CIS 410. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, DetailViewControllerDelegate {
    
    //delegate information
    var performActionClicks = 0
    func incrementClicks() {
        performActionClicks += 1
        
        updateLabelText()
    }
    
    //done button action
    @IBAction func doneButton(_ sender: UIStoryboardSegue) {
    }
    
    @IBOutlet weak var detailActionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updateLabelText()
    }
    
    private func updateLabelText() {
        if performActionClicks == 1 {
            self.detailActionLabel.text = "The detail action has been performed 1 time"
        } else {
            self.detailActionLabel.text = "The detail action has been performed " + String(performActionClicks) + " times"
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetailsSegue" {
            let showDetailsController = segue.destination as! DetailViewController
            showDetailsController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender);
        }
    }
}
