//
//  CalendarAPI.swift
//  calendar
//
//  Created by Mathiyalagan S on 21/11/22.
//

import Foundation

enum APIType {
    case calendarList
    case events(calendarId: String)
}

enum CalendarAPI {
    static let baseURL = "https://www.googleapis.com"
    
    static func getAPI(for type: APIType) -> String {
        switch type {
        case .calendarList:
            return baseURL + "/calendar/v3/users/me/calendarList"
        case .events(let calendarId):
            return baseURL + "/calendar/v3/calendars/\(calendarId)/events"
        }
    }
}
