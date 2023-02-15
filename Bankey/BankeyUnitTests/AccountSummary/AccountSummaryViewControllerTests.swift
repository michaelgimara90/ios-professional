//
//  AccountSummaryViewControllerTests.swift
//  BankeyUnitTests
//
//  Created by Michael Gimara on 15/02/2023.
//

import Foundation
import XCTest

@testable import Bankey

class AccountSummaryViewControllerTests: XCTestCase {
    
    var viewController: AccountSummaryViewController!
    var mockWebService: MockAccountSummaryWebService!
    
    override func setUp() {
        super.setUp()
        
        viewController = AccountSummaryViewController()
        mockWebService = MockAccountSummaryWebService()
        viewController.webService = mockWebService
//        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
        
        viewController = nil
        mockWebService = nil
    }
    
    func testTitleAndMessageForServerError() throws {
        let titleAndMessage = viewController.testTitleAndMessageForError(.serverError)
        XCTAssertEqual("Server Error", titleAndMessage.0)
        XCTAssertEqual("Ensure you are connected to the internet. Please try again.", titleAndMessage.1)
    }
    
    func testTitleAndMessageForDecodingError() throws {
        let titleAndMessage = viewController.testTitleAndMessageForError(.decodingError)
        XCTAssertEqual("Decoding Error", titleAndMessage.0)
        XCTAssertEqual("We could not process your request. Please try again.", titleAndMessage.1)
    }
    
    func testAlertForFetchProfileServerError() throws {
        mockWebService.error = .serverError
        viewController.testFetchProfile()
        XCTAssertEqual("Server Error", viewController.errorAlert.title)
        XCTAssertEqual("Ensure you are connected to the internet. Please try again.", viewController.errorAlert.message)
    }
    
    func testAlertForFetchProfileDecodingError() throws {
        mockWebService.error = .decodingError
        viewController.testFetchProfile()
        XCTAssertEqual("Decoding Error", viewController.errorAlert.title)
        XCTAssertEqual("We could not process your request. Please try again.", viewController.errorAlert.message)
    }
    
    func testAlertForFetchAccountsServerError() throws {
        mockWebService.error = .serverError
        viewController.testFetchAccounts()
        XCTAssertEqual("Server Error", viewController.errorAlert.title)
        XCTAssertEqual("Ensure you are connected to the internet. Please try again.", viewController.errorAlert.message)
    }
    
    func testAlertForFetchAccountsDecodingError() throws {
        mockWebService.error = .decodingError
        viewController.testFetchAccounts()
        XCTAssertEqual("Decoding Error", viewController.errorAlert.title)
        XCTAssertEqual("We could not process your request. Please try again.", viewController.errorAlert.message)
    }
    
    func testFetchProfileRequest() throws {
        mockWebService.fetchProfile(forUserId: "1") { result in
            switch result {
            case .success(let profile):
                XCTAssertEqual(profile.id, "1")
                XCTAssertEqual(profile.firstName, "FirstName")
                XCTAssertEqual(profile.lastName, "LastName")
            case .failure(let error):
                XCTFail("fetchProfile failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func testFetchAccountsRequest() throws {
        mockWebService.fetchAccounts(forUserId: "1") { result in
            switch result {
            case .success(let accounts):
                XCTAssertEqual(accounts.count, 2)
                
                let account1 = accounts[0]
                XCTAssertEqual(account1.id, "1")
                XCTAssertEqual(account1.name, "Account1")
                XCTAssertEqual(account1.amount, 100)
                
                let account2 = accounts[1]
                XCTAssertEqual(account2.id, "2")
                XCTAssertEqual(account2.name, "Account2")
                XCTAssertEqual(account2.amount, 200)
            case .failure(let error):
                XCTFail("fetchAccounts failed with error: \(error.localizedDescription)")
            }
        }
    }
}
