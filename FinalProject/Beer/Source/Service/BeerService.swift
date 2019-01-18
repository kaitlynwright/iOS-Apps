//
//  BeerService.swift
//  Beer Tracker
//
//  Created by Kaitlyn Wright on 8/3/18.
//  Copyright © 2018 Kaitlyn Wright. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class BeerService {
    
    static let shared = BeerService()
    
    // MARK: Properties
    var persistentContainer: NSPersistentContainer
    
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: Initialization
    private init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores(completionHandler: { (description, error) in
            if let e = error as NSError? {
                fatalError("Error loading persistent store \(e)")
            }
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        })
    }
    
    // MARK: Methods
    func setTypeDescriptions(for type: Type) {
        switch (type.name) {
        case "Ale":
            type.typeDescription = "Sweet, full-bodied and fruity taste"
        case "Lager":
            type.typeDescription = "Crisp and clear taste"
        case "Stout":
            type.typeDescription = "Dark color with a roasted rich & full taste"
        case "Porter":
            type.typeDescription = "Dark color with rich & full taste"
        case "Malt":
            type.typeDescription = "Dark & sweet with light to full-bodied taste"
        default:
            type.typeDescription = "---"
        }
    }
    
    func inDataType(_ name: String) -> Type? {
        var types: [Type]
        
        let fetchRequest: NSFetchRequest<Type> = Type.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        do {
            types = try managedContext.fetch(fetchRequest)
        } catch {
            types = []
        }
        
        for type in types {
            if name == type.name {
                return type
            }
        }
        return nil
    }
    
    func inDataLocation(_ name: String) -> Location? {
        var locations: [Location]
    
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        do {
            locations = try managedContext.fetch(fetchRequest)
        } catch {
            locations = []
        }
        
        for location in locations {
            if name == location.name {
                return location
            }
        }
        return nil
    }
    
    func deleteBeer(_ beer: Beer) throws {
        let location = beer.location!
        let type = beer.type!
        
        managedContext.delete(beer)
        managedContext.delete(location)
        managedContext.delete(type)
        
        try managedContext.save()
    }
    
    func addBeer(withName name: String, ibu: String, abv: String, date: String, withTypeName typeName: String, withLocationName locationName: String, description: String, rating: Double, userImage: UIImage) throws {
        
        // beer
        let beer = Beer(context: managedContext)
        beer.name = name
        beer.ibu = ibu
        beer.abv = abv
        beer.user_description = description
        beer.date = date
        beer.rating = rating
        
        // location
        let existingLocation = inDataLocation(locationName)
        
        if let location = existingLocation {
            beer.location = location
        } else {
            let location = Location(context: managedContext)
            location.name = locationName
            beer.location = location
        }
        
        // type
        let existingType = inDataType(typeName)
        
        if let type = existingType{
            beer.type = type
        } else {
            let type = Type(context: managedContext)
            type.name = typeName
            
            setTypeDescriptions(for: type)
            
             beer.type = type
        }
        
        // image
        let image = UserImage(context: managedContext)
        image.data = UIImagePNGRepresentation(userImage)
        beer.image = image
        
        // save
        try managedContext.save()
    }
    
    func updateBeer(forBeer beer: Beer, withName name: String, ibu: String, abv: String, date: String, withTypeName typeName: String, withLocationName locationName: String, description: String, rating: Double, userImage: UIImage) throws {
        beer.name = name
        beer.ibu = ibu
        beer.abv = abv
        beer.user_description = description
        beer.date = date
        beer.rating = rating
    
        print(locationName)
        
        // location
        if let location = beer.location {
            if locationName != location.name {
                managedContext.delete(location)
            }
        }
        
        let existingLocation = inDataLocation(locationName)
        if let location = existingLocation {
            beer.location = location
        } else {
            let location = Location(context: managedContext)
            location.name = locationName
            beer.location = location
        }
        
        // type
        if let type = beer.type {
            if typeName != type.name {
                managedContext.delete(type)
            }
        }
        let existingType = inDataType(typeName)
        if let type = existingType{
            beer.type = type
        } else {
            let type = Type(context: managedContext)
            type.name = typeName
            
            setTypeDescriptions(for: type)
            beer.type = type
        }
        
        // image
        if let currImage = beer.image {
            managedContext.delete(currImage)
        }
        
        let image = UserImage(context: managedContext)
        image.data = UIImagePNGRepresentation(userImage)
        beer.image = image
        
        // save
        try managedContext.save()
    }
    
    // MARK: Results Controllers
    private func fetchedResultsController<T>(for fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T> where T: NSManagedObject {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }
    
    func beers() -> NSFetchedResultsController<Beer> {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return fetchedResultsController(for: fetchRequest)
    }
    
    func locations() -> NSFetchedResultsController<Location> {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return fetchedResultsController(for: fetchRequest)
    }
    
    func types() -> NSFetchedResultsController<Type> {
        let fetchRequest: NSFetchRequest<Type> = Type.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return fetchedResultsController(for: fetchRequest)
    }
    
    func beersByLocation(for location: Location) -> NSFetchedResultsController<Beer> {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "location == %@", location)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        return fetchedResultsController(for: fetchRequest)
    }
    
    func beersByType(for type: Type) -> NSFetchedResultsController<Beer> {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", type)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        return fetchedResultsController(for: fetchRequest)
    }
    
    func beersByName(for name: String) -> NSFetchedResultsController<Beer> {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        return fetchedResultsController(for: fetchRequest)
    }
    
    func locationByNameSearch(for name: String) -> NSFetchedResultsController<Location> {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        return fetchedResultsController(for: fetchRequest)
    }
    
    func beersByNameSearch(for name: String) -> NSFetchedResultsController<Beer> {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        return fetchedResultsController(for: fetchRequest)
     }
    
}
