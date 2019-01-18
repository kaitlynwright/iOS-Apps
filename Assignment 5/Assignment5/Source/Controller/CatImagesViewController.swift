//
//  CatImagesViewController.swift
//  Assignment5
//
//  Created by Charles Augustine on 7/15/18.
//


import UIKit


class CatImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	// MARK: UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return CatService.shared.imageNamesForCategory(atIndex: categoryIndex).count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImageCell", for: indexPath) as! CatImageCell
		let imageName = CatService.shared.imageNamesForCategory(atIndex: categoryIndex)[indexPath.item]
		cell.update(withImageName: imageName)

		return cell
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		let cellSize = (view.frame.width - 20) / 2
		(collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: cellSize, height: cellSize)
	}

	// MARK: Properties
	var categoryIndex: Int!

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var collectionView: UICollectionView!
}
