//
//  CalendarError.swift
//  calendar
//
//  Created by Mathiyalagan S on 20/11/22.
//

import Foundation

enum CalendarError : String, Error {
    case sessionExpired     = "Your session has expired. Kindly login again!"
    case networkConnection  = "Kindly check your internet connection."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case unknown            = "Something went wrong! Please try again."
    case invalidData        = "The data received from the server is invalid. Please try again."
}
