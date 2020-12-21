//
//  SignupViewController.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    var viewModel: SignupViewModelType?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 46)
        label.text = "Sign up"
       // label.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        label.text = "USERNAME"
        label.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        label.text = "PASSWORD"
        label.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        label.text = "CONFIRM PASSWORD"
        label.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    let usernameTextField: UITextField = {
       let textField = UITextField()
       textField.translatesAutoresizingMaskIntoConstraints = false
       //textField.placeholder = " username"
        textField.backgroundColor = .white
       textField.layer.cornerRadius = 5
       textField.layer.masksToBounds = true
       textField.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
       textField.layer.borderWidth = 1
       return textField
    }()
    
    let passwordTextField: UITextField = {
       let textField = UITextField()
       textField.translatesAutoresizingMaskIntoConstraints = false
      // textField.placeholder = " password"
       textField.backgroundColor = .white
       textField.layer.cornerRadius = 5
       textField.layer.masksToBounds = true
       textField.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
       textField.layer.borderWidth = 1
       return textField
    }()
    
    let confirmPasswordTextField: UITextField = {
       let textField = UITextField()
       textField.translatesAutoresizingMaskIntoConstraints = false
       //textField.placeholder = " password"
       textField.backgroundColor = .white
       textField.layer.cornerRadius = 5
       textField.layer.masksToBounds = true
       textField.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
       textField.layer.borderWidth = 1
       return textField
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.setTitle("Sign up", for: .normal)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        
        view.backgroundColor = .white
       
        view.addSubview(titleLabel)
        view.addSubview(usernameLabel)
        view.addSubview(passwordLabel)
        view.addSubview(confirmPasswordLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signupButton)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        signupButton.addTarget(self, action: #selector(tapOnSignup), for: .touchUpInside)
    }
    
    @objc func tapOnSignup() {
        viewModel?.signup(username: usernameTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text)
    }
    
    func setupConstraints() {
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        confirmPasswordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 5).isActive = true
        confirmPasswordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        confirmPasswordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 50).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

}


extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

