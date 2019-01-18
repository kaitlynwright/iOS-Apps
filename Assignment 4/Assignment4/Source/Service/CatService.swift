//
//  CatService.swift
//  Assignment4
//


import Foundation


class CatService {
	// MARK: Service
	func catCategories() -> Array<(title: String, subtitle: String)> {
        let array = catValues.map { ($0[titleKey] as! String, "Contains " + String(($0[imageNamesKey] as! Array<String>).count) + " images") }
        return array
	}

	func imageNamesForCategory(atIndex index: NSInteger) -> Array<String> {
        let imageArray = catValues.map { $0[imageNamesKey] as! Array<String> }
        let images = imageArray[index]
        return images
    }

	// MARK: Initialization
	private init() {
		let catValuesDataURL = Bundle.main.url(forResource: "CatValues", withExtension: "plist")!
		let catValuesData = try! Data(contentsOf: catValuesDataURL)
		catValues = try! PropertyListSerialization.propertyList(from: catValuesData, options: [], format: nil) as! Array<Dictionary<String, Any>>
	}

	// MARK: Properties (Private)
	private let catValues: Array<Dictionary<String, Any>>

	// MARK: Properties (Private, Constant)
	private let titleKey = "CategoryTitle"
	private let imageNamesKey = "ImageNames"

	// MARK: Properties (Static)
	static let shared = CatService()
}
