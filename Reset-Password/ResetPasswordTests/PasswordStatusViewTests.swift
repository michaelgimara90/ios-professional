//
//  PasswordStatusViewTests.swift
//  ResetPasswordTests
//
//  Created by Michael Gimara on 19/02/2023.
//

import XCTest

@testable import Reset_Password

class PasswordStatusViewTests_WhenValidationIsInline_ThenShowCircleOrCheckmarkImage: XCTestCase {
    
    var passwordStatusView: PasswordStatusView!
    let tooShortPassword = "1234Aa!"
    let validPassword = "12345678Aa!"
    
    override func setUp() {
        super.setUp()
        
        passwordStatusView = PasswordStatusView()
        passwordStatusView.shouldResetCriteria = true // inline
    }
    
    override func tearDown() {
        super.tearDown()
        
        passwordStatusView = nil
    }
    
    func testCriteriaNotMetPassword() throws {
        passwordStatusView.updateDisplay(tooShortPassword)
        XCTAssertFalse(passwordStatusView.lengthAndNoSpaceCriteriaView.isCriteriaMet)
        XCTAssertTrue(passwordStatusView.lengthAndNoSpaceCriteriaView.isCircleImage)
    }
    
    func testValidPassword() throws {
        passwordStatusView.updateDisplay(validPassword)
        XCTAssertTrue(passwordStatusView.lengthAndNoSpaceCriteriaView.isCriteriaMet)
        XCTAssertTrue(passwordStatusView.lengthAndNoSpaceCriteriaView.isCheckmarkImage)
    }
}

class PasswordStatusViewTests_WhenValidationIsLossOfFocus_ThenShowCheckmarkOrXmarkImage: XCTestCase {
    
    var passwordStatusView: PasswordStatusView!
    let tooShortPassword = "1234Aa!"
    let validPassword = "12345678Aa!"
    
    override func setUp() {
        super.setUp()
        
        passwordStatusView = PasswordStatusView()
        passwordStatusView.shouldResetCriteria = false // loss of focus
    }
    
    override func tearDown() {
        super.tearDown()
        
        passwordStatusView = nil
    }
    
    func testCriteriaNotMetPassword() throws {
        passwordStatusView.updateDisplay(tooShortPassword)
        XCTAssertFalse(passwordStatusView.lengthAndNoSpaceCriteriaView.isCriteriaMet)
        XCTAssertTrue(passwordStatusView.lengthAndNoSpaceCriteriaView.isXmarkImage)
    }
    
    func testValidPassword() throws {
        passwordStatusView.updateDisplay(validPassword)
        XCTAssertTrue(passwordStatusView.lengthAndNoSpaceCriteriaView.isCriteriaMet)
        XCTAssertTrue(passwordStatusView.lengthAndNoSpaceCriteriaView.isCheckmarkImage)
    }
}

class PasswordStatusViewTests_ValidateThreeOfFour: XCTestCase {
    
    var passwordStatusView: PasswordStatusView!
    let twoOfFour = "12345678A"
    let threeOfFour = "12345678Aa"
    let fourOfFour = "12345678Aa!"
    
    override func setUp() {
        super.setUp()
        
        passwordStatusView = PasswordStatusView()
    }
    
    override func tearDown() {
        super.tearDown()
        
        passwordStatusView = nil
    }
    
    func testTwoOfFour() throws {
        XCTAssertFalse(passwordStatusView.validate(twoOfFour))
    }
    
    func testThreeOfFour() throws {
        XCTAssertTrue(passwordStatusView.validate(threeOfFour))
    }
    
    func testFourOfFour() throws {
        XCTAssertTrue(passwordStatusView.validate(fourOfFour))
    }
}
