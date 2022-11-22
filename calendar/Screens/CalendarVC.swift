//
//  CalendarVC.swift
//  calendar
//
//  Created by Mathiyalagan S on 21/11/22.
//

import UIKit

class CalendarVC: UIViewController {
    
    private let calendarView : UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar   = .current
        calendarView.locale     = .current
        calendarView.fontDesign = .rounded
        return calendarView
    }()
    
    var spotLightEventId : String?
    
    init(error: CalendarError? = nil, eventId: String? = nil) {
        self.spotLightEventId = eventId
        super.init(nibName: nil, bundle: nil)
        if error != nil {
            presentCalendarAlertViewInMainThread(title: ErrorTitles.oopsTitle, message: ErrorDescriptions.calendarFetchMessage, buttonTitle: ErrorButtonTitles.OkButtonTitle)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        
        UserManager.shared.isFirstTime = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let eventId = UserManager.shared.spotLightEventId {
            showSpotLightEvent(spotLightEventId: eventId)
            UserManager.shared.spotLightEventId = nil
        } else if let spotLightEventId {
            showSpotLightEvent(spotLightEventId: spotLightEventId)
            self.spotLightEventId = nil
        }
    }
    
    private func showSpotLightEvent(spotLightEventId: String) {
        if let event = CalendarManager.shared.getEvent(for: spotLightEventId) {
            showWebView(urlString: event.htmlLink)
        }
    }
}

extension CalendarVC {
    
    private func configureNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Calendar"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(signOut))
    }
    
    @objc func signOut() {
        UserManager.shared.signOut()
        goToLoginView()
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
        configureSelectionBehavior()
    }
    
    private func configureSelectionBehavior() {
        let selection                   = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior  = selection
    }
    
    private func removeSelectionBehavior() {
        calendarView.selectionBehavior  = .none
    }
    
    private func goToLoginView() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.currentUIWindow() else { return }
            window.rootViewController = UINavigationController(rootViewController: LoginVC())
        }
    }
}

extension CalendarVC: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let date = dateComponents?.date?.convertToShortString(), let event = CalendarManager.shared.eventList[date]?.first else {
            return
        }
        showWebView(urlString: event.htmlLink)
        removeSelectionBehavior()
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let date = dateComponents.date?.convertToShortString() {
            if let _ = CalendarManager.shared.eventList[date]?.first {
                return .image(UIImage(systemName: "note.text"), color: .systemGreen, size: .large)
            }
        }
        return nil
    }
    
    private func showWebView(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        showWebView(with: url)
    }
    
    private func showWebView(with url: URL) {
        DispatchQueue.main.async {
            let webVC = UINavigationController(rootViewController: WebVC(url: url, delegate: self))
            self.present(webVC, animated: true)
        }
    }
}

extension CalendarVC {
    func helloWorld(id: String) {
        print(id)
        print("hello world")
    }
}

extension CalendarVC: WebViewToCalendarViewProtocol {
    func viewDismissed() {
        configureSelectionBehavior()
    }
}
