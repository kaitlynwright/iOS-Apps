//
//  TypeTableViewController.swift
//  Beer Tracker
//
//  Created by Kaitlyn Wright on 8/15/18.
//  Copyright © 2018 Kaitlyn Wright. All rights reserved.
//

import UIKit
import CoreData

class TypeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    // MARK: Properties
    var resultsController: NSFetchedResultsController<Type>!
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Table View data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)
        let type = resultsController.object(at: indexPath)
        cell.textLabel?.text = type.name
        cell.detailTextLabel?.text = type.typeDescription
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Init
        resultsController = BeerService.shared.types()
        resultsController.delegate = self
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultsController = BeerService.shared.types()
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
        tableView.reloadData()
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "typeToBeerSegue" {
            let vc = segue.destination as! TableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            vc.type = resultsController.object(at: indexPath)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: Extension
extension TypeTableViewController: NSFetchedResultsControllerDelegate {
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
