//
//  TestAssessmentUITests.swift
//  TestAssessmentUITests
//
//  Created by sandhya ganapathy on 09/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import XCTest
class TestAssessmentUITests: XCTestCase {
  let app = XCUIApplication()
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    XCUIApplication().launch()
  }
  override func tearDown() {
    super.tearDown()
  }
  // MARK: - Test Methods
  //Test app when there is no internet connection
  func testAppInOfflineMode() {
    if !Reachability.isConnectedToNetwork() {
      offlineMode()
    } else {
      onlineMode()
    }
    sleep(2)
  }
  //Test app when there is internet connection
  func testAppInOnlineMode() {
    if Reachability.isConnectedToNetwork() {
      onlineMode()
    } else {
      offlineMode()
    }
    sleep(2)
  }
  //Test PullToRefresh, when there is internet connection
  func testPullToRefreshOnline() {
    if Reachability.isConnectedToNetwork() {
      pullToRefreshWithInternetConnection()
    }
    sleep(2)
  }
  //Test PullToRefresh, when there is no internet connection
  func testPullToRefreshOffline() {
    if !Reachability.isConnectedToNetwork() {
      pullToRefreshWithoutInternetConnection()
    }
    sleep(2)
  }
  // MARK: - Methods
  func onlineMode() {
    let table = app.tables.element
    waitForElementToAppear(table)
    XCTAssertTrue(table.exists)
    let cell = table.cells.element(boundBy: 0)
    if cell.exists {
      XCTAssertTrue(cell.exists)
    }
  }
  func offlineMode() {
    let okButton = app.alerts.buttons["OK"]
    okButton.tap()
  }
  func pullToRefreshWithInternetConnection() {
    let table = app.tables.element
    waitForElementToAppear(table)
    XCTAssertTrue(table.exists)
    let cell = table.cells.element(boundBy: 0)
    if cell.exists {
      XCTAssertTrue(cell.exists)
      let firstCell = cell
      let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
      let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 6))
      start.press(forDuration: 0, thenDragTo: finish)
    }
  }
  func pullToRefreshWithoutInternetConnection() {
    let okButton = app.alerts.buttons["OK"]
    okButton.tap()
    let emptyListTable = app.tables["Empty list"]
    if emptyListTable.exists {
      app.tables["Empty list"].swipeDown()
      if app.alerts.buttons["OK"].exists {
        app.alerts.buttons["OK"].tap()
      }
    }
  }
  func waitForElementToAppear(_ element: XCUIElement) {
    let existsPredicate = NSPredicate(format: "exists == true")
    expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
    waitForExpectations(timeout: 5, handler: nil)
  }
}
