//
//  ResetPasswordViewControllerTests.swift
//  ResetPasswordTests
//
//  Created by Michael Gimara on 19/02/2023.
//

import XCTest

@testable import Reset_Password

class ResetPasswordViewController_NewPasswordTextFieldValidation: XCTestCase {
    
    var resetPasswordViewController: ResetPasswordViewController!
    let invalidPassword = "🤩"
    let tooShortPassword = "1234Aa!"
    let validPassword = "12345678Aa!"
    
    override func setUp() {
        super.setUp()
        
        resetPasswordViewController = ResetPasswordViewController()
    }
    
    override func tearDown() {
        super.tearDown()
        
        resetPasswordViewController = nil
    }
    
    func testEmptyPassword() throws {
        resetPasswordViewController.newPasswordText = ""
        resetPasswordViewController.resetPasswordButtonTapped(sender: UIButton())
        XCTAssertEqual(resetPasswordViewController.newPasswordTextField.errorMessageLabel.text!, "Enter your password")
    }
    
    func testInvalidPassword() throws {
        resetPasswordViewController.newPasswordText = invalidPassword
        resetPasswordViewController.resetPasswordButtonTapped(sender: UIButton())
        XCTAssertEqual(resetPasswordViewController.newPasswordTextField.errorMessageLabel.text!, "Enter valid special characters !@#$%^&:?(),./\\ with no spaces")
    }
    
    func testCriteriaNotMet() throws {
        resetPasswordViewController.newPasswordText = tooShortPassword
        resetPasswordViewController.resetPasswordButtonTapped(sender: UIButton())
        XCTAssertEqual(resetPasswordViewController.newPasswordTextField.errorMessageLabel.text!, "Your password must meet the requirements below")
        XCTAssertFalse(resetPasswordViewController.newPasswordTextField.errorMessageLabel.isHidden)
    }
    
    func testValidPassword() throws {
        resetPasswordViewController.newPasswordText = validPassword
        resetPasswordViewController.resetPasswordButtonTapped(sender: UIButton())
        XCTAssertTrue(resetPasswordViewController.newPasswordTextField.errorMessageLabel.text!.isEmpty)
        XCTAssertTrue(resetPasswordViewController.newPasswordTextField.errorMessageLabel.isHidden)
    }
}

class ResetPasswordViewController_ConfirmPasswordTextFieldValidation: XCTestCase {
    var resetPasswordViewController: ResetPasswordViewController!
    let tooShortPassword = "1234Aa!"
    let validPassword = "12345678Aa!"
    
    override func setUp() {
        super.setUp()
        
        resetPasswordViewController = ResetPasswordViewController()
    }
    
    override func tearDown() {
        super.tearDown()
        
        resetPasswordViewController = nil
    }
    
    func testEmptyPassword() throws {
        resetPasswordViewController.confirmPasswordText = ""
        resetPasswordViewController.resetPasswordButtonTapped(sender: UIButton())
        XCTAssertEqual(resetPasswordViewController.confirmPasswordTextField.errorMessageLabel.text!, "Enter your password")
    }
    
    func testPasswordsDoNotMatch() throws {
        resetPasswordViewController.newPasswordText = validPassword
        resetPasswordViewController.confirmPasswordText = tooShortPassword
        resetPasswordViewController.resetPasswordButtonTapped(sender: UIButton())
        XCTAssertEqual(resetPasswordViewController.confirmPasswordTextField.errorMessageLabel.text!, "Passwords do not match")
        XCTAssertFalse(resetPasswordViewController.confirmPasswordTextField.errorMessageLabel.isHidden)
    }
    
    func testPasswordsMatch() throws {
        resetPasswordViewController.newPasswordText = validPassword
        resetPasswordViewController.confirmPasswordText = validPassword
        resetPasswordViewController.resetPasswordButtonTapped(sender: UIButton())
        XCTAssertTrue(resetPasswordViewController.confirmPasswordTextField.errorMessageLabel.text!.isEmpty)
        XCTAssertTrue(resetPasswordViewController.confirmPasswordTextField.errorMessageLabel.isHidden)
    }
}

class ResetPasswordViewController_ShowAlert: XCTestCase {
    
    var resetPasswordViewController: ResetPasswordViewController!
    let tooShortPassword = "1234Aa!"
    let validPassword = "12345678Aa!"
    
    override func setUp() {
        super.setUp()
        
        resetPasswordViewController = ResetPasswordViewController()
    }
    
    override func tearDown() {
        super.tearDown()
        
        resetPasswordViewController = nil
    }
    
    func testShowSuccess() throws {
        resetPasswordViewController.newPasswordText = validPassword
        resetPasswordViewController.confirmPasswordText = validPassword
        resetPasswordViewController.resetPasswordButtonTapped(sender: UIButton())
        XCTAssertNotNil(resetPasswordViewController.alert)
        XCTAssertEqual(resetPasswordViewController.alert!.title, "Success")
    }
    
    func testShowError() throws {
        resetPasswordViewController.newPasswordText = validPassword
        resetPasswordViewController.confirmPasswordText = tooShortPassword
        resetPasswordViewController.resetPasswordButtonTapped(sender: UIButton())
        XCTAssertNil(resetPasswordViewController.alert)
    }
}
