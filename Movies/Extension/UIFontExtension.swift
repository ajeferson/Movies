//
//  UIFontExtension.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum Style: String {
        case black = "Black"
        case book = "Book"
        case heavy = "Heavy"
        case light = "Light"
        case medium = "Medium"
    }
    
    static func appFont(withStyle style: UIFont.Style, andSize size: CGFloat = 15) -> UIFont {
        return UIFont(name: "Avenir-\(style.rawValue)", size: size)!
    }
}

