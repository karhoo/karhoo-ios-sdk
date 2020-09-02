//
//  AuthRequestsTesterViewController.swift
//  Client
//
//  Created by Tiziano Bruni on 04/03/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

enum AuthRequestType: String {
    case login = "Login"
    case revoke = "Revoke"
    case adyen = "Adyen"
}

class AuthRequestsTesterViewController: UIViewController {
    
    var responseLabelTitle: UILabel!
    var responseLabel: UILabel!
    var requestType: AuthRequestType
    
    init(requestType: AuthRequestType) {
        self.requestType = requestType
        super.init(nibName: nil, bundle: nil)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        
        responseLabelTitle = UILabel()
        responseLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        responseLabelTitle.text = "Request response"
        responseLabelTitle.textAlignment = .center
        responseLabelTitle.font = UIFont.boldSystemFont(ofSize: 22.0)
        view.addSubview(responseLabelTitle)
        
        _ = [responseLabelTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
             responseLabelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             responseLabelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             responseLabelTitle.heightAnchor.constraint(equalToConstant: 25.0)].map { $0.isActive = true }
        
        responseLabel = UILabel()
        responseLabel.translatesAutoresizingMaskIntoConstraints = false
        responseLabel.text = "Waiting for response..."
        responseLabel.font = UIFont.systemFont(ofSize: 18.0)
        responseLabel.numberOfLines = 0
        view.addSubview(responseLabel)
        
        _ = [responseLabel.topAnchor.constraint(equalTo: responseLabelTitle.bottomAnchor, constant: 20.0),
             responseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
             responseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
             responseLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
        
        performRequest()
    }
    
    private func performRequest() {
        switch requestType {
        case .login:
            login()
        case .revoke:
            revoke()
        case .adyen:
            adyenLogin()
        }
    }
    
    private func login() {
        Karhoo.getAuthService().login(token: "").execute(callback: { [weak self] result in
            if result.isSuccess() {
                self?.responseLabel.textColor = .green
                let output = """
                Success!
                Payload: \(result.successValue().debugDescription)
                """
                self?.responseLabel.text = output
            } else {
                let output = """
                Fail!
                Payload: \(result.errorValue().debugDescription)
                """
                self?.responseLabel.textColor = .red
                self?.responseLabel.text = output
            }
        })
    }
        
    private func revoke() {
        Karhoo.getAuthService().revoke().execute(callback: { [weak self] result in
            if result.isSuccess() {
                self?.responseLabel.textColor = .green
                self?.responseLabel.text = "Success: \(result.isSuccess())"
            } else {
                self?.responseLabel.textColor = .red
                self?.responseLabel.text = "Failed\nError: \(String(describing: result.errorValue().debugDescription))"
            }
        })
    }
    
    
    private func adyenLogin() {
        Karhoo.getUserService().login(userLogin: .init(username: "", password: "")).execute(callback: { [weak self] result in
            if result.isSuccess() {
                self?.responseLabel.textColor = .green
                self?.responseLabel.text = "Success: \(result.isSuccess())"
                self?.adyen()
            } else {
                self?.responseLabel.textColor = .red
                self?.responseLabel.text = "Failed\nError: \(String(describing: result.errorValue().debugDescription))"
            }
        })
    }
    
    private func adyen() {
        let payload = PaymentsDetailsRequestPayload(transactionID: "123")
        Karhoo.getPaymentService().getAdyenPaymentDetails(paymentDetails: payload).execute(callback: { [weak self] result in
            if result.isSuccess() {
                self?.responseLabel.textColor = .green
                let output = """
                Success!
                Payload: \(result.successValue().debugDescription)
                """
                self?.responseLabel.text = output
            } else {
                let output = """
                Fail!
                Payload: \(result.errorValue().debugDescription)
                """
                self?.responseLabel.textColor = .red
                self?.responseLabel.text = output
            }
        })
    }
}
