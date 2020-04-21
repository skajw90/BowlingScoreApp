//
//  RegisterView.swift
//  Demo
//
//  Created by Jiwon Nam on 3/10/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class RegisterView: UIView {
    
    lazy var titleLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "REGISTER"
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    lazy var nameLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Name: "
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1
        field.textColor = .black
        field.backgroundColor = .white
        addSubview(field)
        return field
    } ()
    
    lazy var emailLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Email: "
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    lazy var emailTextField: UITextField = {
        let field = UITextField()
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1
        field.textColor = .black
        field.backgroundColor = .white
        addSubview(field)
        return field
    } ()
    
    lazy var passwordLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Password: "
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
    
    lazy var passwordTextField: UITextField = {
        let field = UITextField()
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1
        field.textColor = .black
        field.backgroundColor = .white
        addSubview(field)
        return field
    } ()
    
    lazy var passwordConfirmLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Password: "
        label.textAlignment = .left
        label.textColor = .black
        addSubview(label)
        return label
    } ()
        
    lazy var passwordConfirmTextField: UITextField = {
        let field = UITextField()
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1
        field.textColor = .black
        field.backgroundColor = .white
        addSubview(field)
        return field
    } ()
    
    lazy var cancelBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        addSubview(button)
        return button
    } ()
    
    lazy var confirmBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Confirm", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        addSubview(button)
        return button
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        var rect = bounds
        (_, rect) = rect.divided(atDistance: frame.height / 20, from: .minYEdge)
        (titleLabel.frame, rect) = rect.divided(atDistance: frame.height / 10, from: .minYEdge)
        (_, rect) = rect.divided(atDistance: frame.height / 18, from: .minYEdge)
        var nameRect = CGRect()
        (nameRect, rect) = rect.divided(atDistance: frame.height / 20, from: .minYEdge)
        (nameLabel.frame, nameRect) = nameRect.divided(atDistance: frame.width / 3, from: .minXEdge)
        (nameTextField.frame, nameRect) = nameRect.divided(atDistance: frame.width / 2, from: .minXEdge)
        (_, rect) = rect.divided(atDistance: frame.height / 18, from: .minYEdge)
        
        var emailRect = CGRect()
        (emailRect, rect) = rect.divided(atDistance: frame.height / 20, from: .minYEdge)
        (emailLabel.frame, emailRect) = emailRect.divided(atDistance: frame.width / 3, from: .minXEdge)
        (emailTextField.frame, emailRect) = emailRect.divided(atDistance: frame.width / 2, from: .minXEdge)
        (_, rect) = rect.divided(atDistance: frame.height / 18, from: .minYEdge)
        
        var passwordRect = CGRect()
        (passwordRect, rect) = rect.divided(atDistance: frame.height / 20, from: .minYEdge)
        (passwordLabel.frame, passwordRect) = passwordRect.divided(atDistance: frame.width / 3, from: .minXEdge)
        (passwordTextField.frame, passwordRect) = passwordRect.divided(atDistance: frame.width / 2, from: .minXEdge)
        (_, rect) = rect.divided(atDistance: frame.height / 18, from: .minYEdge)
        
        var passwordConfirmRect = CGRect()
        (passwordConfirmRect, rect) = rect.divided(atDistance: frame.height / 20, from: .minYEdge)
        (passwordConfirmLabel.frame, passwordConfirmRect) = passwordConfirmRect.divided(atDistance: frame.width / 3, from: .minXEdge)
        (passwordConfirmTextField.frame, passwordConfirmRect) = passwordConfirmRect.divided(atDistance: frame.width / 2, from: .minXEdge)
        (_, rect) = rect.divided(atDistance: frame.height / 10, from: .minYEdge)
        
        var buttonRect = CGRect()
        (buttonRect, rect) = rect.divided(atDistance: frame.height / 20, from: .minYEdge)
        // add button pos
        
    }
}
