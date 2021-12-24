//
//  TDDDemoTests.swift
//  TDDDemoTests
//
//  Created by Ahmed Ramy on 24/12/2021.
//

import XCTest
@testable import TDDDemo
/**
 * 1. Register -> Email & Password & Confirm Password
 * 2. Validation
 *  1. Empty
 *  2. Valid
 *  3. Confirm Password == Password
 * 3. Error -> View (on exit of textfield)
*/

class TDDDemoTests: XCTestCase {
    
    var sut: RegisterViewModel!
    
    override func setUp() {
        // ... SUT ili nta bt3ml loh test
        sut = .init()
    }
    
    override func tearDown() {
        // ... SUT = nil
        sut = nil
    }
    
    func testEmailIsNotValidWhenEmpty() {
        // GIVEN
        let email = ""
        let expectedError = LocalError(.isEmpty(.email))
        sut.email = email
        
        // WHEN
        sut.register()
        
        // THEN
        XCTAssertEqual(sut.error!, expectedError)
    }
    
    func testEmailIsNotValidWhenInvalid() {
        // GIVEN
        let email = "asmdioasmx"
        let expectedError = LocalError(.isInvalid(.email))
        sut.email = email
        
        // WHEN
        sut.register()
        
        // THEN
        XCTAssertEqual(sut.error!, expectedError)
    }
}
