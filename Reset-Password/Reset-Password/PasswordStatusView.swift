//
//  PasswordStatusView.swift
//  Reset-Password
//
//  Created by Michael Gimara on 15/02/2023.
//

import UIKit

class PasswordStatusView: UIView {
    
    let stackView = UIStackView()
    
    let criteriaLabel = UILabel()
    
    let lengthAndNoSpaceCriteriaView = PasswordCriteriaView(text: "8-32 characters (no spaces)")
    let uppercaseLetterCriteriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")
    let lowercaseLetterCriteriaView = PasswordCriteriaView(text: "lowercase letter (a-z)")
    let digitCriteriaView = PasswordCriteriaView(text: "digit (0-9)")
    let specialCharacterCriteriaView = PasswordCriteriaView(text: "special character (e.g. !@#$%^)")
    
    var shouldResetCriteria: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension PasswordStatusView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemFill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        
        criteriaLabel.translatesAutoresizingMaskIntoConstraints = false
        criteriaLabel.numberOfLines = 0
        criteriaLabel.lineBreakMode = .byWordWrapping
        criteriaLabel.attributedText = makeCriteriaMessage()
        
        lengthAndNoSpaceCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        uppercaseLetterCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        lowercaseLetterCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        digitCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        specialCharacterCriteriaView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        stackView.addArrangedSubview(lengthAndNoSpaceCriteriaView)
        stackView.addArrangedSubview(criteriaLabel)
        stackView.addArrangedSubview(uppercaseLetterCriteriaView)
        stackView.addArrangedSubview(lowercaseLetterCriteriaView)
        stackView.addArrangedSubview(digitCriteriaView)
        stackView.addArrangedSubview(specialCharacterCriteriaView)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2)
        ])
    }
    
    private func makeCriteriaMessage() -> NSAttributedString {
        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        plainTextAttributes[.foregroundColor] = UIColor.secondaryLabel
        
        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        boldTextAttributes[.foregroundColor] = UIColor.label
        
        let attributedText = NSMutableAttributedString(string: "Use at least", attributes: plainTextAttributes)
        attributedText.append(NSAttributedString(string: " 3 of the 4 ", attributes: boldTextAttributes))
        attributedText.append(NSAttributedString(string: "criteria when setting your password:", attributes: plainTextAttributes))
        
        return attributedText
    }
}

// MARK: Update Display
extension PasswordStatusView {
    func validate(_ text: String) -> Bool {
        // Check for 3 of 4 criteria
        let metCriteria = [
            PasswordCriteria.uppercaseLetterCriteriaMet(text),
            PasswordCriteria.lowercaseLetterCriteriaMet(text),
            PasswordCriteria.digitCriteriaMet(text),
            PasswordCriteria.specialCharacterCriteriaMet(text)
        ].filter { $0 }
        
        return PasswordCriteria.lengthAndNoSpaceCriteriaMet(text) && metCriteria.count >= 3
    }
    
    func reset() {
        lengthAndNoSpaceCriteriaView.reset()
        uppercaseLetterCriteriaView.reset()
        lowercaseLetterCriteriaView.reset()
        digitCriteriaView.reset()
        specialCharacterCriteriaView.reset()
    }
    
    func updateDisplay(_ text: String) {
        updateLengthAndNoSpaceCriteriaView(forText: text)
        updateUppercaseLetterCriteriaView(forText: text)
        updateLowercaseLetterCriteriaView(forText: text)
        updateDigitCriteriaView(forText: text)
        updateSpecialCharacterCriteriaView(forText: text)
    }
    
    private func updateLengthAndNoSpaceCriteriaView(forText text: String) {
        let isLengthAndNoSpaceCriteriaMet = PasswordCriteria.lengthAndNoSpaceCriteriaMet(text)
        
        if shouldResetCriteria {
            isLengthAndNoSpaceCriteriaMet ? lengthAndNoSpaceCriteriaView.isCriteriaMet = true : lengthAndNoSpaceCriteriaView.reset()
        } else {
            lengthAndNoSpaceCriteriaView.isCriteriaMet = isLengthAndNoSpaceCriteriaMet
        }
    }
    
    private func updateUppercaseLetterCriteriaView(forText text: String) {
        let isUppercaseLetterCriteriaMet = PasswordCriteria.uppercaseLetterCriteriaMet(text)
        
        if shouldResetCriteria {
            isUppercaseLetterCriteriaMet ? uppercaseLetterCriteriaView.isCriteriaMet = true : uppercaseLetterCriteriaView.reset()
        } else {
            uppercaseLetterCriteriaView.isCriteriaMet = isUppercaseLetterCriteriaMet
        }
    }
    
    private func updateLowercaseLetterCriteriaView(forText text: String) {
        let isLowercaseLetterCriteriaMet = PasswordCriteria.lowercaseLetterCriteriaMet(text)
        
        if shouldResetCriteria {
            isLowercaseLetterCriteriaMet ? lowercaseLetterCriteriaView.isCriteriaMet = true : lowercaseLetterCriteriaView.reset()
        } else {
            lowercaseLetterCriteriaView.isCriteriaMet = isLowercaseLetterCriteriaMet
        }
    }
    
    private func updateDigitCriteriaView(forText text: String) {
        let isDigitCriteriaMet = PasswordCriteria.digitCriteriaMet(text)
        
        if shouldResetCriteria {
            isDigitCriteriaMet ? digitCriteriaView.isCriteriaMet = true : digitCriteriaView.reset()
        } else {
            digitCriteriaView.isCriteriaMet = isDigitCriteriaMet
        }
    }
    
    private func updateSpecialCharacterCriteriaView(forText text: String) {
        let isSpecialCharacterCriteriaMet = PasswordCriteria.specialCharacterCriteriaMet(text)
        
        if shouldResetCriteria {
            isSpecialCharacterCriteriaMet ? specialCharacterCriteriaView.isCriteriaMet = true : specialCharacterCriteriaView.reset()
        } else {
            specialCharacterCriteriaView.isCriteriaMet = isSpecialCharacterCriteriaMet
        }
    }
}
