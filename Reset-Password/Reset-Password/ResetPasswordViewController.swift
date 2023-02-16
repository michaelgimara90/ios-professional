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
        
        style()
        layout()
    }
}

extension ResetPasswordViewController {
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.delegate = self
        
        passwordStatusView.translatesAutoresizingMaskIntoConstraints = false
        passwordStatusView.layer.cornerRadius = 5
        passwordStatusView.clipsToBounds = true
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.delegate = self
        
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

extension ResetPasswordViewController {
    @objc func resetPasswordButtonTapped(sender: UIButton) {
    }
}

extension ResetPasswordViewController: PasswordTextFieldDelegate {
    func editingChanged(_ sender: PasswordTextField) {
        switch sender {
        case newPasswordTextField:
            passwordStatusView.updateDisplay(sender.textField.text ?? "")
        case confirmPasswordTextField:
            print("confirmPasswordTextField text: \(sender.textField.text ?? "")")
        default:
            break
        }
    }
}

