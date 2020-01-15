//
//  InitView.swift
//  ProjectDemo
//
//  Created by Jiwon Nam on 1/4/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol InitViewDelegate {
    func login()
    func register()
    func userInfo()
}

class InitView: UIView {
    
    var delegate: InitViewDelegate?
    var touchViews = [UITouch:TouchSpotView]()
    var touchEnable = true
    var idFilled = false
    var pswFilled = false
    var loginEnable = false
    var isEditing = false
    
    private var id: String?
    private var password: String?
    
    lazy var logoView: LogoView = {
        let view = LogoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        addSubview(view)
        
        return view
    } ()
    
    lazy var backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        addSubview(view)
        
        return view
    } ()
    
    lazy var idInputBar: UITextField = {
        let text = UITextField()
        text.tag = 0
        text.placeholder = "Please Enter your ID"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.borderStyle = .bezel
        text.textColor = .black
        text.clearButtonMode = .whileEditing
        addSubview(text)
        
        return text
    } ()
    
    lazy var passwordInputBar: UITextField = {
        let text = UITextField()
        text.tag = 1
        text.placeholder = "Please Enter your Password"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.borderStyle = .bezel
        text.textColor = .black
        text.clearButtonMode = .whileEditing
        addSubview(text)
        
        return text
       } ()
    
    lazy var loginBtnView: UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("LOGIN", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(loginBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    lazy var registerBtnView: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("REGISTER", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(registerBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    lazy var findUserInfo: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Find ID/PASSWORD", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(findInfoBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    @objc func loginBtnHandler(sender: Any) {
        delegate!.login()
    }
    
    @objc func registerBtnHandler(sender: Any) {
        delegate!.register()
    }
    
    @objc func findInfoBtnHandler(sender: Any) {
        delegate!.userInfo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if isEditing {
                endEditing(true)
                isEditing = false
            }
            createViewForTouch(touch: touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            removeViewForTouch(touch: touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let view = viewForTouch(touch: touch)
            // Move the view to the new location.
            let newLocation = touch.location(in: self)
            view?.center = newLocation
        }
    }
    
    func createViewForTouch( touch: UITouch) {
        let newView = TouchSpotView()
        newView.bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
        newView.center = touch.location(in: self)
        
        // Add the view and animate it to a new size.
        addSubview(newView)
        UIView.animate(withDuration: 0.2) {
            newView.bounds.size = CGSize(width: 100, height: 100)
        }
        
        // Save the views internally
        touchViews[touch] = newView
    }
    
    func viewForTouch (touch : UITouch) -> TouchSpotView? {
        return touchViews[touch]
    }
    
    func removeViewForTouch (touch : UITouch ) {
        if let view = touchViews[touch] {
            view.removeFromSuperview()
            touchViews.removeValue(forKey: touch)
        }
    }
}

class TouchSpotView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Update the corner radius when the bounds change.
    override var bounds: CGRect {
        get { return super.bounds }
        set(newBounds) {
            super.bounds = newBounds
            layer.cornerRadius = newBounds.size.width / 2.0
        }
    }
}
