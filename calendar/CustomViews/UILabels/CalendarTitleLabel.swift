//
//  CalendarTitleLabel.swift
//  calendar
//
//  Created by Mathiyalagan S on 20/11/22.
//

import UIKit

class CalendarTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureProperties()
    }

    convenience init(textColor: UIColor,textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        set(textColor: textColor, textAlignment: textAlignment)
    }
    
    private func configureProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        
        font                        = .preferredFont(forTextStyle: .title3)
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.9
        lineBreakMode               = .byTruncatingTail
    }
    
    private func set(textColor: UIColor,textAlignment: NSTextAlignment) {
        self.textColor      = textColor
        self.textAlignment  = textAlignment
        self.font           = font
    }
    
    func setTitle(with title: String) {
        self.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
