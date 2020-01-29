//
//  NewGameView.swift
//  Demo
//
//  Created by Jiwon Nam on 1/27/20.
//  Copyright © 2020 Jiwon Nam. All rights reserved.
//

import UIKit

enum InputMode {
    case pad
    case pin
}

protocol NewGameViewDataSource {
    func getSelectedFrame() -> Int
    func getDate() -> CalendarData
}

class NewGameView: UIView, ScoreFrameViewDataSource {
    var dataSource: NewGameViewDataSource?
    var inputMode: InputMode = .pad
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(label)
        return label
    } ()
    
    lazy var scoreFrameView: ScoreFrameView = {
        let view = ScoreFrameView()
        view.dataSource = self
        addSubview(view)
        return view
    } ()
    
    lazy var changeInputMethodButton: UIButton = {
        let button = UIButton()
        button.setTitle("PAD", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.addTarget(self, action: #selector(changeInputMethod), for: UIControl.Event.touchDown)
        return button
    } ()
    
    lazy var scoreInputPadView: ScoreInputPadView = {
        let view = ScoreInputPadView()
        view.backgroundColor = .yellow
        return view
    } ()
    
    lazy var scoreInputPinsetView: ScoreInputPinsetView = {
        let view = ScoreInputPinsetView()
        view.backgroundColor = .green
        return view
    } ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        dateLabel.text = dataSource!.getDate().toString()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        changeInputMethodButton.removeFromSuperview()
        var rect = bounds
        
        (dateLabel.frame, rect) = rect.divided(atDistance: frame.maxY / 12, from: .minYEdge)
        
        (scoreFrameView.frame, rect) = rect.divided(atDistance: frame.maxY / 6, from: .minYEdge)
        if inputMode == .pad {
            scoreInputPinsetView.removeFromSuperview()
            (scoreInputPadView.frame, rect) = rect.divided(atDistance: 5 * frame.maxY / 6 - frame.maxY / 12, from: .minYEdge)
            addSubview(scoreInputPadView)
            changeInputMethodButton.setTitle("PAD", for: .normal)
        }
        else {
            scoreInputPadView.removeFromSuperview()
            (scoreInputPinsetView.frame, rect) = rect.divided(atDistance: 5 * frame.maxY / 6 - frame.maxY / 12, from: .minYEdge)
            addSubview(scoreInputPinsetView)
            changeInputMethodButton.setTitle("PIN", for: .normal)
        }
        changeInputMethodButton.frame = CGRect(x: bounds.maxX / 32, y: frame.maxY / 12 + frame.maxY / 6 + bounds.maxX / 32, width: bounds.maxX / 5, height: bounds.maxX / 10)
        addSubview(changeInputMethodButton)
    }
    
    func getSelectedFrame() -> Int {
        return dataSource!.getSelectedFrame()
    }
    
    @objc func changeInputMethod(sender: Any) {
        if inputMode == .pin {
            inputMode = .pad
        }
        else {
            inputMode = .pin
        }
        setNeedsLayout()
    }
}
