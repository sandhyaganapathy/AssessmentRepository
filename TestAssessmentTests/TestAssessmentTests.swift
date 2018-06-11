//
//  TestAssessmentTests.swift
//  TestAssessmentTests
//
//  Created by sandhya ganapathy on 09/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import XCTest
@testable import TestAssessment

class TestAssessmentTests: XCTestCase {
  var sessionUnderTest: URLSession!
  let viewController = ListTableViewController()
  override func setUp() {
    super.setUp()
    let listViewController = ListTableViewController()
    let navigationController = UINavigationController.init(rootViewController: listViewController)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate?.window?.rootViewController = navigationController
    self.viewController.performSelector(onMainThread: #selector(viewController.viewDidLoad),
                                        with: nil, waitUntilDone: true)
    sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
  }
  override func tearDown() {
    sessionUnderTest = nil
    super.tearDown()
  }
  // MARK: - View loading tests
  func testThatViewLoads() {
    XCTAssertNotNil(self.viewController.view, "View not initiated properly")
  }
  func testParentViewHasTableViewSubview() {
    XCTAssertTrue((self.viewController.tableView != nil), "View does not have a tableview")
  }
  func testThatTableViewLoads() {
    XCTAssertNotNil(self.viewController.tableView, "TableView not initiated")
  }
  // MARK: - UITableView tests
  func testThatViewConformsToUITableViewDataSource() {
    XCTAssertTrue(self.viewController.conforms(to: UITableViewDataSource.self),
                  "View does not conform to UITableView datasource protocol")
  }
  func testThatTableViewHasDataSource() {
    XCTAssertNotNil(self.viewController.tableView.dataSource, "Table datasource cannot be nil")
  }
  func testTableViewNumberOfRowsInSection() {
    let expectedRows = viewController.listViewModel.numberOfRowsInSection()
    let tableViewRows = self.viewController.tableView(self.viewController.tableView, numberOfRowsInSection: 0)
    XCTAssertTrue(tableViewRows == expectedRows, "Table has \(tableViewRows) rows but it should have \(expectedRows)")
  }
  func testTableViewCellCreateCellsWithReuseIdentifier() {
    let indexPath = IndexPath(row: 0, section: 0)
    var cell = self.viewController.tableView.cellForRow(at: indexPath) as? ListTableViewCell
    if cell == nil {
      cell = self.viewController.tableView.dequeueReusableCell(withIdentifier:
        self.viewController.cellIdentifier) as? ListTableViewCell
    }
    let expectedReuseIdentifier = self.viewController.cellIdentifier
    XCTAssertTrue(cell?.reuseIdentifier == expectedReuseIdentifier, "Table does not create reusable cells")
  }
  // MARK: - Asynchronous test
  func testValidCallToGetsHTTPStatusCode200() {
    if Reachability.isConnectedToNetwork() {
      let url = URL(string: Constants.URLStrings.webServiceUrlString)
      let promise = expectation(description: "Status code: 200")
      let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      }
      dataTask.resume()
      waitForExpectations(timeout: 5, handler: nil)
    }
  }
  // Asynchronous test: faster fail
  func testCallToTaskCompletes() {
    if Reachability.isConnectedToNetwork() {
      let url = URL(string: Constants.URLStrings.webServiceUrlString)
      let promise = expectation(description: "Completion handler invoked")
      var statusCode: Int?
      var responseError: Error?
      let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        responseError = error
        promise.fulfill()
      }
      dataTask.resume()
      waitForExpectations(timeout: 5, handler: nil)
      XCTAssertNil(responseError)
      XCTAssertEqual(statusCode, 200)
    }
  }
  // MARK: - Checking Internet Connection
  func testInternetConnection() {
    if Reachability.isConnectedToNetwork() {
      XCTAssertTrue(Reachability.isConnectedToNetwork(), "No Network connection Available")
      XCTAssertFalse(!Reachability.isConnectedToNetwork(), "Network connection Available")
    }
  }
  func testNoInternetConnection() {
    if !Reachability.isConnectedToNetwork() {
      XCTAssertTrue(!Reachability.isConnectedToNetwork(), "Network connection Available")
      XCTAssertFalse(Reachability.isConnectedToNetwork(), "No Network connection Available")
    }
  }
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}
