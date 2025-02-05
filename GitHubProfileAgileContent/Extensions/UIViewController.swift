//
//  UIViewController.swift
//  GitHubProfileAgileContent
//
//  Created by Wellington Ruan da Silva on 05/02/25.
//

import UIKit

extension UIViewController{
    
    func showAlert(title: String, message: String, type: UIAlertController.Style = .alert, buttonMessage: String = "Ok", action: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message:
            "User not found. Please enter another name", preferredStyle: type)
        if let action = action {
            alertController.addAction(action)
        } else {
            alertController.addAction(UIAlertAction(title: buttonMessage, style: .default, handler: { (_) in }))
        }
        alertController.view.layoutIfNeeded()
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
