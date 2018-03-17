//
//  UIViewExtension.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit

extension UIView {
    
    var isVisible: Bool {
        get {
            return !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
    
}
