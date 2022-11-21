//
//  CalendarVC.swift
//  calendar
//
//  Created by Mathiyalagan S on 21/11/22.
//

import UIKit

class CalendarVC: UIViewController {
    
    private var calendarList : [Calendar] = []
    private var selectedCalendar : Calendar? = nil
    private var eventList: [Event] = []
    
    private let calendarView : UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar   = .current
        calendarView.locale     = .current
        calendarView.fontDesign = .rounded
        return calendarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getPrimaryCalendar()
    }
    
    private func configureUI() {
        view.addSubview(calendarView)
        
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        calendarView.delegate = self
    }
    
    private func getPrimaryCalendar() {
        guard let url = URL(string: CalendarAPI.getAPI(for: .calendarList)), let token = UserManager.shared.tokenDetail?.accessToken else {
            presentCalendarAlertViewInMainThread(title: ErrorTitles.oopsTitle, message: ErrorDescriptions.tokenMessage, buttonTitle: ErrorButtonTitles.OkButtonTitle)
            return
        }
        NetworkManager.shared.makeRequest(url: url, httpMethod: .get, token: token) { [unowned self] result in
            var responseError: CalendarError? = nil
            switch result {
            case .success(let data):
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    guard let jsonDict = jsonObj as? [String:Any], let itemsDictData = jsonDict["items"] as? [[String: Any]], let itemsData = CalendarNetworkUtils.getData(from: itemsDictData) else {
                        responseError = .invalidResponse
                        return
                    }
                    self.calendarList       = try CalendarNetworkUtils.decoder.decode([Calendar].self, from: itemsData)
                    self.selectedCalendar   = self.calendarList.filter({$0.primary == true}).first
                    self.getEvents(for: selectedCalendar)
                } catch {
                    responseError = .invalidResponse
                }
            case .failure(let error):
                responseError = error
            }
            if let responseError {
                self.presentCalendarAlertViewInMainThread(title: ErrorTitles.oopsTitle, message: responseError.rawValue, buttonTitle: ErrorButtonTitles.OkButtonTitle)
            }
        }
    }
    
    private func getEvents(for calendar: Calendar?) {
        guard let calendar, let url = URL(string: CalendarAPI.getAPI(for: .events(calendarId: calendar.id))), let token = UserManager.shared.tokenDetail?.accessToken else {
            presentCalendarAlertViewInMainThread(title: ErrorTitles.oopsTitle, message: ErrorDescriptions.tokenMessage, buttonTitle: ErrorButtonTitles.OkButtonTitle)
            return
        }
        
        NetworkManager.shared.makeRequest(url: url, httpMethod: .get, token: token) { [unowned self] result in
            var responseError: CalendarError? = nil
            switch result {
            case .success(let data):
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    guard let jsonDict = jsonObj as? [String:Any], let itemsDictData = jsonDict["items"] as? [[String: Any]], let itemsData = CalendarNetworkUtils.getData(from: itemsDictData) else {
                        responseError = .invalidResponse
                        return
                    }
                    self.eventList = try CalendarNetworkUtils.decoder.decode([Event].self, from: itemsData)
                    print(eventList)
                } catch {
                    responseError = .invalidResponse
                }
            case .failure(let error):
                responseError = error
            }
            if let responseError {
                self.presentCalendarAlertViewInMainThread(title: ErrorTitles.oopsTitle, message: responseError.rawValue, buttonTitle: ErrorButtonTitles.OkButtonTitle)
            }
        }
    }
    
    private func updateEvents() {
        
    }
}

extension CalendarVC: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
}
