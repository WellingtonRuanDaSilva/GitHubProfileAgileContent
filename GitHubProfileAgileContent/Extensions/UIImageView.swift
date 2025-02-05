//
//  UIImageView.swift
//  GitHubProfileAgileContent
//
//  Created by Wellington Ruan da Silva on 05/02/25.
//

import UIKit

extension UIImageView {

    func round() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
