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
        case addTitle
        case okTitle
        case createTitle
    }

    enum Activities: String {
        case listTitle
        case noActivitiesTitle
        case placeholderTitle
        case title
        case createActivityTitle
        case dateStartTitle
        case dateFinishTitle
        case detailsTitle
    }

    enum Alerts: String {
        case errorTitle
        case cannotSaveActivityTitle
        case belongOneDayTitle
        case startDateBeforeTitle
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
