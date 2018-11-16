//
//  AuthorizationViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 22/10/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthorizationViewController: UIViewController {
    private let activityIndicator = ActivityIndicator()
    private let keychainController = KeychainController()
    private var calledByAppManager: Bool = true
    
    lazy private var emailTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите адрес электронной почты"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.textAlignment = .center
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        return textField
    }()
    
    lazy private var passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите свой пароль"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.isSecureTextEntry = true
        textField.textAlignment = .center
        
        return textField
    }()
    
    lazy private var signUpButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(signUp(sender:)), for: UIControl.Event.touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
        
        return button
    }()
    
    lazy private var loginButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(login(sender:)), for: UIControl.Event.touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
        
        return button
    }()
    
    lazy private var resetPasswordButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сбросить пароль", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(resetPassword(sender:)), for: UIControl.Event.touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if keychainController.keychainItemExists() {
            view.backgroundColor = .white
            loginViaKeychain()
        } else {
            view.backgroundColor = .orange
            setupLayout()
        }
    }
    
    func configure() {
        self.calledByAppManager = false
    }
    
    private func setupLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(loginButton)
        view.addSubview(resetPasswordButton)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConsts.topOffset),
            emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LayoutConsts.margin),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: LayoutConsts.margin),
            emailTextField.heightAnchor.constraint(equalToConstant: LayoutConsts.elementHeight),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: LayoutConsts.verticalOffset),
            passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LayoutConsts.margin),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: LayoutConsts.margin),
            passwordTextField.heightAnchor.constraint(equalToConstant: LayoutConsts.elementHeight),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: LayoutConsts.buttonsTopOffset),
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: LayoutConsts.elementHeight),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: LayoutConsts.verticalOffset),
            signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: LayoutConsts.elementHeight),
            
            resetPasswordButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: LayoutConsts.verticalOffset),
            resetPasswordButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: LayoutConsts.elementHeight),
            ])
    }
}

// MARK: - objc private functions
extension AuthorizationViewController {
    @objc
    private func signUp(sender: UIButton) {
        guard
            let enteredEmail = checkEmail(),
            let password = checkPassword() else {
                return
        }
        activityIndicator.start()
        Auth.auth().createUser(withEmail: enteredEmail, password: password) {
            user, error in
            
            guard
                let userData = user,
                let email = userData.user.email,
                let name = userData.user.displayName ?? email.getNameOfEmail() else {
                    self.activityIndicator.stop()
                    let alertDialog = AlertDialog(title: nil, message: error?.localizedDescription ?? "Возникла ошибка при обработке авторизационных данных")
                    alertDialog.showAlert(in: self, completion: nil)
                    return
            }
            
            if let error = error {
                self.activityIndicator.stop()
                let alertDialog = AlertDialog(title: nil, message: error.localizedDescription)
                alertDialog.showAlert(in: self, completion: nil)
            } else {
                let newUser = User(id: userData.user.uid, name: name, email: email)
                FirebaseController.shared.getDataController().saveData(newUser, with: userData.user.uid, in: DBTables.users) {
                    userResult in
                    
                    switch userResult {
                    case .success(let user):
                        let articlesSchedule = SubscriptionArticleSchedule()
                        let advicesSchedule = SubscriptionAdviceSchedule()
                        
                        FirebaseController.shared.getDataController().saveData(articlesSchedule, with: user.id, in: DBTables.articlesSchedule) {
                            (result: Result<SubscriptionArticleSchedule>) in
                            
                            switch result {
                            case .success(_):
                                FirebaseController.shared.getDataController().saveData(advicesSchedule, with: user.id, in: DBTables.advicesSchedule) {
                                    (result: Result<SubscriptionAdviceSchedule>) in
                                    
                                    switch result {
                                    case .success(_):
                                        //Внимание! Потенциально только одна запись в keychain допускается
                                        if !self.keychainController.keychainItemExists() {
                                            let keychainSaveResult = self.keychainController.save(login: enteredEmail, password: password)
                                            self.activityIndicator.stop()
                                            
                                            if keychainSaveResult,
                                                let _ = self.keychainController.readPassword(for: enteredEmail) {
                                                (UIApplication.shared.delegate as! AppDelegate).appManager.loggedIn(as: user)
                                                if self.calledByAppManager {
                                                    (UIApplication.shared.delegate as! AppDelegate).appManager.presentInitialController()
                                                } else {
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                            } else {
                                                let alertDialog = AlertDialog(title: nil, message: "Возникла ошибка с сохранением пароля в хранилище")
                                                alertDialog.showAlert(in: self, completion: nil)
                                            }
                                        }
                                    case .failure(let error):
                                        self.activityIndicator.stop()
                                        let alertDialog = AlertDialog(title: nil, message: error.getError())
                                        alertDialog.showAlert(in: self, completion: nil)
                                    }
                                }
                            case .failure(let error):
                                self.activityIndicator.stop()
                                let alertDialog = AlertDialog(title: nil, message: error.getError())
                                alertDialog.showAlert(in: self, completion: nil)
                            }
                        }
                        
                    
                        
                    case .failure(let error):
                        self.activityIndicator.stop()
                        let alertDialog = AlertDialog(title: nil, message: error.getError())
                        alertDialog.showAlert(in: self, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc
    private func login(sender: UIButton) {
        guard
            let email = checkEmail(),
            let password = checkPassword() else {
                return
        }
        
        performLogin(as: email, with: password)
    }
    
    @objc
    private func resetPassword(sender: UIButton) {
        guard let email = checkEmail() else {
            return
        }
        
        activityIndicator.start()
        Auth.auth().sendPasswordReset(withEmail: email) {
            error in
            
            self.activityIndicator.stop()
            let message = error == nil ? "Письмо о сбросе пароля успешно отправленона на указанный адрес электронной почты" : "\(error!.localizedDescription)"
            let alertDialog = AlertDialog(title: nil, message: message)
            alertDialog.showAlert(in: self, completion: nil)
        }
    }
    
    private func checkEmail() -> String? {
        guard
            let email = emailTextField.text,
            !email.isEmpty else {
                let alertDialog = AlertDialog(title: nil, message: "Введите, пожалуйста, свой адрес электронной почты")
                alertDialog.showAlert(in: self, completion: nil)
                return nil
        }
        
        return email
    }
    
    private func checkPassword() -> String? {
        guard
            let password = passwordTextField.text,
            !password.isEmpty else {
                let alertDialog = AlertDialog(title: nil, message: "Введите, пожалуйста, пароль")
                alertDialog.showAlert(in: self, completion: nil)
                return nil
        }
        
        return password
    }
    
    private func loginViaKeychain() {
        guard let credentials = keychainController.readCredentials() else {
            return
        }
        
        performLogin(as: credentials.login, with: credentials.password)
    }
    
    private func performLogin(as userName: String, with password: String) {
        DispatchQueue.main.async {
            self.activityIndicator.start()
        }
        Auth.auth().signIn(withEmail: userName, password: password) {
            user, error in
            
            DispatchQueue.main.async {
                self.activityIndicator.stop()
            }
                
            guard let userData = user else {
                DispatchQueue.main.async{
                    let alertDialog = AlertDialog(title: nil, message: error?.localizedDescription ?? "Возникла ошибка при обработке авторизационных данных")
                    alertDialog.showAlert(in: self, completion: {
                        _ in
                        
                        if self.calledByAppManager {
                            (UIApplication.shared.delegate as! AppDelegate).appManager.presentInitialController()
                        }
                    })
                }
                return
            }
            
            
            if let error = error {
                DispatchQueue.main.async {
                    let alertDialog = AlertDialog(title: nil, message: error.localizedDescription)
                    alertDialog.showAlert(in: self, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.start()
                }
                
                FirebaseController.shared.getDataController().fetchData(with: userData.user.uid, from: DBTables.users) {
                    (userResult: Result<User>) in
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stop()
                    }
                    
                    switch userResult {
                    case .success(let user):
                        DispatchQueue.main.async {
                            (UIApplication.shared.delegate as! AppDelegate).appManager.loggedIn(as: user)
                            
                            if !self.keychainController.keychainItemExists() {
                                let _ = self.keychainController.save(login: userName, password: password)
                            }
                            
                            if self.calledByAppManager {
                                (UIApplication.shared.delegate as! AppDelegate).appManager.presentInitialController()
                            } else {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            let alertDialog = AlertDialog(title: nil, message: error.getError())
                            alertDialog.showAlert(in: self, completion: {
                                _ in
                                
                                if self.calledByAppManager {
                                    (UIApplication.shared.delegate as! AppDelegate).appManager.presentInitialController()
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}

// MARK: - layout constants
extension AuthorizationViewController {
    private struct LayoutConsts {
        static let margin: CGFloat = 24
        static let topOffset: CGFloat = 80
        static let verticalOffset: CGFloat = 16
        static let buttonsTopOffset: CGFloat = 32
        static let elementHeight: CGFloat = 32
    }
}
