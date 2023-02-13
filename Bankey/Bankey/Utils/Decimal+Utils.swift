//
//  Decimal+Utils.swift
//  Bankey
//
//  Created by Michael Gimara on 13/02/2023.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
