//
//  extension + Formatter.swift
//  report
//
//  Created by osa on 28.06.2021.
//

import Foundation

extension Formatter {
    static let separator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}

extension Numeric {
    var formatWithSeparator: String {
        Formatter.separator.string(for: self) ?? ""
    }
}
