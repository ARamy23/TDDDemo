//
//  LoginTests.swift
//  TDDDemoTests
//
//  Created by Ahmed Ramy on 24/12/2021.
//

import XCTest
@testable import TDDDemo

class FakeNetwork: NetworkProtocol {
    var shouldWait: Bool = false
    var continueAction: (() -> Void)?
    
    var expectedError: NetworkError?
    
    func callLogin(email: String, password: String, onComplete: @escaping (Result<Void, NetworkError>) -> Void) {
        if shouldWait {
          continueAction = {
              if let expectedError = self.expectedError {
                  onComplete(.failure(expectedError))
              } else {
                  onComplete(.success(()))
              }
          }
        } else {
            if let expectedError = expectedError {
                onComplete(.failure(expectedError))
            } else {
                onComplete(.success(()))
            }
        }
    }
}

class LoginTests: XCTestCase {
    var sut: LoginViewModel!
    var network: FakeNetwork = .init()
    
    override func setUp() {
        sut = .init(network: network)
        sut.email = "asmdi@asd.com"
        sut.password = "123asd123123@"
    }
    
    override func tearDown() {
        sut = nil
    }
    
    /**
     State
    1. Loading
        1. Loading On off {DONE]
    2. Failure
     1. User not verified
        -> Go to verify email or send email screen
     2. User banned
        -> You're banned
     3. Creds wrong
        -> Please check
    3. success
        1. Go to home
     **/
    
    func testWhenRequestIsInflightLoadingIsOnElseLoadingIsOff() {
        // Given
        network.shouldWait = true
        
        // When
        sut.login()
        
        // Then
        XCTAssertTrue(sut.isLoading)
        network.continueAction?()
        XCTAssertFalse(sut.isLoading)
    }
    
    func testWhenUserIsNotVerifiedDuringLoginHeIsAlerted() {
        // Given
        let expectedError: NetworkError = .init(networkCase: .userNotVerified)
        network.expectedError = expectedError
        
        // When
        sut.login()
        
        // Then
        XCTAssertTrue(sut.errors.contains(expectedError))
    }
}
