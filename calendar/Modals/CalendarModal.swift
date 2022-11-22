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

struct CalendarEvent: Decodable {
    let id: String
    let summary: String
    let start: EventDateInfo
    let htmlLink: String
}

struct EventDateInfo: Decodable {
    let dateTime: String?
    let timeZone: String?
}
