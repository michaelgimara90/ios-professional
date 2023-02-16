//
//  ResetPasswordViewController.swift
//  Reset-Password
//
//  Created by Michael Gimara on 15/02/2023.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    let stackView = UIStackView()
    let newPasswordTextField = PasswordTextField(placeholder: "New password")
    let passwordStatusView = PasswordStatusView()
    let confirmPasswordTextField = PasswordTextField(placeholder: "Re-enter new password")
    let resetPasswordButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        style()
        layout()
    }
}

extension ResetPasswordViewController {
    func setup() {
        setupDismissKeyboardGesture()
        setupNewPasswordTextField()
        setupConfirmPasswordTextField()
    }
    
    func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    func setupNewPasswordTextField() {
        newPasswordTextField.delegate = self
        newPasswordTextField.validation = { text in
            guard let text, !text.isEmpty else {
                self.passwordStatusView.reset()
                return (isValid: false, errorMessage: "Enter your password")
            }
            
            let validCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&:?(),./\\"
            let invalidSet = CharacterSet(charactersIn: validCharacters).inverted
            guard text.rangeOfCharacter(from: invalidSet) == nil else {
                self.passwordStatusView.reset()
                return (isValid: false, errorMessage: "Enter valid special characters !@#$%^&:?(),./\\ with no spaces")
            }
            
            self.passwordStatusView.updateDisplay(text)
            if !self.passwordStatusView.validate(text) {
                return (isValid: false, errorMessage: "Your password must meet the requirements below")
            }
            
            return (isValid: true, errorMessage: "")
        }
    }
    
    func setupConfirmPasswordTextField() {
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.validation = { text in
            guard let text, !text.isEmpty else {
                return (isValid: false, errorMessage: "Enter your password")
            }
            guard text == self.newPasswordTextField.text else {
                return (isValid: false, errorMessage: "Passwords do not match")
            }
            return (isValid: true, errorMessage: "")
        }
    }
    
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordStatusView.translatesAutoresizingMaskIntoConstraints = false
        passwordStatusView.layer.cornerRadius = 5
        passwordStatusView.clipsToBounds = true
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.configuration = .filled()
        resetPasswordButton.setTitle("Reset password", for: .normal)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
    }
    
    func layout() {
        stackView.addArrangedSubview(newPasswordTextField)
        stackView.addArrangedSubview(passwordStatusView)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(resetPasswordButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: Actions
extension ResetPasswordViewController {
    @objc func resetPasswordButtonTapped(sender: UIButton) {
        
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true) // resign first responder
    }
}

// MARK: PasswordTextFieldDelegate
extension ResetPasswordViewController: PasswordTextFieldDelegate {
    func editingChanged(_ sender: PasswordTextField) {
        if sender == newPasswordTextField {
            passwordStatusView.updateDisplay(sender.text ?? "")
        }
    }
    
    func didEndEditing(_ sender: PasswordTextField) {
        switch sender {
        case newPasswordTextField:
            passwordStatusView.shouldResetCriteria = false
            newPasswordTextField.validate()
        case confirmPasswordTextField:
            confirmPasswordTextField.validate()
        default:
            break
        }
    }
}
