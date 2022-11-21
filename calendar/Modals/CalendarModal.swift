//
//  CalendarModal.swift
//  calendar
//
//  Created by Mathiyalagan S on 21/11/22.
//

import Foundation

struct Calendar : Decodable {
    let id: String
    let primary: Bool?
}

struct Event: Decodable {
    let id: String
    let summary: String
    let start: dateInfo
    let htmlLink: String
}

struct dateInfo: Decodable {
    let dateTime: String?
    let timeZone: String?
}
