//
//  PasswordCriteria.swift
//  Reset-Password
//
//  Created by Michael Gimara on 16/02/2023.
//

import Foundation

struct PasswordCriteria {
    
    // Length And No Space
    static func lengthAndNoSpaceCriteriaMet(_ text: String) -> Bool {
        lengthCriteriaMet(text) && noSpaceCriteriaMet(text)
    }
    
    private static func lengthCriteriaMet(_ text: String) -> Bool {
        text.count >= 8 && text.count <= 32
    }
    
    private static func noSpaceCriteriaMet(_ text: String) -> Bool {
        text.rangeOfCharacter(from: .whitespaces) == nil
    }
    
    // Uppercase Letter
    static func uppercaseLetterCriteriaMet(_ text: String) -> Bool {
        text.range(of: "[A-Z]+", options: .regularExpression) != nil
    }
    
    // Lowercase Letter
    static func lowercaseLetterCriteriaMet(_ text: String) -> Bool {
        text.range(of: "[a-z]+", options: .regularExpression) != nil
    }
    
    // Digit
    static func digitCriteriaMet(_ text: String) -> Bool {
        text.range(of: "[0-9]+", options: .regularExpression) != nil
    }
    
    // Special Character
    static func specialCharacterCriteriaMet(_ text: String) -> Bool {
        text.range(of: "[!@#$%^&:?(),./\\\\]+", options: .regularExpression) != nil
    }
}
