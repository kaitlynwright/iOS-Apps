//
//  Category+CoreDataClass.swift
//  Assignment5
//
//  Created by Kaitlyn Wright on 7/29/18.
//
//

import Foundation
import CoreData


public class Category: NSManagedObject {
    
    let imageCount: Int = self.imageRelation.allObjects.count
    let subtitle = "Contains " + imageCount + " images."
}
