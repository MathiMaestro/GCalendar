//
//  DateEtn.swift
//  calendar
//
//  Created by Mathiyalagan S on 22/11/22.
//

import Foundation

extension Date {
    
    func convertToShortString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle                     = .none
        dateFormatter.dateStyle                     = .short
        return dateFormatter.string(from: self)
    }
}
