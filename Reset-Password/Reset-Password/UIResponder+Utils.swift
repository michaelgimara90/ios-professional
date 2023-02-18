//
//  UIResponder+Utils.swift
//  Reset-Password
//
//  Created by Michael Gimara on 19/02/2023.
//

import UIKit

extension UIResponder {
    private static weak var _currentFirstResponder: UIResponder? = nil
    
    public static var firstResponder: UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder
    }
    
    @objc private func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}
