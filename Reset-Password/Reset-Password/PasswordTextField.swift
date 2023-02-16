//
//  PasswordTextField.swift
//  Reset-Password
//
//  Created by Michael Gimara on 15/02/2023.
//

import UIKit

protocol PasswordTextFieldDelegate: AnyObject {
    func editingChanged(_ sender: PasswordTextField)
}

class PasswordTextField: UIView {
    
    let lockImageView = UIImageView(image: UIImage(systemName: "lock.fill"))
    let textField = UITextField()
    let eyeButton = UIButton(type: .custom)
    let dividerView = UIView()
    let errorMessageLabel = UILabel()
    
    let placeholderText: String
    
    weak var delegate: PasswordTextFieldDelegate?
    
    init(placeholder: String) {
        self.placeholderText = placeholder
        
        super.init(frame: .zero)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 60)
    }
}

extension PasswordTextField {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.keyboardType = .asciiCapable
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
            ]
        )
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash.circle"), for: .selected)
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = .separator
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.font = .preferredFont(forTextStyle: .footnote)
        errorMessageLabel.text = "Your password must meet the requirements below."
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.lineBreakMode = .byWordWrapping
        errorMessageLabel.isHidden = true
    }
    
    func layout() {
        addSubview(lockImageView)
        addSubview(textField)
        addSubview(eyeButton)
        addSubview(dividerView)
        addSubview(errorMessageLabel)
        
        // LockImageView
        NSLayoutConstraint.activate([
            lockImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            lockImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        // TextField
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: lockImageView.trailingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 3)
        ])
        
        // EyeButton
        NSLayoutConstraint.activate([
            eyeButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // DividerView
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 1),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // ErrorMessageLabel
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 4),
            errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // CH/CR -> Content Hugging / Compression Resistance
        lockImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        eyeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

// MARK: Actions
extension PasswordTextField {
    @objc func textFieldEditingChanged(sender: UITextField) {
        delegate?.editingChanged(self)
    }
    
    @objc func eyeButtonTapped(sender: UIButton) {
        textField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }
}

// MARK: UITextFieldDelegate
extension PasswordTextField: UITextFieldDelegate {
    
    // return false to disallow editing
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    // return true to allow editing to stop and to resign first responder status.
    // return false to disallow the editing session to end
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // if implemented, called in place of textFieldDidEndEditing: ?
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // detect - keypress
    // return false to not change text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    // called when 'clear' button pressed
    // return false to ignore
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    // called when 'return' key pressed
    // return false to ignore
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true) // resign first responder
        return true
    }
}
