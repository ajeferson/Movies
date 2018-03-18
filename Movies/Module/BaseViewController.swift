//
//  BaseViewController.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func presentAlert(withTitle title : String, message : String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentErrorAlert(withError error: AppError) {
        presentAlert(withTitle: "Error", message: error.rawValue)
    }
    
}

@objc protocol View {
    @objc optional func initView()
    @objc optional func initViewModel()
}
