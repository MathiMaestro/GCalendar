//
//  LoginVC.swift
//  calendar
//
//  Created by Mathiyalagan S on 20/11/22.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class LoginVC: UIViewController {

    private let loginButton : GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(isSessionEnd: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        if isSessionEnd {
            presentCalendarAlertViewInMainThread(title: ErrorTitles.oopsTitle, message: ErrorDescriptions.sessionExpireMessage, buttonTitle: ErrorButtonTitles.OkButtonTitle)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        logout()
        updateUI()
        configureActions()
    }
    
    func logout() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    deinit {
        print("LoginVC deinitalized")
    }
}

extension LoginVC {
    private func updateUI() {
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 120),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureActions() {
        loginButton.addTarget(self, action: #selector(signinTapped), for: .touchUpInside)
    }
}

extension LoginVC {
    
    @objc func signinTapped() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self, hint: nil, additionalScopes: ["https://www.googleapis.com/auth/calendar.readonly","https://www.googleapis.com/auth/calendar"]) { [unowned self] user, error in
            guard error == nil, let authentication = user?.authentication, let idToken = authentication.idToken else {
                presentCalendarAlertViewInMainThread(title: ErrorTitles.loginErrorTitle, message: ErrorDescriptions.loginErrorMessage, buttonTitle: ErrorButtonTitles.OkButtonTitle)
                return
            }
            UserManager.shared.tokenDetail = TokenDetail(idToken: idToken, accessToken: authentication.accessToken)
            self.showLauncherView()
        }
    }
    
    private func showLauncherView() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.currentUIWindow() else { return }
            window.rootViewController = UINavigationController(rootViewController: LauncherVC())
        }
    }
}
