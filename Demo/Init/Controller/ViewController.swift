//
//  ViewController.swift
//  Demo
//
//  Created by Jiwon Nam on 1/12/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, InitViewDelegate, UITextFieldDelegate {

    var initView: InitView {
        return view as! InitView
    }

    override func loadView() {
        view = InitView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView.frame = view.frame
        NSLayoutConstraint.activate([
            
            initView.backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            initView.backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            initView.backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            initView.backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            initView.logoView.leftAnchor.constraint(equalTo: view.leftAnchor),
            initView.logoView.topAnchor.constraint(equalTo: view.topAnchor),
            initView.logoView.rightAnchor.constraint(equalTo: view.rightAnchor),
            initView.logoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.333),
            
            initView.idInputBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            initView.idInputBar.topAnchor.constraint(equalTo: initView.logoView.bottomAnchor, constant: 30),
            initView.idInputBar.heightAnchor.constraint(equalTo: initView.logoView.heightAnchor, multiplier: 0.2),
            initView.idInputBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            initView.passwordInputBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            initView.passwordInputBar.topAnchor.constraint(equalTo: initView.idInputBar.bottomAnchor, constant: 10),
            initView.passwordInputBar.widthAnchor.constraint(equalTo: initView.idInputBar.widthAnchor),
            initView.passwordInputBar.heightAnchor.constraint(equalTo: initView.idInputBar.heightAnchor),

            initView.loginBtnView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            initView.loginBtnView.topAnchor.constraint(equalTo: initView.passwordInputBar.bottomAnchor, constant: 100),
            initView.loginBtnView.heightAnchor.constraint(equalTo: initView.passwordInputBar.heightAnchor, multiplier: 0.8),
            initView.loginBtnView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),

            initView.findUserInfo.leftAnchor.constraint(equalTo: view.leftAnchor),
            initView.findUserInfo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            initView.findUserInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            initView.findUserInfo.heightAnchor.constraint(equalTo: initView.loginBtnView.heightAnchor),

            initView.registerBtnView.leftAnchor.constraint(equalTo: initView.findUserInfo.rightAnchor),
            initView.registerBtnView.rightAnchor.constraint(equalTo: view.rightAnchor),
            initView.registerBtnView.topAnchor.constraint(equalTo: initView.findUserInfo.topAnchor),
            initView.registerBtnView.bottomAnchor.constraint(equalTo: initView.findUserInfo.bottomAnchor)

        ])
        
        initView.delegate = self
        initView.idInputBar.delegate = self
        initView.passwordInputBar.delegate = self
    }
    
    func login() {
        print("login")
        // send data to server login id,
        // checked, and if existed id go main
        // otherwise, show dialog or message box to user
        // that id or password does not match
        
        let controller = MainViewController()
        add(controller)
    }
    
    func register() {
        print("register")
    }
    
    func userInfo() {
        print("user info")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .lightGray
        initView.isEditing = true
        print("Editing is began")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Editing ended")
        if let text = textField.text, text.count > 0 {
            print(text)
            textField.backgroundColor = .white
            if textField.tag == 0 {
                initView.idFilled = true
            }
            else {
                initView.pswFilled = true
            }
            if initView.idFilled && initView.pswFilled {
                initView.loginBtnView.isEnabled = true
            }
        }
        else {
            print("not entered")
            textField.backgroundColor = .red
            initView.loginEnable = false
            if textField.tag == 0 {
                initView.idFilled = false
            }
            else {
                initView.pswFilled = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        initView.isEditing = false
        textField.resignFirstResponder()
        return true
    }
}

// extension class for uiview controller to add and remove view controller
extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
