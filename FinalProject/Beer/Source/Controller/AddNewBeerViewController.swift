//
//  AddNewBeerViewController.swift
//  Beer Tracker
//
//  Created by Kaitlyn Wright on 8/5/18.
//  Copyright © 2018 Kaitlyn Wright. All rights reserved.
//

import UIKit
import CoreData

class AddNewBeerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: Properties
    var selectedDate: String!
    var dateFormatter: DateFormatter!
    var pickerData: Array<String>!
    var beer: Beer?
    var editMode = false

    // MARK: Outlets
    @IBOutlet weak var beerName: UITextField!
    @IBOutlet weak var locationEdit: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var ibu: UITextField!
    @IBOutlet weak var descrip: UITextView!
    @IBOutlet weak var abv: UITextField!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: View Management
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // type
        pickerData = ["None", "Ale", "Lager", "Stout", "Porter", "Malt"]
        typePicker.delegate = self
        typePicker.dataSource = self
        
        // date
        date.datePickerMode = UIDatePickerMode.date
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // rating
        slider.value = 0.0
        
        // description
        descrip.layer.borderColor = UIColor.black.cgColor
        descrip.layer.borderWidth = 1.0
        
        // image
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.image = UIImage(named: "default_image")
        
        // Set values for Edit Mode
        if beer != nil {
            editMode = true
            self.navigationItem.title = "Edit Beer"
            beerName.text = beer!.name
            locationEdit.text = beer!.location?.name
            selectedDate = beer!.date!
            date.date = dateFormatter.date(from: beer!.date!)!
            let index = pickerData.index(where: {$0 == beer!.type?.name })
            typePicker.selectRow(index ?? 0, inComponent: 0, animated: true)
            ibu.text = beer!.ibu
            abv.text = beer!.abv
            descrip.text = beer!.user_description
            rating.text = String(beer!.rating)
            slider.value = Float(beer!.rating)
            imageView.image = UIImage(data: beer!.image!.data!)
        } else {
            editMode = false
        }
        
    }

    // MARK: Type Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    // MARK: Methods
    func addNewBeer() {
        selectedDate = dateFormatter.string(from: date.date)
        let selectedType = pickerData[typePicker.selectedRow(inComponent: 0)]
        
        var ratingValue = 0.0
        if let rate = Double(rating.text!) {
            ratingValue = rate
        }
        
        // save
        do {
            if let location = locationEdit.text {
                try BeerService.shared.addBeer(withName: beerName.text!, ibu: ibu.text!, abv: abv.text!, date: selectedDate, withTypeName: selectedType, withLocationName: location, description: descrip.text, rating: ratingValue, userImage: imageView.image!)
            } else {
                try BeerService.shared.addBeer(withName: beerName.text!, ibu: ibu.text!, abv: abv.text!, date: selectedDate, withTypeName: selectedType, withLocationName: "Unspecified", description: descrip.text, rating: ratingValue, userImage: imageView.image!)
            }
        } catch {
            print("Error saving beer: \(error)")
        }
    }
    
    // MARK: Actions
    @IBAction func sliderChange(_ sender: UISlider) {
        let rate = round(sender.value/0.5) * 0.5
        rating.text = String(rate)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
         selectedDate = dateFormatter.string(from: date.date)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        guard let name = beerName.text, !name.isEmpty else {
            let alertController = UIAlertController(title: "Save failed", message: "Please enter a name.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        if editMode {
            let selectedType = pickerData[typePicker.selectedRow(inComponent: 0)]
            var ratingValue = 0.0
            if let rate = Double(rating.text!) {
                ratingValue = rate
            }
            
            try! BeerService.shared.updateBeer(forBeer: beer!, withName: beerName.text!, ibu: ibu.text!, abv: abv.text!, date: selectedDate, withTypeName: selectedType, withLocationName: locationEdit.text!, description: descrip.text!, rating: ratingValue, userImage: imageView.image!)
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            addNewBeer()
        }
        
        if let presenter = presentingViewController as? BeerViewController {
            presenter.beer = beer
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Image Controller Extension
extension AddNewBeerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        } else {
            print("Not a compatible image.")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Actions
    @IBAction func takeImage(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.camera
        image.allowsEditing = true
        
        self.present(image, animated: true)
        {
            // After completed
        }
    }
    
    @IBAction func importImage(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = true
        
        self.present(image, animated: true)
        {
            // After completed
        }
    }

}



