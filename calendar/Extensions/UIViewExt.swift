//
//  UIViewExt.swift
//  calendar
//
//  Created by Mathiyalagan S on 21/11/22.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
