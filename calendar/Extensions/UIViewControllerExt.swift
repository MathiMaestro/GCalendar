//
//  UIViewControllerExt.swift
//  calendar
//
//  Created by Mathiyalagan S on 20/11/22.
//

import UIKit

extension UIViewController {
    
    func presentCalendarAlertViewInMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = CalendarAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}

