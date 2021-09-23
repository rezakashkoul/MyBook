//
//  Extension.swift
//  My Book
//
//  Created by Reza Kashkoul on 6/31/1400 AP.
//

import UIKit
enum AssetsColor: String {
    case bookColor
    case borderColor
    case segmentColor
    case tabBarColor
}
extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
