//
//  LoginViewController.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var viewModel: LoginViewModelType?
    let keyboardManager = KeyboardManager()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "TimesNewRomanPS-BoldMT", size:  39)
        label.numberOfLines = 3
        label.text = "Hello Again!\nWelcome\nback"
        label.textColor = #colorLiteral(red: 0.05490196078, green: 0.2901960784, blue: 0.5254901961, alpha: 1)
        return label
    }()
    
    let usernameTextField: LoginTextField = {
       let textField = LoginTextField()
       textField.translatesAutoresizingMaskIntoConstraints = false
       textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
       textField.backgroundColor = .white
       textField.layer.cornerRadius = 10
       textField.layer.shadowColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5960784314, alpha: 1)
       textField.layer.shadowOpacity = 0.3
       textField.layer.shadowOffset = CGSize(width: 0, height: 15)
       textField.layer.shadowRadius = 15
       return textField
    }()
    
    let passwordTextField: LoginTextField = {
       let textField = LoginTextField()
       textField.translatesAutoresizingMaskIntoConstraints = false
       textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
       textField.backgroundColor = .white
       textField.layer.cornerRadius = 10
       textField.layer.shadowColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5960784314, alpha: 1)
       textField.layer.shadowOpacity = 0.3
       textField.layer.shadowOffset = CGSize(width: 0, height: 15)
       textField.layer.shadowRadius = 15
       return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2901960784, blue: 0.5254901961, alpha: 1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.setTitle("Log in", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5960784314, alpha: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 15)
        button.layer.shadowRadius = 15
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Sign up", for: .normal)
        return button
    }()
    
    let newAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 13)
        label.text = "Don't have an account?"
        label.textColor = #colorLiteral(red: 0.01568627451, green: 0.07450980392, blue: 0.2156862745, alpha: 1)
        return label
    }()
    
    var animatingConstraint: NSLayoutConstraint?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        view.addSubview(newAccountLabel)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        keyboardManager.delegate = self
        
        loginButton.addTarget(self, action: #selector(tapOnLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(tapOnSignup), for: .touchUpInside)
    }
    
    @objc func tapOnLogin() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        viewModel?.login(username: usernameTextField.text, password: passwordTextField.text)
    }
    
    @objc func tapOnSignup() {
        viewModel?.router?.signupViewController()
    }
    
    func setupConstraints() {
        
        animatingConstraint = titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        animatingConstraint?.isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor).isActive = true
        
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        newAccountLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        newAccountLabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor).isActive = true
        
        signupButton.centerYAnchor.constraint(equalTo: newAccountLabel.centerYAnchor).isActive = true
        signupButton.leadingAnchor.constraint(equalTo: newAccountLabel.trailingAnchor, constant: 5).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension LoginViewController: KeyboardManagerDelegate {
    func keyboardWillChange(keyboard frame: CGRect) {
        
    }
    
    
    
    func keyboardDidHide(keyboard frame: CGRect) {
        
    }
    
   
    
    func keyboardWillShow(keyboard frame: CGRect, duration: Double, options: UIView.AnimationOptions) {
       
        if frame.origin.y < 450 {
            
            let difference = 450 - frame.origin.y
            animatingConstraint?.constant = 100 - difference

            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    func keyboardWillHide(keyboard frame: CGRect, duration: Double, options: UIView.AnimationOptions) {
        
            animatingConstraint?.constant = 100

            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            })
    }
    

}
