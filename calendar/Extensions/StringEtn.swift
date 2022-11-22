//
//  StringEtn.swift
//  calendar
//
//  Created by Mathiyalagan S on 22/11/22.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.date(from: self)
    }
}
