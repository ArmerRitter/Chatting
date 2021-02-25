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
    let keyboardManager = KeyboardManager()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "TimesNewRomanPS-BoldMT", size:  39)
        label.numberOfLines = 2
        label.text = "Signup to\nget started"
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
    
    let confirmPasswordTextField: LoginTextField = {
    let textField = LoginTextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.attributedPlaceholder = NSAttributedString(string: "Confirm password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    textField.backgroundColor = .white
    textField.layer.cornerRadius = 10
    textField.layer.shadowColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5960784314, alpha: 1)
    textField.layer.shadowOpacity = 0.3
    textField.layer.shadowOffset = CGSize(width: 0, height: 15)
    textField.layer.shadowRadius = 15
    return textField
    }()
    
    let signupButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2901960784, blue: 0.5254901961, alpha: 1)
    button.titleLabel?.font = .boldSystemFont(ofSize: 17)
    button.setTitle("Sign up", for: .normal)
    button.layer.cornerRadius = 10
    button.layer.shadowColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5960784314, alpha: 1)
    button.layer.shadowOpacity = 0.3
    button.layer.shadowOffset = CGSize(width: 0, height: 15)
    button.layer.shadowRadius = 15
    return button
    }()
    
    var animatingConstraint: NSLayoutConstraint?
    
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
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signupButton)
       
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        keyboardManager.delegate = self
        
        signupButton.addTarget(self, action: #selector(tapOnSignup), for: .touchUpInside)
    }
    
    @objc func tapOnSignup() {
        viewModel?.signup(username: usernameTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text)
    }
    
    func setupConstraints() {
        
        animatingConstraint = titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        animatingConstraint?.isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor).isActive = true

        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmPasswordTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}


extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignupViewController: KeyboardManagerDelegate {
    func keyboardWillChange(keyboard frame: CGRect) {
        
    }
    
    
    
    
    func keyboardWillShow(keyboard frame: CGRect, duration: Double, options: UIView.AnimationOptions) {
       
        if frame.origin.y < 455 {
            
            let difference = 455 - frame.origin.y
            animatingConstraint?.constant = 50 - difference

            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    func keyboardWillHide(keyboard frame: CGRect, duration: Double, options: UIView.AnimationOptions) {
        
            animatingConstraint?.constant = 50

            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            })
    }

    func keyboardDidHide(keyboard frame: CGRect) {
        
    }
    
}

