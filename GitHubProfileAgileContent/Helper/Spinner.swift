//
//  Spinner.swift
//  GitHubProfileAgileContent
//
//  Created by Wellington Ruan da Silva on 05/02/25.
//

import UIKit

final class Spinner {
    
    fileprivate static var activityIndicator: UIActivityIndicatorView?
    
    class func start(from view: UIView,
                     style: UIActivityIndicatorView.Style = .large,
                     backgroundColor: UIColor = UIColor(white: 0, alpha: 0.6),
                     baseColor: UIColor = UIColor.white) {
        
        guard Spinner.activityIndicator == nil else { return }
        
        let spinner = UIActivityIndicatorView(style: style)
        spinner.backgroundColor = backgroundColor
        spinner.color = baseColor
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        spinner.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        Spinner.activityIndicator = spinner
        Spinner.activityIndicator?.startAnimating()
    }
    
    class func stop() {
        Spinner.activityIndicator?.stopAnimating()
        Spinner.activityIndicator?.removeFromSuperview()
        Spinner.activityIndicator = nil
    }
}
