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
    
    let lengthCriteriaView = PasswordCriteriaView(text: "8-32 characters (no spaces)")
    let uppercaseCriterialView = PasswordCriteriaView(text: "uppercase letter (A-Z)")
    let lowercaseCriterialView = PasswordCriteriaView(text: "lowercase letter (a-z)")
    let digitCriteriaView = PasswordCriteriaView(text: "digit (0-9)")
    let specialCharacterCriteriaView = PasswordCriteriaView(text: "special character (e.g. !@#$%^)")
    
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
        
        lengthCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        uppercaseCriterialView.translatesAutoresizingMaskIntoConstraints = false
        lowercaseCriterialView.translatesAutoresizingMaskIntoConstraints = false
        digitCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        specialCharacterCriteriaView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        stackView.addArrangedSubview(lengthCriteriaView)
        stackView.addArrangedSubview(criteriaLabel)
        stackView.addArrangedSubview(uppercaseCriterialView)
        stackView.addArrangedSubview(lowercaseCriterialView)
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