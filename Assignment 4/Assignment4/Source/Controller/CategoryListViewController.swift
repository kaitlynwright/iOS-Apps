//
//  CategoryListViewController.swift
//  Assignment4
//
//  Created by Kaitlyn Wright on 7/22/18.
//

import UIKit

class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CatService.shared.catCategories().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatCell
        let title = CatService.shared.catCategories()[indexPath.row].0
        let subtitle = CatService.shared.catCategories()[indexPath.row].1
        cell.update(withTitle: title, withSubtitle: subtitle)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CatImagesSegue" {
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            let catImagesViewController = segue.destination as! CatImagesViewController
            catImagesViewController.selectedCatIndex = selectedIndexPath.row
            
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
}
