//
//  LocationTableViewController.swift
//  Beer Tracker
//
//  Created by Kaitlyn Wright on 8/15/18.
//  Copyright © 2018 Kaitlyn Wright. All rights reserved.
//

import UIKit
import CoreData

class LocationTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: Properties
    var resultsController: NSFetchedResultsController<Location>!
    var isSearching = false
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let location = resultsController.object(at: indexPath)
        cell.textLabel?.text = location.name
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Search Bar
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.delegate = self
        
        // Init
        resultsController = BeerService.shared.locations()
        resultsController.delegate = self
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultsController = BeerService.shared.locations()
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationToBeerSegue" {
            let vc = segue.destination as! TableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            vc.location = resultsController.object(at: indexPath)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }

    // MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            resultsController = BeerService.shared.locations()
            tableView.reloadData()
        } else {
            isSearching = true
            resultsController = BeerService.shared.locationByNameSearch(for: searchText)
            tableView.reloadData()
            
        }
    }
}

// MARK: Extension
extension LocationTableViewController: NSFetchedResultsControllerDelegate {
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
        default:
            break
        }
    }
}


