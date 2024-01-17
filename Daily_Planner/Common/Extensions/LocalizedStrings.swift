//
//  LocalizedStrings.swift
//  Daily_Planner
//
//  Created by Daniil on 17.01.2024.
//

import Foundation

extension String {

    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    enum Common: String {
        case backTitle
    }

}

prefix operator ^
prefix func ^ <Type: RawRepresentable>(_ value: Type) -> String {
    if let raw = value.rawValue as? String {
        let key = raw.capitalizeFirstLetter()
        return NSLocalizedString(key, comment: "")
    }
    return ""
}
