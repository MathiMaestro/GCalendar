//
//  CalendarLoadingVC.swift
//  calendar
//
//  Created by Mathiyalagan S on 20/11/22.
//

import UIKit

class CalendarLoadingVC: UIViewController {

    private var containerView: UIView?

    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        guard let containerView else { return }
        view.addSubview(containerView)
        
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView?.removeFromSuperview()
            self.containerView = nil
        }
    }

}

