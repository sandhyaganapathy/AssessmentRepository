//
//  TestAssessmentTests.swift
//  TestAssessmentTests
//
//  Created by Vinoth Ganapathy on 09/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import XCTest
@testable import TestAssessment

class TestAssessmentTests: XCTestCase {
  var sessionUnderTest: URLSession!
  override func setUp() {
    super.setUp()
    sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
  }
  
  override func tearDown() {
    sessionUnderTest = nil
    super.tearDown()
  }
  // Asynchronous test: success fast, failure slow
  func testValidCallToGetsHTTPStatusCode200() {
    // given
    let url = URL(string: Constants.URLStrings.WEB_SERVICE_URL_STRING)
    // 1
    let promise = expectation(description: "Status code: 200")
    
    // when
    let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
      // then
      if let error = error {
        XCTFail("Error: \(error.localizedDescription)")
        return
      } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if statusCode == 200 {
          // 2
          promise.fulfill()
        } else {
          XCTFail("Status code: \(statusCode)")
        }
      }
    }
    dataTask.resume()
    // 3
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  // Asynchronous test: faster fail
  func testCallToTaskCompletes() {
    // given
    let url = URL(string: Constants.URLStrings.WEB_SERVICE_URL_STRING)
    // 1
    let promise = expectation(description: "Completion handler invoked")
    var statusCode: Int?
    var responseError: Error?
    
    // when
    let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
      statusCode = (response as? HTTPURLResponse)?.statusCode
      responseError = error
      // 2
      promise.fulfill()
    }
    dataTask.resume()
    // 3
    waitForExpectations(timeout: 5, handler: nil)
    
    // then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
    
}
