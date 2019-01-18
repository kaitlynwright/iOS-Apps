//
//  Assignment6Tests.swift
//  Assignment6Tests
//

import UIKit
import XCTest
@testable import Assignment6

class Assignment6Tests: XCTestCase {
	// TODO: Unit Tests Implementation
    let shared = CatService.shared
    
    func testCategories() {
        let controller = shared.catCategories()
        guard let sections = controller.sections else {
            print("Sections fetch failed.")
            return
        }
        XCTAssertGreaterThan(sections.count, 0, "Sections count not greater than 0")
        
        for section in sections {
            let count = section.numberOfObjects
            XCTAssertGreaterThan(count, 0, "Number of items in section not greater than 0." )
        }
    }
    
    func testImages() {
        guard let categoryObjects = shared.catCategories().fetchedObjects else {
            return
        }
        
        for category in categoryObjects {
            let imageController = shared.images(for: category)
            guard let sections = imageController.sections else {
                print("Sections fetch failed.")
                return
            }
            XCTAssertGreaterThan(sections.count, 0, "Sections count not greater than 0.")
            
            for section in sections {
                let count = section.numberOfObjects
                XCTAssertGreaterThan(count, 0, "Number of items in section not greater than 0." )
            }
        }
    }
}
