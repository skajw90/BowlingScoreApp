//
//  MenuView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/12/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

protocol TopMenuSetViewDelegate {
    func openProfile()
    func openScoreListView(date: CalendarData?)
    func openCalendar()
    func openCamera()
}

class TopMenuSetView: UIView {
    var delegate: TopMenuSetViewDelegate?
    
    lazy var profilePreview: UIButton = {
        let btn = UIButton()
        btn.setTitle("Profile", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(profilePrevBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    lazy var newGamePreview: UIButton = {
        let btn = UIButton()
        btn.setTitle("NEW", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(newGamePrevBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    lazy var calendarPreview: UIButton = {
        let btn = UIButton()
        btn.setTitle("CALENDAR", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(calendarPrevBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    lazy var cameraPreview: UIButton = {
        let btn = UIButton()
        btn.setTitle("CAMERA", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.addTarget(self, action: #selector(cameraPrevBtnHandler), for: UIControl.Event.touchDown)
        addSubview(btn)
        return btn
    } ()
    
    @objc func profilePrevBtnHandler(sender: Any) {
        print("profilePrev Clicked")
        delegate!.openProfile()
    }
    
    @objc func newGamePrevBtnHandler(sender: Any) {
        print("newGamePrev Clicked")
        delegate!.openScoreListView(date: nil)
    }
    
    @objc func calendarPrevBtnHandler(sender: Any) {
         print("calendarPrev Clicked")
        delegate!.openCalendar()
    }
    
    @objc func cameraPrevBtnHandler(sender: Any) {
         print("cameraPrev Clicked")
        delegate!.openCamera()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        (profilePreview.frame, rect) = rect.divided(atDistance: frame.width * 0.25, from: .minXEdge)
        
        (newGamePreview.frame, rect) = rect.divided(atDistance: frame.width * 0.25, from: .minXEdge)
        
        (calendarPreview.frame, rect) = rect.divided(atDistance: frame.width * 0.25, from: .minXEdge)
        
        (cameraPreview.frame, rect) = rect.divided(atDistance: frame.width * 0.25, from: .minXEdge)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
