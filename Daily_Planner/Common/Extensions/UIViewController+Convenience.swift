//
//  UIViewController+Convenience.swift
//  Daily_Planner
//
//  Created by Daniil on 17.01.2024.
//

import UIKit

extension UIViewController {

    func applyDefaultSettings(backgroundColor color: UIColor = .appWhite) {
        view.backgroundColor = color
        navigationItem.backButtonTitle = ^String.Common.backTitle
    }

}
