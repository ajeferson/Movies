//
//  DefaultNavigationController.swift
//  Movies
//
//  Created by Alan Jeferson on 17/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit

class DefaultNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.appGreen
        navigationBar.tintColor = UIColor.white.withAlphaComponent(0.8)
        navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.appFont(withStyle: .black)
        ]
        navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.appFont(withStyle: .black, andSize: 24)
        ]
        
    }
    
}
