//
//  CalendarManager.swift
//  calendar
//
//  Created by Mathiyalagan S on 22/11/22.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

class CalendarManager {
    static let shared = CalendarManager()
    var selectedCalendar: Calendar?
    
    var calendarList: [Calendar]            = []
    var eventList: [String:[CalendarEvent]] = [:]
    var allEvents: [CalendarEvent]          = []
    
    func getCalendarList(completed: @escaping (Result<Bool,CalendarError>) -> ()) {
        guard let url = URL(string: CalendarAPI.getAPI(for: .calendarList)), let token = UserManager.shared.tokenDetail?.accessToken else {
            completed(.failure(.sessionExpired))
            return
        }
        NetworkManager.shared.makeRequest(url: url, httpMethod: .get, token: token) { [unowned self] result in
            switch result {
            case .success(let data):
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    guard let jsonDict = jsonObj as? [String:Any], let itemsDictData = jsonDict["items"] as? [[String: Any]], let itemsData = CalendarNetworkUtils.getData(from: itemsDictData) else {
                        completed(.failure(.invalidResponse))
                        return
                    }
                    self.calendarList       = try CalendarNetworkUtils.decoder.decode([Calendar].self, from: itemsData)
                    self.selectedCalendar   = self.calendarList.filter({$0.primary == true}).first
                    self.getEvents(for: selectedCalendar) { result in
                        switch result {
                        case .success(_):
                            completed(.success(true))
                        case .failure(let error):
                            completed(.failure(error))
                        }
                    }
                } catch {
                    completed(.failure(.invalidResponse))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    func getEvents(for calendar: Calendar?, completed: @escaping (Result<Bool,CalendarError>) -> ()) {
        guard let calendar, let url = URL(string: CalendarAPI.getAPI(for: .events(calendarId: calendar.id))), let token = UserManager.shared.tokenDetail?.accessToken else {
            completed(.failure(.sessionExpired))
            return
        }
        
        NetworkManager.shared.makeRequest(url: url, httpMethod: .get, token: token) { [unowned self] result in
            switch result {
            case .success(let data):
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    guard let jsonDict = jsonObj as? [String:Any], let itemsDictData = jsonDict["items"] as? [[String: Any]], let itemsData = CalendarNetworkUtils.getData(from: itemsDictData) else {
                        completed(.failure(.invalidResponse))
                        return
                    }
                    let events = try CalendarNetworkUtils.decoder.decode([CalendarEvent].self, from: itemsData)
                    self.prepareEvents(with: events)
                    completed(.success(true))
                } catch {
                    completed(.failure(.invalidResponse))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    private func prepareEvents(with events: [CalendarEvent]) {
        eventList = [:]
        allEvents = []
        for event in events {
            if let date = event.start.dateTime?.convertToDate()?.convertToShortString() {
                addSpotLightToEvent(event: event)
                if let _ = eventList[date] {
                    eventList[date]?.append(event)
                } else {
                    eventList[date] = [event]
                }
                self.allEvents.append(event)
            }
        }
    }
    
    private func addSpotLightToEvent(event: CalendarEvent) {
        deleteSpotLightEvent(event: event)
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: (UTType.jpeg.identifier as CFString) as String)
        attributeSet.title = event.summary

        let item = CSSearchableItem(uniqueIdentifier: "\(event.id)", domainIdentifier: "com.mathi.calendar", attributeSet: attributeSet)
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteSpotLightEvent(event: CalendarEvent) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(event.id)"]) { error in
            if let error = error {
                print("Deindexing error: \(error.localizedDescription)")
            }
        }
    }
    
    func getEvent(for id: String) -> CalendarEvent? {
        return allEvents.filter({$0.id == id}).first
    }
}
