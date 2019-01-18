//
//  BeerViewViewController.swift
//  Beer Tracker
//
//  Created by Kaitlyn Wright on 8/5/18.
//  Copyright © 2018 Kaitlyn Wright. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class BeerViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    // MARK: Properties
    var beer: Beer!
    
    // MARK: Outlets
    @IBOutlet weak var abv: UILabel!
    @IBOutlet weak var ibu: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // set labels
        self.title = beer.name
        if let abvExists = beer.abv {
            abv.text = abvExists + "%"
        } else {
            abv.text = beer.abv!
        }
        ibu.text = beer.ibu
        date.text = beer.date
        locationLabel.text = beer.location?.name
        descrip.layer.borderColor = UIColor.black.cgColor
        descrip.layer.borderWidth = 1.0
        descrip.sizeToFit()
        descrip.text = beer.user_description
        typeLabel.text = beer.type?.name
        
        // rating
        setRatingImage(beer.rating)
        
        // set image
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0
        
        if let imageData = beer.image?.data {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = UIImage(named: "default_image")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Methods
    // email
    func configureMailComposeViewController() -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        
        vc.setSubject("You should try this beer!")
        vc.setMessageBody("I tried \(beer.name!) at \(beer.location?.name ?? "Unspecified") on \(beer.date ?? "Unspecified"). I rated it \(beer.rating) out of 5 stars. Give it a try!", isHTML: false)
        
        return vc
    }
    
    func showSendEmailAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email.", message: "Please check e-mail conifiguration and try again.", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    // text
    func configureMessageComposeViewController() -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.messageComposeDelegate = self
        vc.body = "I tried \(beer.name!) at \(beer.location?.name ?? "Unspecified") on \(beer.date ?? "Unspecified"). I rated it \(beer.rating) out of 5 stars. Give it a try!"
        
        return vc
    }
    
    func showSendMessageAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send message.", message: "Please check message conifiguration and try again.", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    // display star rating
    func setRatingImage(_ rating: Double) {
        switch(rating) {
        case 0.5:
            star1.image = UIImage(named: "HalfStar")
            star2.image = UIImage(named: "EmptyStar")
            star3.image = UIImage(named: "EmptyStar")
            star4.image = UIImage(named: "EmptyStar")
            star5.image = UIImage(named: "EmptyStar")
        case 1.0:
            star1.image = UIImage(named: "FullStar")
            star2.image = UIImage(named: "EmptyStar")
            star3.image = UIImage(named: "EmptyStar")
            star4.image = UIImage(named: "EmptyStar")
            star5.image = UIImage(named: "EmptyStar")
        case 1.5:
            star1.image = UIImage(named: "FullStar")
            star2.image = UIImage(named: "HalfStar")
            star3.image = UIImage(named: "EmptyStar")
            star4.image = UIImage(named: "EmptyStar")
            star5.image = UIImage(named: "EmptyStar")
        case 2.0:
            star1.image = UIImage(named: "FullStar")
            star2.image = UIImage(named: "FullStar")
            star3.image = UIImage(named: "EmptyStar")
            star4.image = UIImage(named: "EmptyStar")
            star5.image = UIImage(named: "EmptyStar")
        case 2.5:
            star1.image = UIImage(named: "FullStar")
            star2.image = UIImage(named: "FullStar")
            star3.image = UIImage(named: "HalfStar")
            star4.image = UIImage(named: "EmptyStar")
            star5.image = UIImage(named: "EmptyStar")
        case 3.0:
            star1.image = UIImage(named: "FullStar")
            star2.image = UIImage(named: "FullStar")
            star3.image = UIImage(named: "FullStar")
            star4.image = UIImage(named: "EmptyStar")
            star5.image = UIImage(named: "EmptyStar")
        case 3.5:
            star1.image = UIImage(named: "FullStar")
            star2.image = UIImage(named: "FullStar")
            star3.image = UIImage(named: "FullStar")
            star4.image = UIImage(named: "HalfStar")
            star5.image = UIImage(named: "EmptyStar")
        case 4.0:
            star1.image = UIImage(named: "FullStar")
            star2.image = UIImage(named: "FullStar")
            star3.image = UIImage(named: "FullStar")
            star4.image = UIImage(named: "FullStar")
            star5.image = UIImage(named: "EmptyStar")
        case 4.5:
            star1.image = UIImage(named: "FullStar")
            star2.image = UIImage(named: "FullStar")
            star3.image = UIImage(named: "FullStar")
            star4.image = UIImage(named: "FullStar")
            star5.image = UIImage(named: "HalfStar")
        case 5.0:
            star1.image = UIImage(named: "FullStar")
            star2.image = UIImage(named: "FullStar")
            star3.image = UIImage(named: "FullStar")
            star4.image = UIImage(named: "FullStar")
            star5.image = UIImage(named: "FullStar")
        default:
            star1.image = UIImage(named: "EmptyStar")
            star2.image = UIImage(named: "EmptyStar")
            star3.image = UIImage(named: "EmptyStar")
            star4.image = UIImage(named: "EmptyStar")
            star5.image = UIImage(named: "EmptyStar")
        }
    }
    
    
    // MARK: Actions
    @IBAction func deleteButtonClicked(_ sender: UIBarButtonItem) {
        do {
            try BeerService.shared.deleteBeer(beer)
        } catch {
            print("Delete failed.")
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func recommendMailButton(_ sender: UIButton) {
        let mailViewController = configureMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailViewController, animated: true, completion: nil)
        } else {
            self.showSendEmailAlert()
        }
    }
    
    @IBAction func recommendTextButton(_ sender: UIButton) {
        let messageViewController = configureMessageComposeViewController()
        
        if MFMessageComposeViewController.canSendText() {
            self.present(messageViewController, animated: true, completion: nil)
        } else {
            self.showSendMessageAlert()
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditSegue" {
            let vc = segue.destination as! AddNewBeerViewController
            vc.beer = beer
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }

}
