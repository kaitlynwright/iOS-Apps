//
//  CatService.swift
//  Assignment5
//


import CoreData
import Foundation


class CatService {
	// MARK: Service
	func catCategories() -> NSFetchedResultsController<Category> {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Category>(entityName: "category")
        let sort = NSSortDescriptor(key: #keyPath(Category.title), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "title", cacheName: nil)
        return controller
	}

    func image(for category: Category) -> NSFetchedResultsController<Image> {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Image>(entityName: "Image")
        let predicate = NSPredicate(format: "categoryRelation == %@", category)
        let sort = NSSortDescriptor(key: #keyPath(Image.order), ascending: false)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        return controller
	}

	// MARK: Initialization
	private init() {
		persistentContainer = NSPersistentContainer(name: "Model")

		persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
			self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true

			let catValuesDataURL = Bundle.main.url(forResource: "CatValues", withExtension: "plist")!
			let catValuesData = try! Data(contentsOf: catValuesDataURL)
			let catValues = try! PropertyListSerialization.propertyList(from: catValuesData, options: [], format: nil) as! Array<Dictionary<String, Any>>

			// TODO: Store the cat data in CoreData if it is not already present
            let context = self.persistentContainer.newBackgroundContext()
            for item in catValues {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "category")
                let predicate = NSPredicate(format: "title == %@", item["categoryTitle"]! as! CVarArg)
                fetchRequest.predicate = predicate
                let fetchResults = try! context.fetch(fetchRequest) as? [Category]
                guard fetchResults!.count > 0 else {
                    fatalError()
                }
                
                let category = Category(context: context)
                category.setValue(item["categoryTitle"], forKey: "title")
                
                var i = 0
                for imageName in item["imageNames"] as! Array<String> {
                    let image = Image(context: context)
                    image.setValue(imageName, forKey: "name")
                    image.setValue(i, forKey: "order")
                    image.setValue(category, forKey: "categoryRelation")
                    i = i + 1
                }
            }
            try! context.save()
            
		})
	}

	// MARK: Private
	private let persistentContainer: NSPersistentContainer

	// MARK: Properties (Private, Constant)
	private let titleKey = "CategoryTitle"
	private let imageNamesKey = "ImageNames"

	// MARK: Properties (Static)
	static let shared = CatService()
}
