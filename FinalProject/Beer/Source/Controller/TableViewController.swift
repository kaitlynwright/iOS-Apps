//
//  ViewController.swift
//  Beer Tracker
//
//  Created by Kaitlyn Wright on 8/2/18.
//  Copyright © 2018 Kaitlyn Wright. All rights reserved.
//

import CoreData
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: Properties
    var resultsController: NSFetchedResultsController<Beer>!
    var location: Location?
    var type: Type?
    var isSearching = false
    
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Table View DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath)
        let beer = resultsController.object(at: indexPath)
        cell.textLabel?.text = beer.name
        cell.detailTextLabel?.text = "\(beer.rating)/5.0"
        
        if let imageData = beer.image?.data {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    // MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            resultsController = BeerService.shared.beers()
            tableView.reloadData()
        } else {
            isSearching = true
            resultsController = BeerService.shared.beersByNameSearch(for: searchText)
            tableView.reloadData()
        }
    }
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BeerViewSegue" {
            let vc = segue.destination as! BeerViewController
            let indexPath = tableView.indexPathForSelectedRow!
            vc.beer = resultsController.object(at: indexPath)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }

    // MARK: View Management
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search Bar
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.delegate = self
        
        setUpResultsController()
        resultsController.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpResultsController()
        tableView.reloadData()
    }
    
    // Methods
    func setUpResultsController() {
        if let locationDisplay = location?.name {
            self.navigationItem.title = locationDisplay
            resultsController = BeerService.shared.beersByLocation(for: location!)
        }
        else if let typeDisplay = type?.name {
            if typeDisplay != "None" {
                self.navigationItem.title = "\(typeDisplay)" + "s"
            } else {
                self.navigationItem.title = "None"
            }
            resultsController = BeerService.shared.beersByType(for: type!)
        }
        else {
            self.navigationItem.title = "Beers"
            resultsController = BeerService.shared.beers()
        }
        
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }
    
}

// MARK: Extension
extension TableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
        
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
        
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            if let cell = tableView.cellForRow(at: indexPath!), let beer = anObject as? Beer {
                cell.textLabel!.text = beer.name
            }
        }
    }
}
