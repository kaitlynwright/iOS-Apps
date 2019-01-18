//
//  PreferencesViewController.swift
//  Beer
//
//  Created by Kaitlyn Wright on 8/19/18.
//  Copyright © 2018 Kaitlyn Wright. All rights reserved.
//

import UIKit
import CoreData

class PreferencesViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var ale: UILabel!
    @IBOutlet weak var stout: UILabel!
    @IBOutlet weak var porter: UILabel!
    @IBOutlet weak var lager: UILabel!
    @IBOutlet weak var malt: UILabel!
    @IBOutlet weak var favoriteType: UILabel!
    @IBOutlet weak var sliderRating: UILabel!
    @IBOutlet weak var ibuRating: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.value = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let aleAvg = averageRatingForType("Ale")
        let lagerAvg = averageRatingForType("Lager")
        let stoutAvg = averageRatingForType("Stout")
        let maltAvg = averageRatingForType("Malt")
        let porterAvg = averageRatingForType("Porter")
        
        let maxRating = max(aleAvg, lagerAvg, maltAvg, stoutAvg, porterAvg)
        if maxRating == aleAvg { favoriteType.text = "Ale"}
        else if maxRating == lagerAvg { favoriteType.text = "Lager" }
        else if maxRating == stoutAvg { favoriteType.text = "Stout" }
        else if maxRating == maltAvg { favoriteType.text = "Malt" }
        else if maxRating == porterAvg { favoriteType.text = "Porter" }
        
        ale.text = String(aleAvg)
        lager.text = String(lagerAvg)
        stout.text = String(stoutAvg)
        malt.text = String(maltAvg)
        porter.text = String(porterAvg)
    }
    
    // MARK: Methods
    func ratingForIbu() -> Double {
        var beersForIbu: [Beer]
        var averageRating = 0.0
        
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ibu == %@", sliderRating.text!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        do {
           beersForIbu = try BeerService.shared.managedContext.fetch(fetchRequest)
        } catch {
            beersForIbu = []
        }
        
        for beer in beersForIbu {
            averageRating += beer.rating
        }
        
        if beersForIbu != [] {
            averageRating = averageRating / Double(beersForIbu.count)
        } else {
            averageRating = 0.0
        }
        
        return averageRating
    }
    
    func averageRatingForType(_ typeName: String) -> Double {
        var beers: [Beer]
        var averageRating = 0.0
        
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type.name == %@", typeName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        do {
            beers = try BeerService.shared.managedContext.fetch(fetchRequest)
        } catch {
            beers = []
        }
        
        for beer in beers {
            averageRating += beer.rating
        }
        
        if beers != [] {
            averageRating = averageRating / Double(beers.count)
        } else {
            averageRating = 0.0
        }
        
        return averageRating
    }
    
    
    // MARK: Actions
    @IBAction func sliderChange(_ sender: UISlider) {
        let ibu = round(sender.value).cleanValue
        sliderRating.text = String(ibu)
        
        let averageRating = ratingForIbu()
        ibuRating.text = String(averageRating)
    }

}

extension Float {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
