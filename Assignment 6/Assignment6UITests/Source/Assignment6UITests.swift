//
//  Assignment6UITests.swift
//  Assignment6UITests
//


import XCTest


class Assignment6UITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()

		continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
		app.launch()
    }
    
	// UI Tests Implementation
    func testViews() {
        // check: table is not empty
        let tableView = app.tables
        let tableCellCount = tableView.cells.count
        XCTAssertGreaterThan(tableCellCount, 0, "Table View is empty.")
        
        // check: tap on Table View cell segues to Collection View scene
        let tableCell = tableView.cells.element(boundBy: 0)
        tableCell.tap()
        
        let navBar = app.navigationBars["Cat Images"]
        let existsPredicate = NSPredicate(format: "exists == TRUE")
        expectation(for: existsPredicate, evaluatedWith: navBar, handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // check: collection view is not empty
        let collectionView = app.collectionViews
        let collectionCellCount = collectionView.cells.count
        XCTAssertGreaterThan(collectionCellCount, 0, "Collection View is empty.")
    }
    
    
}
