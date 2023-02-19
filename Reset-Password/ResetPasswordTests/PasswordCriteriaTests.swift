//
//  PasswordCriteriaTests.swift
//  ResetPasswordTests
//
//  Created by Michael Gimara on 19/02/2023.
//

import XCTest

@testable import Reset_Password

class PasswordLengthCriteriaTests: XCTestCase {
    
    func testPasswordLengthShortNotMet() throws {
        XCTAssertFalse(PasswordCriteria.lengthCriteriaMet("1234567")) // 7
    }
    
    func testPasswordLengthLongNotMet() throws {
        XCTAssertFalse(PasswordCriteria.lengthCriteriaMet("012345678901234567890123456789012")) // 33
    }
    
    func testPasswordLengthShortMet() throws {
        XCTAssertTrue(PasswordCriteria.lengthCriteriaMet("12345678")) // 8
    }
    
    func testPasswordLengthLongMet() throws {
        XCTAssertTrue(PasswordCriteria.lengthCriteriaMet("01234567890123456789012345678901")) // 32
    }
}

class PasswordNoSpaceCriteriaTests: XCTestCase {
    
    func testPasswordNoSpaceNotMet() throws {
        XCTAssertFalse(PasswordCriteria.noSpaceCriteriaMet("1 23"))
    }
    
    func testPasswordNoSpaceMet() throws {
        XCTAssertTrue(PasswordCriteria.noSpaceCriteriaMet("123"))
    }
}

class PasswordLenghtAndNoSpaceCriteriaTests: XCTestCase {
    
    func testPasswordLengthAndNoSpaceNotMet() throws {
        XCTAssertFalse(PasswordCriteria.lengthAndNoSpaceCriteriaMet("1 2345"))
    }
    
    func testPasswordLengthAndNoSpaceMet() throws {
        XCTAssertTrue(PasswordCriteria.lengthAndNoSpaceCriteriaMet("1234567890"))
    }
}

class PasswordUppercaseCriteriaTests: XCTestCase {
    
    func testPasswordUppercaseNotMet() throws {
        XCTAssertFalse(PasswordCriteria.uppercaseLetterCriteriaMet("abc"))
    }
    
    func testPasswordUppercaseMet() throws {
        XCTAssertTrue(PasswordCriteria.uppercaseLetterCriteriaMet("Abc"))
    }
}

class PasswordLowercaseCriteriaTests: XCTestCase {
    
    func testPasswordLowercaseNotMet() throws {
        XCTAssertFalse(PasswordCriteria.lowercaseLetterCriteriaMet("ABC"))
    }
    
    func testPasswordLowercaseMet() throws {
        XCTAssertTrue(PasswordCriteria.uppercaseLetterCriteriaMet("aBC"))
    }
}

class PasswordDigitCriteriaTests: XCTestCase {
    
    func testPasswordDigitNotMet() throws {
        XCTAssertFalse(PasswordCriteria.digitCriteriaMet("abc"))
    }
    
    func testPasswordDigitMet() throws {
        XCTAssertTrue(PasswordCriteria.digitCriteriaMet("abc1"))
    }
}

class PasswordSpecialCharacterCriteriaTests: XCTestCase {
    
    func testPasswordSpecialCharacterNotMet() throws {
        XCTAssertFalse(PasswordCriteria.specialCharacterCriteriaMet("123"))
    }
    
    func testPasswordSpecialCharacterMet() throws {
        XCTAssertTrue(PasswordCriteria.specialCharacterCriteriaMet("123!"))
    }
}
